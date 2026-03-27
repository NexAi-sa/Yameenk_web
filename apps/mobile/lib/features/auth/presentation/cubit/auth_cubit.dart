library;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/login_with_email_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/request_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RequestOtpUseCase _requestOtp;
  final VerifyOtpUseCase _verifyOtp;
  final RegisterUseCase _register;
  final LoginWithEmailUseCase _loginWithEmail;

  AuthCubit({
    required RequestOtpUseCase requestOtp,
    required VerifyOtpUseCase verifyOtp,
    required RegisterUseCase register,
    required LoginWithEmailUseCase loginWithEmail,
  })  : _requestOtp = requestOtp,
        _verifyOtp = verifyOtp,
        _register = register,
        _loginWithEmail = loginWithEmail,
        super(const AuthInitial());

  Future<void> login(String phone, {String code = '123456'}) async {
    emit(const AuthLoading());

    final result = await _verifyOtp(
      VerifyOtpParams(phone: '+966$phone', code: code),
    );

    result.fold(
      (failure) {
        debugPrint('🔴 Login failure: ${failure.message}');
        emit(AuthFailureState(failure.message));
      },
      (auth) async {
        final prefs = await SharedPreferences.getInstance();
        final consentDone =
            prefs.getBool('pdpl_consent_completed_sp') ?? false;
        emit(AuthAuthenticated(
          patientId: auth.patientId,
          consentCompleted: consentDone,
        ));
      },
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    debugPrint('🟡 Registering: name=$name, email=$email');

    final result = await _register(
      RegisterParams(name: name, email: email, password: password),
    );

    result.fold(
      (failure) {
        debugPrint('🔴 Registration failure: ${failure.message}');
        emit(AuthFailureState(failure.message));
      },
      (auth) async {
        debugPrint('🟢 Registration success: patientId=${auth.patientId}');
        final prefs = await SharedPreferences.getInstance();
        final consentDone =
            prefs.getBool('pdpl_consent_completed_sp') ?? false;
        emit(AuthAuthenticated(
          patientId: auth.patientId,
          consentCompleted: consentDone,
        ));
      },
    );
  }

  Future<void> requestOtp(String phone) async {
    emit(const AuthLoading());

    final result = await _requestOtp(RequestOtpParams(phone: '+966$phone'));

    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (_) => emit(const AuthInitial()),
    );
  }

  void logout() => emit(const AuthLoggedOut());

  /// Restore session from persisted tokens (auto-login on app restart).
  Future<void> checkAuthStatus() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'access_token');
    final patientId = await storage.read(key: 'patient_id');
    if (token != null && token.isNotEmpty && patientId != null && patientId.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final consentDone = prefs.getBool('pdpl_consent_completed_sp') ?? false;
      emit(AuthAuthenticated(
        patientId: patientId,
        consentCompleted: consentDone,
      ));
    }
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    debugPrint('🟡 Login with email: $email');

    final result = await _loginWithEmail(
      LoginWithEmailParams(email: email, password: password),
    );

    result.fold(
      (failure) {
        debugPrint('🔴 Email login failure: ${failure.message}');
        emit(AuthFailureState(failure.message));
      },
      (auth) async {
        debugPrint('🟢 Email login success: patientId=${auth.patientId}');
        final prefs = await SharedPreferences.getInstance();
        final consentDone =
            prefs.getBool('pdpl_consent_completed_sp') ?? false;
        emit(AuthAuthenticated(
          patientId: auth.patientId,
          consentCompleted: consentDone,
        ));
      },
    );
  }
}

