// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled2/services/Navigation_services.dart';
import 'package:untitled2/services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services FIRST
  await setupLocator();

  runApp(Profixer());
}

class Profixer extends StatelessWidget {
  Profixer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: getIt<NavigationService>().navigatorkey,
      title: "KidZian",
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: "/splash",
      routes: getIt<NavigationService>().routes,
      onGenerateRoute: getIt<NavigationService>().generateRoute,
    );
  }
}