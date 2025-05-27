// lib/app/app.dart (Updated)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';
import 'theme.dart';
import '../providers/app_state_provider.dart';
import '../core/services/storage_service.dart';

class InvestmentApp extends ConsumerWidget {
  const InvestmentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appStateAsync = ref.watch(appStateProvider);

    return appStateAsync.when(
      data: (appState) {
        final themeMode = ref.read(appStateProvider.notifier).getThemeMode();
        final locale = ref.read(appStateProvider.notifier).getLocale();

        return MaterialApp.router(
          title: 'Investment App',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
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
      },
      loading: () => MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (error, stackTrace) => MaterialApp(
        home: Scaffold(body: Center(child: Text('Error loading app: $error'))),
      ),
    );
  }
}
