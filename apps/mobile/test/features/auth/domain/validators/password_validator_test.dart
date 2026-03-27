import 'package:flutter_test/flutter_test.dart';
import 'package:yameenak_mobile/features/auth/domain/validators/password_validator.dart';

void main() {
  group('validatePassword', () {
    test('empty string → tooShort', () {
      expect(validatePassword(''), PasswordValidationResult.tooShort);
    });

    test('7 chars → tooShort', () {
      expect(validatePassword('Abcdef1'), PasswordValidationResult.tooShort);
    });

    test('8 chars, no uppercase → needsUppercase', () {
      expect(
        validatePassword('abcdefg1'),
        PasswordValidationResult.needsUppercase,
      );
    });

    test('8 chars, no digit → needsDigit', () {
      expect(
        validatePassword('Abcdefgh'),
        PasswordValidationResult.needsDigit,
      );
    });

    test('valid password (exactly 8 chars) → valid', () {
      expect(validatePassword('Abcdef1x'), PasswordValidationResult.valid);
    });

    test('valid long password → valid', () {
      expect(
        validatePassword('MyStr0ngP@ssword!'),
        PasswordValidationResult.valid,
      );
    });

    test('all digits, no uppercase → needsUppercase', () {
      expect(
        validatePassword('12345678'),
        PasswordValidationResult.needsUppercase,
      );
    });

    test('all uppercase, no digit → needsDigit', () {
      expect(
        validatePassword('ABCDEFGH'),
        PasswordValidationResult.needsDigit,
      );
    });
  });
}
