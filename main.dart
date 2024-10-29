import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/finance_provider.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const FinanceTrackerApp());
}

class FinanceTrackerApp extends StatelessWidget {
  const FinanceTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FinanceProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFD6CADD), // Light Lavender
            primary: const Color(0xFFB39DDB),  // Lavender Primary
            secondary: const Color(0xFF9575CD), // Bold Lavender Secondary
            background: const Color(0xFFF3E5F5), // Light Background
            surface: const Color(0xFFF3E5F5),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 18, color: Colors.black87),
            headlineSmall: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6A1B9A), // Bold Lavender
            ),
          ),
          cardColor: Colors.white,
          scaffoldBackgroundColor: const Color(0xFFF3E5F5), // Lavender Background
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9575CD), // Button Color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF6A1B9A), // Bold Header
            foregroundColor: Colors.white,
            elevation: 2,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
