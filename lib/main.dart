import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Matches <meta name="theme-color" content="#111827"> from index.html.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.backgroundFallback,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SmartQuizApp());
}

class SmartQuizApp extends StatelessWidget {
  const SmartQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn-It-All Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundFallback,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBtn,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: const Scaffold(
        backgroundColor: Colors.transparent,
        body: QuizApp(),
      ),
    );
  }
}
