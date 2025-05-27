// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'router.dart';
import 'theme.dart' as theme;
import '../providers/app_state_provider.dart';

class InvestmentApp extends ConsumerWidget {
  const InvestmentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(appThemeProvider.notifier).getThemeMode();

    return MaterialApp.router(
      title: 'Investment App',
      theme: theme.AppTheme.lightTheme,
      darkTheme: theme.AppTheme.darkTheme,
      themeMode: themeMode,

      // Use easy_localization
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
