/**
 * متحكم الخصوصية — Privacy Controller
 * واجهة REST لإدارة الموافقات، تصدير البيانات، حذف الحساب
 */
import {
  Controller,
  Get,
  Post,
  Delete,
  Body,
  Param,
  Req,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { ConsentService, ConsentType, AgencyScope } from './consent.service';
import { AuditService } from './audit.service';
import { SupabaseService } from '../supabase/supabase.service';

@Controller('privacy')
export class PrivacyController {
  constructor(
    private consentService: ConsentService,
    private auditService: AuditService,
    private supabase: SupabaseService,
  ) {}

  // ——— إدارة الموافقات ———

  @Get('consents')
  async getConsents(@Req() req: any) {
    const userId = req.user?.id;
    return this.consentService.getUserConsents(userId);
  }

  @Post('consents')
  @HttpCode(HttpStatus.OK)
  async grantConsent(
    @Req() req: any,
    @Body() body: { consent_type: ConsentType },
  ) {
    const userId = req.user?.id;
    const ip = req.ip;
    await this.consentService.grantConsent(userId, body.consent_type, ip);
    return { message: 'تم منح الموافقة بنجاح' };
  }

  @Post('consents/batch')
  @HttpCode(HttpStatus.OK)
  async grantMultipleConsents(
    @Req() req: any,
    @Body() body: { consents: Array<{ type: ConsentType; granted: boolean }> },
  ) {
    const userId = req.user?.id;
    const ip = req.ip;

    for (const consent of body.consents) {
      if (consent.granted) {
        await this.consentService.grantConsent(userId, consent.type, ip);
      }
    }
    return { message: 'تم تحديث الموافقات بنجاح' };
  }

  @Delete('consents/:type')
  @HttpCode(HttpStatus.OK)
  async revokeConsent(
    @Req() req: any,
    @Param('type') type: ConsentType,
  ) {
    const userId = req.user?.id;
    const ip = req.ip;
    await this.consentService.revokeConsent(userId, type, ip);
    return { message: 'تم سحب الموافقة بنجاح' };
  }

  @Get('consents/status')
  async getConsentStatus(@Req() req: any) {
    const userId = req.user?.id;
    const completed = await this.consentService.hasCompletedRequiredConsents(userId);
    return { consents_completed: completed };
  }

  // ——— تصدير البيانات ———

  @Get('my-data')
  async exportMyData(@Req() req: any) {
    const userId = req.user?.id;

    // تسجيل عملية تصدير البيانات في سجل التدقيق
    await this.auditService.log({
      userId,
      action: 'export_data',
      resourceType: 'user',
      ipAddress: req.ip,
    });

    // جمع جميع بيانات المستخدم
    const [
      { data: profile },
      { data: patients },
      { data: familyLinks },
      { data: consents },
    ] = await Promise.all([
      this.supabase.db.from('users').select('*').eq('id', userId).single(),
      this.supabase.db.from('patients').select('*').eq('user_id', userId),
      this.supabase.db.from('family_patients').select('*').eq('family_user_id', userId),
      this.supabase.db.from('user_consents').select('*').eq('user_id', userId),
    ]);

    // جمع بيانات المرضى المرتبطين
    const patientIds = [
      ...(patients ?? []).map((p: any) => p.id),
      ...(familyLinks ?? []).map((f: any) => f.patient_id),
    ];

    let readings: any[] = [];
    let chatMessages: any[] = [];
    let medications: any[] = [];
    let bookings: any[] = [];

    if (patientIds.length > 0) {
      const [readingsRes, chatRes, medsRes, bookingsRes] = await Promise.all([
        this.supabase.db.from('health_readings').select('*').in('patient_id', patientIds),
        this.supabase.db.from('chat_messages').select('*').eq('user_id', userId),
        this.supabase.db.from('medications').select('*').in('patient_id', patientIds),
        this.supabase.db.from('bookings').select('*').eq('family_user_id', userId),
      ]);
      readings = readingsRes.data ?? [];
      chatMessages = chatRes.data ?? [];
      medications = medsRes.data ?? [];
      bookings = bookingsRes.data ?? [];
    }

    return {
      export_date: new Date().toISOString(),
      format_version: '1.0',
      user_profile: profile,
      consents,
      patients,
      family_links: familyLinks,
      health_readings: readings,
      chat_messages: chatMessages,
      medications,
      bookings,
    };
  }

  // ——— حذف الحساب ———

  @Delete('account')
  @HttpCode(HttpStatus.OK)
  async deleteAccount(@Req() req: any) {
    const userId = req.user?.id;

    // تسجيل طلب الحذف
    await this.auditService.log({
      userId,
      action: 'delete_account',
      resourceType: 'user',
      ipAddress: req.ip,
    });

    // إنشاء سجل طلب الحذف
    await this.supabase.db.from('data_deletion_requests').insert({
      user_id: userId,
      status: 'processing',
      scheduled_purge_at: new Date().toISOString(),
    });

    // حذف جميع البيانات المرتبطة بالمستخدم
    // CASCADE سيحذف الموافقات والرسائل والقراءات تلقائياً
    const { data: patients } = await this.supabase.db
      .from('patients')
      .select('id')
      .eq('user_id', userId);

    const patientIds = (patients ?? []).map((p: any) => p.id);

    if (patientIds.length > 0) {
      // حذف البيانات الصحية
      await this.supabase.db.from('health_readings').delete().in('patient_id', patientIds);
      await this.supabase.db.from('chat_messages').delete().in('patient_id', patientIds);
      await this.supabase.db.from('medications').delete().in('patient_id', patientIds);
      await this.supabase.db.from('reading_schedules').delete().in('patient_id', patientIds);
      await this.supabase.db.from('bookings').delete().in('patient_id', patientIds);
      await this.supabase.db.from('family_patients').delete().in('patient_id', patientIds);
      await this.supabase.db.from('patients').delete().in('id', patientIds);
    }

    // حذف الموافقات وبيانات المستخدم
    await this.supabase.db.from('user_consents').delete().eq('user_id', userId);
    await this.supabase.db.from('family_patients').delete().eq('family_user_id', userId);
    await this.supabase.db.from('bookings').delete().eq('family_user_id', userId);
    await this.supabase.db.from('notification_logs').delete().eq('user_id', userId);

    // تحديث طلب الحذف
    await this.supabase.db
      .from('data_deletion_requests')
      .update({ status: 'completed', completed_at: new Date().toISOString() })
      .eq('user_id', userId)
      .eq('status', 'processing');

    // حذف حساب المستخدم أخيراً
    await this.supabase.db.from('users').delete().eq('id', userId);

    return { message: 'تم حذف حسابك وجميع بياناتك بنجاح' };
  }

  // ——— وكالة البيانات الطبية ———

  @Post('agency')
  @HttpCode(HttpStatus.OK)
  async registerAgency(
    @Req() req: any,
    @Body()
    body: {
      patient_id: string;
      agent_user_id: string;
      relationship: string;
      legal_capacity: 'patient_self' | 'legal_guardian' | 'power_of_attorney';
      legal_document_ref?: string;
      scope: AgencyScope[];
      device_info?: string;
    },
  ) {
    const userId = req.user?.id;
    const agencyId = await this.consentService.registerAgency({
      patientId: body.patient_id,
      grantedByUserId: userId,
      agentUserId: body.agent_user_id,
      relationship: body.relationship,
      legalCapacity: body.legal_capacity,
      legalDocumentRef: body.legal_document_ref,
      scope: body.scope,
      ipAddress: req.ip,
      deviceInfo: body.device_info,
    });
    return { message: 'تم تسجيل وكالة البيانات الطبية بنجاح', agency_id: agencyId };
  }

  @Get('agency/:patientId')
  async getAgencies(@Param('patientId') patientId: string) {
    return this.consentService.getPatientAgencies(patientId);
  }

  @Delete('agency/:agencyId')
  @HttpCode(HttpStatus.OK)
  async revokeAgency(
    @Req() req: any,
    @Param('agencyId') agencyId: string,
    @Body() body: { reason?: string },
  ) {
    const userId = req.user?.id;
    await this.consentService.revokeAgency(agencyId, userId, body.reason);
    return { message: 'تم إلغاء الوكالة بنجاح' };
  }

  // ——— سجل التدقيق ———

  @Get('audit-log')
  async getAuditLog(@Req() req: any) {
    const userId = req.user?.id;

    await this.auditService.log({
      userId,
      action: 'view_audit_log',
      ipAddress: req.ip,
    });

    return this.auditService.getUserAuditLog(userId);
  }
}
