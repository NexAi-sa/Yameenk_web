/// Result of password‐policy validation.
enum PasswordValidationResult {
  /// Password meets all requirements.
  valid,

  /// Fewer than 8 characters.
  tooShort,

  /// Missing at least one uppercase letter (A‑Z).
  needsUppercase,

  /// Missing at least one digit (0‑9).
  needsDigit,
}

/// Validates [password] against the Yameenak password policy.
///
/// Rules (checked in order):
/// 1. Minimum 8 characters.
/// 2. At least one uppercase letter.
/// 3. At least one digit.
PasswordValidationResult validatePassword(String password) {
  if (password.length < 8) return PasswordValidationResult.tooShort;
  if (!password.contains(RegExp(r'[A-Z]'))) {
    return PasswordValidationResult.needsUppercase;
  }
  if (!password.contains(RegExp(r'[0-9]'))) {
    return PasswordValidationResult.needsDigit;
  }
  return PasswordValidationResult.valid;
}
