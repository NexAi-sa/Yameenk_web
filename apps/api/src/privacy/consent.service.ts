/**
 * خدمة إدارة الموافقات — Consent Service
 * التحقق من الموافقة الصريحة قبل أي جمع أو معالجة للبيانات
 *
 * الإطار القانوني المتبع:
 * - PDPL المادة 6   : الأسس المشروعة للمعالجة (ضرورة طبية، مصالح حيوية، عقد)
 * - PDPL المادة 29  : نقل البيانات لخارج المملكة (موافقة صريحة مستقلة)
 * - وزارة الصحة     : الاحتفاظ بالسجلات الطبية 10 سنوات (إلزامي)
 */
import { Injectable, ForbiddenException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { AuditService } from './audit.service';

// ══════════════════════════════════════════════════════════════════
// أنواع الموافقات
// ══════════════════════════════════════════════════════════════════
export type ConsentType =
  // ── أساسية لتشغيل الخدمة ──
  | 'health_data_collection'           // جمع القراءات الصحية [PDPL المادة 6(2)]
  | 'ai_analysis'                      // تحليل الذكاء الاصطناعي للبيانات [PDPL 6(2)+موافقة]
  | 'predictive_health_monitoring'     // التنبؤ بالأمراض الصامتة [PDPL 6(2) - ضرورة طبية]
  | 'cross_border_ai_transfer'         // نقل بيانات مجهولة لـ Gemini/Claude [PDPL المادة 29]
  | 'medical_records_retention'        // احتفاظ 10 سنوات [إلزامي - وزارة الصحة]
  | 'emergency_family_access'          // وصول الأسرة في الطوارئ [PDPL 6(1) - مصالح حيوية]
  // ── اختيارية ──
  | 'whatsapp_notifications'
  | 'push_notifications'
  | 'analytics'
  | 'marketing';

/** الأساس القانوني لكل نوع معالجة */
export const LEGAL_BASIS: Record<ConsentType, string> = {
  health_data_collection:          'PDPL Art. 6(2) — Medical necessity for patient care',
  ai_analysis:                     'PDPL Art. 6(2) + Explicit consent — AI-assisted health monitoring',
  predictive_health_monitoring:    'PDPL Art. 6(2) — Early detection prevents health harm (vital interest)',
  cross_border_ai_transfer:        'PDPL Art. 29 — Explicit consent for anonymized transfer to AI provider',
  medical_records_retention:       'Legal obligation — MOH regulation requires 10-year retention',
  emergency_family_access:         'PDPL Art. 6(1) — Vital interests of the data subject',
  whatsapp_notifications:          'Consent',
  push_notifications:              'Consent',
  analytics:                       'Consent',
  marketing:                       'Consent',
};

/**
 * الموافقات المطلوبة لتشغيل الخدمة الأساسية
 * بدونها لا تعمل المنصة
 */
export const REQUIRED_CONSENTS: ConsentType[] = [
  'health_data_collection',
  'medical_records_retention',
];

/**
 * الموافقات المطلوبة للميزات المتقدمة (التنبؤ + الذكاء الاصطناعي)
 * يُمكن استخدام الخدمة الأساسية بدونها
 */
export const AI_FEATURE_CONSENTS: ConsentType[] = [
  'ai_analysis',
  'predictive_health_monitoring',
  'cross_border_ai_transfer',
];

/** الموافقات الاختيارية — معطّلة افتراضياً (Privacy as Default) */
export const OPT_IN_CONSENTS: ConsentType[] = ['analytics', 'marketing'];

export interface ConsentRecord {
  consent_type: ConsentType;
  granted: boolean;
  granted_at: string | null;
  revoked_at: string | null;
  consent_version: string;
  legal_basis?: string;
}

/** نطاقات وكالة البيانات الطبية */
export type AgencyScope =
  | 'health_monitoring'
  | 'anomaly_alerts'
  | 'ai_analysis'
  | 'predictive_health'
  | 'family_dashboard_access';

export interface AgencyAuthority {
  patientId: string;
  agentUserId: string;
  scope: AgencyScope[];
  expiresAt: string;
  legalCapacity: 'patient_self' | 'legal_guardian' | 'power_of_attorney';
}

// ══════════════════════════════════════════════════════════════════
// الخدمة
// ══════════════════════════════════════════════════════════════════
@Injectable()
export class ConsentService {
  constructor(
    private supabase: SupabaseService,
    private auditService: AuditService,
  ) {}

  // ─── قراءة الموافقات ─────────────────────────────────────────

  async getUserConsents(userId: string): Promise<ConsentRecord[]> {
    const { data, error } = await this.supabase.db
      .from('user_consents')
      .select('consent_type, granted, granted_at, revoked_at, consent_version')
      .eq('user_id', userId);

    if (error) throw error;

    return ((data ?? []) as ConsentRecord[]).map((r) => ({
      ...r,
      legal_basis: LEGAL_BASIS[r.consent_type as ConsentType],
    }));
  }

  async hasConsent(userId: string, type: ConsentType): Promise<boolean> {
    const { data } = await this.supabase.db
      .from('user_consents')
      .select('granted')
      .eq('user_id', userId)
      .eq('consent_type', type)
      .single();

    return data?.granted === true;
  }

  // ─── التحقق من الموافقة أو الوكالة ──────────────────────────

  /**
   * التحقق من الموافقة المباشرة — يرمي خطأ إذا لم تُمنح
   */
  async requireConsent(userId: string, type: ConsentType): Promise<void> {
    const granted = await this.hasConsent(userId, type);
    if (!granted) {
      throw new ForbiddenException(
        `الموافقة مطلوبة: ${this.consentTypeAr(type)}. يرجى الموافقة أولاً من إعدادات الخصوصية.`,
      );
    }
  }

  /**
   * التحقق من الموافقة — مع قبول وكالة البيانات الطبية كبديل قانوني
   *
   * السيناريو: فرد الأسرة يتابع مسناً لم يمنح الموافقة مباشرةً
   * الحل: وكالة موقّعة من المريض أو وليّه تُعوّض الموافقة المباشرة
   */
  async requireConsentOrAgency(
    userId: string,
    patientId: string,
    type: ConsentType,
    requiredScope: AgencyScope,
  ): Promise<{ via: 'consent' | 'agency'; authority?: AgencyAuthority }> {
    // أولاً: تحقق من الموافقة المباشرة للمستخدم
    const hasDirectConsent = await this.hasConsent(userId, type);
    if (hasDirectConsent) {
      return { via: 'consent' };
    }

    // ثانياً: تحقق من وكالة البيانات الطبية النشطة
    const agency = await this.getActiveAgency(patientId, userId, requiredScope);
    if (agency) {
      return { via: 'agency', authority: agency };
    }

    // لا موافقة ولا وكالة — ارفض مع توضيح الخيارين
    throw new ForbiddenException(
      `للوصول لهذه البيانات، تحتاج إما:\n` +
      `1. موافقة المريض الصريحة على "${this.consentTypeAr(type)}"\n` +
      `2. وكالة بيانات طبية موقّعة تشمل "${requiredScope}"\n` +
      `راجع إعدادات الخصوصية لإعداد الوكالة.`,
    );
  }

  /**
   * التحقق الخاص بحالات الطوارئ
   * PDPL المادة 6(1): المصالح الحيوية لا تشترط موافقة مسبقة
   */
  async canAccessForEmergency(
    agentUserId: string,
    patientId: string,
  ): Promise<boolean> {
    // وكالة نشطة تشمل anomaly_alerts = وصول طوارئ مشروع
    const agency = await this.getActiveAgency(patientId, agentUserId, 'anomaly_alerts');
    if (agency) return true;

    // أو موافقة صريحة على وصول الطوارئ
    return this.hasConsent(agentUserId, 'emergency_family_access');
  }

  // ─── الوكالة الطبية ──────────────────────────────────────────

  /**
   * جلب وكالة نشطة لوكيل محدد تشمل نطاقاً معيناً
   */
  async getActiveAgency(
    patientId: string,
    agentUserId: string,
    requiredScope: AgencyScope,
  ): Promise<AgencyAuthority | null> {
    const { data } = await this.supabase.db
      .from('medical_data_agencies')
      .select('patient_id, agent_user_id, agency_scope, expires_at, legal_capacity')
      .eq('patient_id', patientId)
      .eq('agent_user_id', agentUserId)
      .eq('is_active', true)
      .gt('expires_at', new Date().toISOString())
      .single();

    if (!data) return null;
    if (!data.agency_scope?.includes(requiredScope)) return null;

    return {
      patientId: data.patient_id,
      agentUserId: data.agent_user_id,
      scope: data.agency_scope as AgencyScope[],
      expiresAt: data.expires_at,
      legalCapacity: data.legal_capacity,
    };
  }

  /**
   * تسجيل وكالة بيانات طبية جديدة
   */
  async registerAgency(params: {
    patientId: string;
    grantedByUserId: string;
    agentUserId: string;
    relationship: string;
    legalCapacity: 'patient_self' | 'legal_guardian' | 'power_of_attorney';
    legalDocumentRef?: string;
    scope: AgencyScope[];
    ipAddress?: string;
    deviceInfo?: string;
    signatureHash?: string;
  }): Promise<string> {
    const expiresAt = new Date();
    expiresAt.setFullYear(expiresAt.getFullYear() + 1);

    const { data, error } = await this.supabase.db
      .from('medical_data_agencies')
      .upsert(
        {
          patient_id: params.patientId,
          granted_by_user_id: params.grantedByUserId,
          agent_user_id: params.agentUserId,
          relationship: params.relationship,
          legal_capacity: params.legalCapacity,
          legal_document_ref: params.legalDocumentRef ?? null,
          agency_scope: params.scope,
          expires_at: expiresAt.toISOString(),
          is_active: true,
          revoked_at: null,
          ip_address: params.ipAddress ?? null,
          device_info: params.deviceInfo ?? null,
          signature_hash: params.signatureHash ?? null,
        },
        { onConflict: 'patient_id,agent_user_id' },
      )
      .select('id')
      .single();

    if (error) throw error;

    await this.auditService.log({
      userId: params.grantedByUserId,
      action: 'grant_consent',
      resourceType: 'consent',
      resourceId: params.patientId,
      metadata: {
        type: 'medical_data_agency',
        agent_user_id: params.agentUserId,
        scope: params.scope,
        legal_capacity: params.legalCapacity,
        expires_at: expiresAt.toISOString(),
      },
      ipAddress: params.ipAddress,
    });

    return data!.id;
  }

  /**
   * إلغاء وكالة قائمة
   */
  async revokeAgency(
    agencyId: string,
    revokedByUserId: string,
    reason?: string,
  ): Promise<void> {
    const { error } = await this.supabase.db
      .from('medical_data_agencies')
      .update({
        is_active: false,
        revoked_at: new Date().toISOString(),
        revocation_reason: reason ?? 'إلغاء من قِبل المريض أو وليّه',
        revoked_by_user_id: revokedByUserId,
      })
      .eq('id', agencyId);

    if (error) throw error;

    await this.auditService.log({
      userId: revokedByUserId,
      action: 'revoke_consent',
      resourceType: 'consent',
      resourceId: agencyId,
      metadata: { type: 'medical_data_agency_revocation', reason },
    });
  }

  /**
   * قائمة وكالات مريض
   */
  async getPatientAgencies(patientId: string) {
    const { data, error } = await this.supabase.db
      .from('medical_data_agencies')
      .select(`
        id, relationship, legal_capacity, agency_scope,
        granted_at, expires_at, is_active,
        agent_user_id
      `)
      .eq('patient_id', patientId)
      .order('granted_at', { ascending: false });

    if (error) throw error;
    return data ?? [];
  }

  // ─── نقل البيانات عبر الحدود ────────────────────────────────

  /**
   * تسجيل كل عملية نقل بيانات لخارج المملكة (PDPL المادة 29)
   * يُستدعى تلقائياً قبل كل استدعاء لـ Gemini/Claude
   */
  async logCrossBorderTransfer(params: {
    patientId: string;
    service: 'gemini_api' | 'claude_api';
    dataCategories: string[];
    consentId?: string;
  }): Promise<void> {
    const serviceInfo = {
      gemini_api: { org: 'Google LLC', country: 'US' },
      claude_api: { org: 'Anthropic PBC', country: 'US' },
    };

    await this.supabase.db.from('cross_border_transfers').insert({
      patient_id: params.patientId,
      recipient_service: params.service,
      recipient_country: serviceInfo[params.service].country,
      recipient_org: serviceInfo[params.service].org,
      data_categories: params.dataCategories,
      anonymization_applied: true,
      legal_basis: 'explicit_consent',
      user_consent_id: params.consentId ?? null,
      recipient_adequacy_mechanism: 'standard_contractual_clauses',
      data_deleted_after_processing: true,
    });
  }

  // ─── إدارة الموافقات ─────────────────────────────────────────

  async hasCompletedRequiredConsents(userId: string): Promise<boolean> {
    for (const type of REQUIRED_CONSENTS) {
      const granted = await this.hasConsent(userId, type);
      if (!granted) return false;
    }
    return true;
  }

  async hasAiFeatureConsents(userId: string): Promise<boolean> {
    for (const type of AI_FEATURE_CONSENTS) {
      const granted = await this.hasConsent(userId, type);
      if (!granted) return false;
    }
    return true;
  }

  async grantConsent(
    userId: string,
    type: ConsentType,
    ipAddress?: string,
  ): Promise<void> {
    const { error } = await this.supabase.db
      .from('user_consents')
      .upsert(
        {
          user_id: userId,
          consent_type: type,
          granted: true,
          granted_at: new Date().toISOString(),
          revoked_at: null,
          ip_address: ipAddress ?? null,
          consent_version: '2.0',
        },
        { onConflict: 'user_id,consent_type' },
      );

    if (error) throw error;

    await this.auditService.log({
      userId,
      action: 'grant_consent',
      resourceType: 'consent',
      metadata: {
        consent_type: type,
        legal_basis: LEGAL_BASIS[type],
      },
      ipAddress,
    });
  }

  async revokeConsent(
    userId: string,
    type: ConsentType,
    ipAddress?: string,
  ): Promise<void> {
    const { error } = await this.supabase.db
      .from('user_consents')
      .update({
        granted: false,
        revoked_at: new Date().toISOString(),
      })
      .eq('user_id', userId)
      .eq('consent_type', type);

    if (error) throw error;

    await this.auditService.log({
      userId,
      action: 'revoke_consent',
      resourceType: 'consent',
      metadata: { consent_type: type },
      ipAddress,
    });
  }

  async initializeConsents(userId: string): Promise<void> {
    const allTypes: ConsentType[] = [
      'health_data_collection',
      'ai_analysis',
      'predictive_health_monitoring',
      'cross_border_ai_transfer',
      'medical_records_retention',
      'emergency_family_access',
      'whatsapp_notifications',
      'push_notifications',
      'analytics',
      'marketing',
    ];

    const records = allTypes.map((type) => ({
      user_id: userId,
      consent_type: type,
      granted: false,
      consent_version: '2.0',
    }));

    await this.supabase.db
      .from('user_consents')
      .upsert(records, { onConflict: 'user_id,consent_type' });
  }

  private consentTypeAr(type: ConsentType): string {
    const map: Record<ConsentType, string> = {
      health_data_collection:          'جمع البيانات الصحية',
      ai_analysis:                     'تحليل الذكاء الاصطناعي',
      predictive_health_monitoring:    'التنبؤ بالأمراض الصامتة',
      cross_border_ai_transfer:        'نقل البيانات لخارج المملكة',
      medical_records_retention:       'الاحتفاظ بالسجلات الطبية',
      emergency_family_access:         'وصول الأسرة في الطوارئ',
      whatsapp_notifications:          'إشعارات واتساب',
      push_notifications:              'إشعارات التطبيق',
      analytics:                       'التحليلات',
      marketing:                       'التسويق',
    };
    return map[type] ?? type;
  }
}
