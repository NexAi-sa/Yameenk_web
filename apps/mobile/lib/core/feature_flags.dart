/// Compile-time feature gates.
///
/// Flip a flag to `true` once the corresponding backend endpoint is live.
/// Using `static const` ensures dead-code elimination by the Dart compiler
/// when a flag is `false`.
abstract final class FeatureFlags {
  /// Show the "Recent Activities" section on the family dashboard.
  ///
  /// Set to `true` once the activities API endpoint is deployed.
  /// See: https://github.com/NexAi-sa/Yameenk_web/issues/7
  static const bool showRecentActivities = false;

  /// Show the notifications bell icon in the AppBar.
  ///
  /// Set to `true` once the notifications feature is implemented.
  /// See: https://github.com/NexAi-sa/Yameenk_web/issues/15
  static const bool kNotificationsEnabled = false;
}
