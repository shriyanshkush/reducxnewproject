// main.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled2/services/Navigation_services.dart';
import 'package:untitled2/services/register_services.dart';
import 'package:untitled2/services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services FIRST
  //await setupLocator();
  await registerServices();

  runApp(Profixer());
}

class Profixer extends StatefulWidget {

  Profixer({super.key});

  @override
  State<Profixer> createState() => _ProfixerState();
}

class _ProfixerState extends State<Profixer> {
  final GetIt getIt=GetIt.instance;

  late NavigationService _navigationService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigationService=getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigationService.navigatorkey,
      title: "KidZian",
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryColor: Colors.grey[700],
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: Color(0xFF424242),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: "/splash",
      routes: _navigationService.routes,
      onGenerateRoute: _navigationService.generateRoute,
    );
  }
}