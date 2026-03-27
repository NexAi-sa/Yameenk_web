/**
 * وحدة الخصوصية — Privacy Module
 * تجمع خدمات الموافقة والتدقيق وإخفاء الهوية
 */
import { Module, Global } from '@nestjs/common';
import { PrivacyController } from './privacy.controller';
import { ConsentService } from './consent.service';
import { AuditService } from './audit.service';
import { SupabaseModule } from '../supabase/supabase.module';

@Global()
@Module({
  imports: [SupabaseModule],
  controllers: [PrivacyController],
  providers: [ConsentService, AuditService],
  exports: [ConsentService, AuditService],
})
export class PrivacyModule {}
