/**
 * خدمة سجل التدقيق — Audit Log Service
 * تسجيل جميع عمليات الوصول للبيانات لضمان الشفافية
 */
import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { SupabaseService } from '../supabase/supabase.service';

export type AuditAction =
  | 'login'
  | 'view_patient'
  | 'create_patient'
  | 'update_patient'
  | 'record_reading'
  | 'view_readings'
  | 'ai_chat_message'
  | 'view_chat_history'
  | 'create_booking'
  | 'grant_consent'
  | 'revoke_consent'
  | 'export_data'
  | 'delete_account'
  | 'view_audit_log';

export type ResourceType =
  | 'patient'
  | 'health_reading'
  | 'chat_message'
  | 'booking'
  | 'consent'
  | 'user';

export interface AuditEntry {
  userId: string;
  action: AuditAction;
  resourceType?: ResourceType;
  resourceId?: string;
  metadata?: Record<string, unknown>;
  ipAddress?: string;
  userAgent?: string;
}

@Injectable()
export class AuditService {
  private readonly logger = new Logger(AuditService.name);

  constructor(private supabase: SupabaseService) {}

  /**
   * تسجيل نشاط في سجل التدقيق
   * يعمل بشكل غير متزامن — لا يُعيق العملية الأساسية
   */
  async log(entry: AuditEntry): Promise<void> {
    try {
      await this.supabase.db.from('audit_logs').insert({
        user_id: entry.userId,
        action: entry.action,
        resource_type: entry.resourceType ?? null,
        resource_id: entry.resourceId ?? null,
        metadata: entry.metadata ?? {},
        ip_address: entry.ipAddress ?? null,
        user_agent: entry.userAgent ?? null,
      });
    } catch (error) {
      // لا نريد أن يفشل الطلب الأصلي بسبب فشل التدقيق
      console.error('[AuditService] Failed to log audit entry:', error);
    }
  }

  /**
   * تنظيف تلقائي لسجلات التدقيق الأقدم من 5 سنوات (PDPL: الاحتفاظ 5 سنوات فقط)
   * يعمل كل يوم أحد الساعة 3 صباحاً
   */
  @Cron(CronExpression.EVERY_WEEK)
  async cleanupOldAuditLogs(): Promise<void> {
    const fiveYearsAgo = new Date();
    fiveYearsAgo.setFullYear(fiveYearsAgo.getFullYear() - 5);

    try {
      const { count, error } = await this.supabase.db
        .from('audit_logs')
        .delete({ count: 'exact' })
        .lt('created_at', fiveYearsAgo.toISOString());

      if (error) throw error;
      this.logger.log(`[PDPL Cleanup] حُذف ${count ?? 0} سجل تدقيق أقدم من 5 سنوات`);
    } catch (error) {
      this.logger.error('[PDPL Cleanup] فشل تنظيف سجلات التدقيق:', error);
    }
  }

  /**
   * استعراض سجل التدقيق للمستخدم
   */
  async getUserAuditLog(
    userId: string,
    options: { limit?: number; offset?: number } = {},
  ) {
    const { limit = 50, offset = 0 } = options;

    const { data, error, count } = await this.supabase.db
      .from('audit_logs')
      .select('*', { count: 'exact' })
      .eq('user_id', userId)
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (error) throw error;

    return { logs: data ?? [], total: count ?? 0 };
  }
}
