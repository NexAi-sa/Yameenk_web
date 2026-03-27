/// Centralized Supabase configuration.
///
/// The anon key is a **public** key intended for client-side use.
/// Security is enforced via Row Level Security (RLS) on the database,
/// NOT by hiding this key.
library;

const supabaseUrl = 'https://bnmvuaqxcmdycpyojfbg.supabase.co';

/// Prefer the build-time value if provided; otherwise fall back to the
/// embedded default so that the app works from Xcode / direct `flutter run`.
const supabaseAnonKey = String.fromEnvironment(
  'SUPABASE_ANON_KEY',
  defaultValue:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJubXZ1YXF4Y21keWNweW9qZmJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ1MjkzMDQsImV4cCI6MjA5MDEwNTMwNH0.tTsIV5xbpUMetKp-1xoGlt5vQsY3QMuEFH188GZ4-AM',
);
