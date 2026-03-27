import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { PatientsModule } from './patients/patients.module';
import { HealthReadingsModule } from './health-readings/health-readings.module';
import { AiChatModule } from './ai-chat/ai-chat.module';
import { NotificationsModule } from './notifications/notifications.module';
import { MarketplaceModule } from './marketplace/marketplace.module';
import { BookingsModule } from './bookings/bookings.module';
import { ReportsModule } from './reports/reports.module';
import { SupabaseModule } from './supabase/supabase.module';
import { PrivacyModule } from './privacy/privacy.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    SupabaseModule,
    PrivacyModule,
    AuthModule,
    PatientsModule,
    HealthReadingsModule,
    AiChatModule,
    NotificationsModule,
    MarketplaceModule,
    BookingsModule,
    ReportsModule,
  ],
})
export class AppModule {}
