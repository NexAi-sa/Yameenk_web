import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';
import helmet from 'helmet';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Security headers: HSTS, CSP, X-Frame-Options, etc.
  app.use(helmet());

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
    }),
  );

  app.enableCors({
    origin: process.env.ALLOWED_ORIGINS?.split(',') ?? ['http://localhost:3000'],
  });

  app.setGlobalPrefix('api/v1');

  await app.listen(process.env.PORT ?? 3001);
  console.log(`يمينك API running on: ${await app.getUrl()}`);
}
bootstrap();
