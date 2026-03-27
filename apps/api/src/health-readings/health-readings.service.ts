import { Injectable } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';
import { NotificationsService } from '../notifications/notifications.service';
import { CreateReadingDto } from './dto/create-reading.dto';

interface AnomalyResult {
  isAnomaly: boolean;
  recommendation?: string;
}

@Injectable()
export class HealthReadingsService {
  constructor(
    private supabase: SupabaseService,
    private notifications: NotificationsService,
  ) {}

  async createReading(dto: CreateReadingDto, patientId: string) {
    // 1. Save reading
    const { data: reading, error } = await this.supabase.db
      .from('health_readings')
      .insert({
        patient_id: patientId,
        type: dto.type,
        value_1: dto.value1,
        value_2: dto.value2,
        unit: dto.unit,
        context: dto.context,
        notes: dto.notes,
      })
      .select()
      .single();

    if (error) throw error;

    // 2. Check for anomaly (non-blocking)
    this.checkAnomaly(reading, patientId).catch(console.error);

    return reading;
  }

  async getReadings(patientId: string, days = 7) {
    const since = new Date();
    since.setDate(since.getDate() - days);

    const { data, error } = await this.supabase.db
      .from('health_readings')
      .select('*')
      .eq('patient_id', patientId)
      .gte('recorded_at', since.toISOString())
      .order('recorded_at', { ascending: true });

    if (error) throw error;
    return data;
  }

  async getTrends(patientId: string, type: string, days = 7) {
    const readings = await this.getReadings(patientId, days);
    const filtered = readings.filter((r) => r.type === type);

    if (filtered.length === 0) return null;

    const values = filtered.map((r) => r.value_1);
    return {
      readings: filtered,
      avg: values.reduce((a, b) => a + b, 0) / values.length,
      min: Math.min(...values),
      max: Math.max(...values),
      total: filtered.length,
    };
  }

  private async checkAnomaly(reading: any, patientId: string) {
    // Fetch patient limits — including AI-calibrated personal critical thresholds
    const { data: patient } = await this.supabase.db
      .from('patients')
      .select(
        'sugar_min, sugar_max, bp_systolic_max, bp_diastolic_max, bp_systolic_min, ' +
        'sugar_critical_high, sugar_critical_low, bp_critical_systolic, bp_critical_diastolic, ' +
        'full_name',
      )
      .eq('id', patientId)
      .single();

    if (!patient) return;

    const result = this.detectAnomaly(reading, patient);
    if (!result.isAnomaly) return;

    // Update reading as anomaly
    await this.supabase.db
      .from('health_readings')
      .update({ is_anomaly: true })
      .eq('id', reading.id);

    // Send WhatsApp alert to family
    await this.notifications.sendAnomalyAlert({
      patientId,
      patientName: patient.full_name,
      readingType: reading.type,
      value: reading.value_1,
      value2: reading.value_2,
      unit: reading.unit,
      recommendation: result.recommendation!,
    });
  }

  private detectAnomaly(reading: any, patient: any): AnomalyResult {
    if (reading.type === 'blood_sugar') {
      const isHigh = reading.value_1 > (patient.sugar_max ?? 140);
      const isLow = reading.value_1 < (patient.sugar_min ?? 80);

      // الحد الحرج الشخصي — يحدده الذكاء الاصطناعي في calibrate-thresholds
      // القيم الافتراضية تُستخدم فقط إذا لم يكن الملف الطبي معايَراً بعد
      const criticalHigh = patient.sugar_critical_high ?? 300;
      const criticalLow = patient.sugar_critical_low ?? 60;

      if (isHigh) {
        return {
          isAnomaly: true,
          recommendation:
            reading.value_1 >= criticalHigh
              ? 'قراءة خطيرة جداً — تواصل مع الطبيب فوراً أو اتصل بالإسعاف'
              : 'تابع مع المريض. إذا استمرت القراءة المرتفعة راجع الطبيب.',
        };
      }
      if (isLow) {
        return {
          isAnomaly: true,
          recommendation:
            reading.value_1 <= criticalLow
              ? 'سكر منخفض خطير — تناول سكر فوراً واتصل بالطوارئ'
              : 'سكر منخفض — تناول شيئاً حلواً فوراً (عصير/تمر). إذا لم يتحسن اتصل بالطوارئ.',
        };
      }
    }

    if (reading.type === 'blood_pressure') {
      const systolicHigh = reading.value_1 > (patient.bp_systolic_max ?? 140);
      const diastolicHigh = reading.value_2 && reading.value_2 > (patient.bp_diastolic_max ?? 90);

      // الحد الحرج الشخصي للضغط — يحدده الذكاء الاصطناعي
      const criticalSystolic = patient.bp_critical_systolic ?? 180;
      const criticalDiastolic = patient.bp_critical_diastolic ?? 120;

      if (systolicHigh || diastolicHigh) {
        const isCritical =
          reading.value_1 >= criticalSystolic ||
          (reading.value_2 && reading.value_2 >= criticalDiastolic);

        return {
          isAnomaly: true,
          recommendation: isCritical
            ? 'ضغط خطير جداً — اتصل بالطوارئ فوراً'
            : 'ضغط مرتفع — تأكد من أخذ الدواء. إذا استمر راجع الطبيب.',
        };
      }
    }

    return { isAnomaly: false };
  }
}
