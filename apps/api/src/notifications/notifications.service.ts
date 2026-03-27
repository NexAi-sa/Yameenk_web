import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { SupabaseService } from '../supabase/supabase.service';

interface AnomalyAlertPayload {
  patientId: string;
  patientName: string;
  readingType: string;
  value: number;
  value2?: number;
  unit: string;
  recommendation: string;
}

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);
  private readonly waApiUrl = 'https://graph.facebook.com/v19.0';

  constructor(
    private supabase: SupabaseService,
    private config: ConfigService,
  ) {}

  async sendAnomalyAlert(payload: AnomalyAlertPayload) {
    // Fetch family members who want WhatsApp notifications
    const { data: familyLinks } = await this.supabase.db
      .from('family_patients')
      .select('family_user_id, users(whatsapp_id, name)')
      .eq('patient_id', payload.patientId)
      .eq('notify_whatsapp', true);

    if (!familyLinks || familyLinks.length === 0) return;

    const readingTypeAr = this.readingTypeAr(payload.readingType);
    const valueStr =
      payload.value2
        ? `${payload.value}/${payload.value2} ${payload.unit}`
        : `${payload.value} ${payload.unit}`;

    const message = this.buildAnomalyMessage(
      payload.patientName,
      readingTypeAr,
      valueStr,
      payload.recommendation,
    );

    // Send to each family member
    for (const link of familyLinks) {
      const user = link.users as any;
      if (!user?.whatsapp_id) continue;

      await this.sendWhatsAppMessage(user.whatsapp_id, message);
      await this.logNotification(payload.patientId, link.family_user_id, 'anomaly_alert', message);
    }
  }

  async sendReadingReminder(patientId: string, readingType: string) {
    const { data: patient } = await this.supabase.db
      .from('patients')
      .select('full_name')
      .eq('id', patientId)
      .single();

    if (!patient) return;

    // Check quiet hours (10pm - 7am)
    const hour = new Date().getHours();
    if (hour >= 22 || hour < 7) {
      this.logger.log(`Quiet hours — deferring reminder for patient ${patientId}`);
      return;
    }

    const { data: familyLinks } = await this.supabase.db
      .from('family_patients')
      .select('family_user_id, users(whatsapp_id)')
      .eq('patient_id', patientId)
      .eq('notify_whatsapp', true);

    if (!familyLinks || familyLinks.length === 0) return;

    const readingTypeAr = this.readingTypeAr(readingType);
    const message = `⏰ تذكير\n\n${patient.full_name} لم يسجل قراءة ${readingTypeAr} اليوم.\n\nرد "ذكّره" وسنرسل له تذكيراً فورياً.`;

    for (const link of familyLinks) {
      const user = link.users as any;
      if (!user?.whatsapp_id) continue;
      await this.sendWhatsAppMessage(user.whatsapp_id, message);
      await this.logNotification(patientId, link.family_user_id, 'reading_reminder', message);
    }
  }

  async sendBookingConfirmation(bookingId: string) {
    const { data: booking } = await this.supabase.db
      .from('bookings')
      .select('*, providers(name_ar), patients(full_name), users(whatsapp_id)')
      .eq('id', bookingId)
      .single();

    if (!booking) return;

    const provider = booking.providers as any;
    const patient = booking.patients as any;
    const familyUser = booking.users as any;

    if (!familyUser?.whatsapp_id) return;

    const scheduledAt = new Date(booking.scheduled_at);
    const message = `✅ تم تأكيد الحجز\n\nالخدمة: ${booking.service_type}\nالمزود: ${provider?.name_ar}\nالموعد: ${scheduledAt.toLocaleDateString('ar-SA')} — ${scheduledAt.toLocaleTimeString('ar-SA', { hour: '2-digit', minute: '2-digit' })}\n\nيمكن متابعة التفاصيل من التطبيق.`;

    await this.sendWhatsAppMessage(familyUser.whatsapp_id, message);
    await this.logNotification(booking.patient_id, booking.family_user_id, 'booking_confirmed', message);
  }

  private buildAnomalyMessage(
    patientName: string,
    readingType: string,
    value: string,
    recommendation: string,
  ): string {
    return `يمينك · متابعة ${patientName}\n\n🔴 قراءة تستدعي الانتباه\n\n${readingType}: ${value}\n\n${recommendation}`;
  }

  private async sendWhatsAppMessage(waId: string, message: string) {
    const phoneNumberId = this.config.getOrThrow('WHATSAPP_PHONE_NUMBER_ID');
    const token = this.config.getOrThrow('WHATSAPP_ACCESS_TOKEN');

    try {
      const response = await fetch(`${this.waApiUrl}/${phoneNumberId}/messages`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          messaging_product: 'whatsapp',
          to: waId,
          type: 'text',
          text: { body: message },
        }),
      });

      if (!response.ok) {
        const error = await response.text();
        this.logger.error(`WhatsApp send failed: ${error}`);
      }
    } catch (err) {
      this.logger.error(`WhatsApp error: ${err}`);
    }
  }

  private async logNotification(
    patientId: string,
    userId: string,
    type: string,
    content: string,
  ) {
    await this.supabase.db.from('notification_logs').insert({
      patient_id: patientId,
      user_id: userId,
      type,
      channel: 'whatsapp',
      content,
      delivered: true,
    });
  }

  private readingTypeAr(type: string): string {
    const map: Record<string, string> = {
      blood_sugar: 'السكر',
      blood_pressure: 'الضغط',
      weight: 'الوزن',
      temperature: 'الحرارة',
    };
    return map[type] ?? type;
  }
}
