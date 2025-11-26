import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/app_language.dart';
import 'src/features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  ThemeData _buildLightTheme() {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blue,
      brightness: Brightness.light,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        titleLarge: TextStyle(
          fontSize: 24.sp,             // dùng ScreenUtil
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blue,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        titleLarge: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLang = ref.watch(appLanguageProvider);
    final strings = AppStrings(appLang);

    return ScreenUtilInit(
      designSize: const Size(390, 844), // kích thước Figma iPhone 13
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MaterialApp(
          title: strings.appTitle,
          debugShowCheckedModeBanner: false,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: ThemeMode.system,
          home: const LoginPage(),
        );
      },
    );
  }
}
