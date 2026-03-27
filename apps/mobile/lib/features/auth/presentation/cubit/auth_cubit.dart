library;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/request_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final RequestOtpUseCase _requestOtp;
  final VerifyOtpUseCase _verifyOtp;
  final RegisterUseCase _register;

  AuthCubit({
    required RequestOtpUseCase requestOtp,
    required VerifyOtpUseCase verifyOtp,
    required RegisterUseCase register,
  })  : _requestOtp = requestOtp,
        _verifyOtp = verifyOtp,
        _register = register,
        super(const AuthInitial());

  Future<void> login(String phone, {String code = '123456'}) async {
    emit(const AuthLoading());

    final result = await _verifyOtp(
      VerifyOtpParams(phone: '+966$phone', code: code),
    );

    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
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

    final result = await _register(
      RegisterParams(name: name, email: email, password: password),
    );

    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
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

  Future<void> requestOtp(String phone) async {
    emit(const AuthLoading());

    final result = await _requestOtp(RequestOtpParams(phone: '+966$phone'));

    result.fold(
      (failure) => emit(AuthFailureState(failure.message)),
      (_) => emit(const AuthInitial()),
    );
  }

  void logout() => emit(const AuthLoggedOut());
}

