// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';
import 'theme.dart' as theme;
import '../providers/app_state_provider.dart';
import '../core/services/storage_service.dart';

class InvestmentApp extends ConsumerWidget {
  const InvestmentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    final themeMode = ref.watch(appThemeProvider.notifier).getThemeMode();

    // Use the locale provider directly
    final locale = ref.watch(appLocaleProvider.notifier).getLocale();

    return MaterialApp.router(
      title: 'Investment App',
      // Access static fields correctly
      theme: theme.AppTheme.lightTheme,
      darkTheme: theme.AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('es', 'ES'), // Spanish
        Locale('fr', 'FR'), // French
        Locale('ar', 'SA'), // Arabic
        Locale('bn', 'BD'), // Bengali
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
