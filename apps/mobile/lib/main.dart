import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // السماح بالأفقي على التابلت وإبقاء العمودي على الجوال
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

  runApp(
    const ProviderScope(
      child: YameenakApp(),
    ),
  );
}

class YameenakApp extends ConsumerWidget {
  const YameenakApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'يمينك',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: router,
      locale: locale,
      supportedLocales: S.supportedLocales,
      localizationsDelegates: S.localizationsDelegates,
    );
  }
}

/// Extension for convenient access to localized strings.
extension LocalizedBuildContext on BuildContext {
  S get l10n => S.of(this);
}
