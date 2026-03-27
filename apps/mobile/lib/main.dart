import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'l10n/app_localizations.dart';
import 'app/router.dart';
import 'app/theme.dart';

// Core
import 'core/network/dio_client.dart';

// Features — Auth
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/request_otp_usecase.dart';
import 'features/auth/domain/usecases/verify_otp_usecase.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

// Features — Patient
import 'features/patient/data/datasources/patient_remote_datasource.dart';
import 'features/patient/data/repositories/patient_repository_impl.dart';
import 'features/patient/domain/usecases/get_patient_usecase.dart';
import 'features/patient/presentation/cubit/patient_cubit.dart';

// Features — Readings
import 'features/readings/data/datasources/readings_remote_datasource.dart';
import 'features/readings/data/repositories/readings_repository_impl.dart';
import 'features/readings/domain/usecases/get_readings_usecase.dart';
import 'features/readings/domain/usecases/record_reading_usecase.dart';
import 'features/readings/presentation/cubit/readings_cubit.dart';

// Features — Medical Profile
import 'features/medical_profile/data/datasources/medical_profile_remote_datasource.dart';
import 'features/medical_profile/data/repositories/medical_profile_repository_impl.dart';
import 'features/medical_profile/domain/usecases/get_medical_profile_usecase.dart';
import 'features/medical_profile/domain/usecases/save_medical_profile_usecase.dart';
import 'features/medical_profile/presentation/cubit/medical_profile_cubit.dart';

// Features — Reports
import 'features/reports/data/datasources/reports_remote_datasource.dart';
import 'features/reports/data/repositories/reports_repository_impl.dart';
import 'features/reports/presentation/cubit/reports_cubit.dart';

// Features — Services
import 'features/services/data/datasources/services_remote_datasource.dart';
import 'features/services/data/repositories/services_repository_impl.dart';
import 'features/services/presentation/cubit/services_cubit.dart';

// Features — Subscription
import 'features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'features/subscription/data/repositories/subscription_repository_impl.dart';
import 'features/subscription/presentation/cubit/subscription_cubit.dart';

// Features — Privacy
import 'features/privacy/data/datasources/consent_remote_datasource.dart';
import 'features/privacy/data/repositories/consent_repository_impl.dart';
import 'features/privacy/presentation/cubit/consent_cubit.dart';

// Features — Locale
import 'features/locale/presentation/cubit/locale_cubit.dart';
import 'features/locale/presentation/cubit/locale_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final view = PlatformDispatcher.instance.implicitView;
  final isTabletDevice = view != null &&
      view.physicalSize.shortestSide / view.devicePixelRatio >= 600;

  await SystemChrome.setPreferredOrientations(
    isTabletDevice
        ? [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]
        : [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
  );

  runApp(const YameenakApp());
}

class YameenakApp extends StatefulWidget {
  const YameenakApp({super.key});

  @override
  State<YameenakApp> createState() => _YameenakAppState();
}

class _YameenakAppState extends State<YameenakApp> {
  late final DioClient _dioClient;
  late final AuthCubit _authCubit;
  late final AppRouter _appRouter;

  // Datasource & repository singletons – created once in initState()
  late final PatientRepositoryImpl _patientRepo;
  late final ReadingsRepositoryImpl _readingsRepo;
  late final MedicalProfileRepositoryImpl _profileRepo;
  late final SaveMedicalProfileUseCase _saveProfileUseCase;
  late final ReportsRepositoryImpl _reportsRepo;
  late final ServicesRepositoryImpl _servicesRepo;
  late final SubscriptionRepositoryImpl _subscriptionRepo;
  late final ConsentRepositoryImpl _consentRepo;

  @override
  void initState() {
    super.initState();
    _dioClient = DioClient();

    // Create AuthCubit early so the router redirect can read auth state.
    final authDataSource = AuthRemoteDataSourceImpl(_dioClient);
    final authRepo = AuthRepositoryImpl(authDataSource);
    _authCubit = AuthCubit(
      requestOtp: RequestOtpUseCase(authRepo),
      verifyOtp: VerifyOtpUseCase(authRepo),
      register: RegisterUseCase(authRepo),
    );

    _appRouter = AppRouter(authCubit: _authCubit);
    _dioClient.onSessionExpired = () => _appRouter.router.go('/welcome');

    // Patient
    final patientDataSource = PatientRemoteDataSourceImpl(_dioClient);
    _patientRepo = PatientRepositoryImpl(patientDataSource);

    // Readings
    final readingsDataSource = ReadingsRemoteDataSourceImpl(_dioClient);
    _readingsRepo = ReadingsRepositoryImpl(readingsDataSource);

    // Medical Profile
    final profileDataSource = MedicalProfileDataSourceImpl(_dioClient);
    _profileRepo = MedicalProfileRepositoryImpl(profileDataSource);
    _saveProfileUseCase = SaveMedicalProfileUseCase(_profileRepo);

    // Reports
    final reportsDataSource = ReportsRemoteDataSourceImpl(_dioClient);
    _reportsRepo = ReportsRepositoryImpl(reportsDataSource);

    // Services
    final servicesDataSource = ServicesRemoteDataSourceImpl(_dioClient);
    _servicesRepo = ServicesRepositoryImpl(servicesDataSource);

    // Subscription
    final subscriptionDataSource =
        SubscriptionRemoteDataSourceImpl(_dioClient);
    _subscriptionRepo = SubscriptionRepositoryImpl(subscriptionDataSource);

    // Consent / Privacy
    final consentDataSource = ConsentRemoteDataSourceImpl(_dioClient);
    _consentRepo = ConsentRepositoryImpl(consentDataSource);
  }

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LocaleCubit(),
        ),
        BlocProvider.value(value: _authCubit),
        BlocProvider(
          create: (_) => PatientCubit(
            getPatient: GetPatientUseCase(_patientRepo),
          ),
        ),
        BlocProvider(
          create: (_) => ReadingsCubit(
            getReadings: GetReadingsUseCase(_readingsRepo),
            recordReading: RecordReadingUseCase(_readingsRepo),
          ),
        ),
        BlocProvider(
          create: (_) => MedicalProfileCubit(
            getProfile: GetMedicalProfileUseCase(_profileRepo),
            saveProfile: _saveProfileUseCase,
          ),
        ),

        BlocProvider(
          create: (_) =>
              ReportsCubit(repository: _reportsRepo),
        ),
        BlocProvider(
          create: (_) =>
              ServicesCubit(repository: _servicesRepo)..loadServices(),
        ),
        BlocProvider(
          create: (_) =>
              SubscriptionCubit(repository: _subscriptionRepo),
        ),
        BlocProvider(
          create: (_) =>
              ConsentCubit(repository: _consentRepo),
        ),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return MaterialApp.router(
            title: 'يمينك',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(),
            routerConfig: _appRouter.router,
            locale: localeState.locale,
            supportedLocales: S.supportedLocales,
            localizationsDelegates: S.localizationsDelegates,
          );
        },
      ),
    );
  }
}

/// Extension for convenient access to localized strings.
extension LocalizedBuildContext on BuildContext {
  S get l10n => S.of(this);
}
