import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/mode_selection_screen.dart';
import 'services/language_service.dart';

void main() {
  Get.put(LanguageService());
  runApp(const RakshaApp());
}

class RakshaApp extends StatelessWidget {
  const RakshaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Raksha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
        ),
      ),
      home: const ModeSelectionScreen(),
    );
  }
}
