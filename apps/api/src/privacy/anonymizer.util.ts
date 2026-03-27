/**
 * أداة إخفاء المعرفات الشخصية — Anonymizer Utility
 * تُزيل الاسم والهوية الوطنية ورقم الجوال قبل إرسال السياق لـ Claude
 */
import { createHmac } from 'node:crypto';

export interface PatientData {
  full_name?: string;
  national_id?: string;
  emergency_contact?: string;
  phone?: string;
  date_of_birth?: string;
  gender?: string;
  chronic_conditions?: string[];
  allergies?: string[];
  blood_type?: string;
  sugar_min?: number;
  sugar_max?: number;
  bp_systolic_max?: number;
  bp_diastolic_max?: number;
  bp_systolic_min?: number;
  [key: string]: unknown;
}

export interface AnonymizedPatient {
  alias: string;
  age_range: string;
  gender: string | null;
  chronic_conditions: string[];
  allergies: string[];
  blood_type: string | null;
  sugar_min: number;
  sugar_max: number;
  bp_systolic_max: number;
  bp_diastolic_max: number;
  bp_systolic_min: number;
}

/**
 * إخفاء هوية المريض — يُبقي فقط البيانات الطبية اللازمة
 */
export function anonymizePatient(patient: PatientData): AnonymizedPatient {
  return {
    alias: 'المريض',
    age_range: getAgeRange(patient.date_of_birth),
    gender: patient.gender ?? null,
    chronic_conditions: patient.chronic_conditions ?? [],
    allergies: patient.allergies ?? [],
    blood_type: patient.blood_type ?? null,
    sugar_min: patient.sugar_min ?? 80,
    sugar_max: patient.sugar_max ?? 140,
    bp_systolic_max: patient.bp_systolic_max ?? 140,
    bp_diastolic_max: patient.bp_diastolic_max ?? 90,
    bp_systolic_min: patient.bp_systolic_min ?? 90,
  };
}

/**
 * تحويل المعرفات الشخصية إلى معرفات عشوائية
 * يُستخدم عند الحاجة لربط بيانات بدون كشف الهوية
 */
export function pseudonymizeId(realId: string): string {
  const secret = process.env['ANONYMIZATION_SECRET'];
  if (!secret) {
    throw new Error('ANONYMIZATION_SECRET environment variable is required');
  }
  return createHmac('sha256', secret).update(realId).digest('hex').substring(0, 16);
}

/**
 * إزالة جميع الحقول التعريفية من كائن
 */
export function stripPii(obj: Record<string, unknown>): Record<string, unknown> {
  const piiFields = [
    'full_name', 'name', 'national_id', 'phone', 'emergency_contact',
    'whatsapp_id', 'email', 'address', 'photo_url',
  ];

  const cleaned = { ...obj };
  for (const field of piiFields) {
    delete cleaned[field];
  }
  return cleaned;
}

/**
 * إخفاء القراءات الصحية — إزالة patient_id واستبداله بمعرف عشوائي
 */
export function anonymizeReadings(
  readings: Array<Record<string, unknown>>,
): Array<Record<string, unknown>> {
  return readings.map((r) => {
    const { patient_id, ...rest } = r;
    return {
      ...rest,
      patient_ref: patient_id ? pseudonymizeId(String(patient_id)) : null,
    };
  });
}

// —— Internal Helpers ——

function getAgeRange(dob: string | null | undefined): string {
  if (!dob) return 'غير محدد';
  const age = new Date().getFullYear() - new Date(dob).getFullYear();

  if (age < 50) return '40-50';
  if (age < 60) return '50-60';
  if (age < 70) return '60-70';
  if (age < 80) return '70-80';
  if (age < 90) return '80-90';
  return '90+';
}
