import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:untitled2/services/Navigation_services.dart';
import 'package:untitled2/services/auth_services.dart';


class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AuthServices _authService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthServices>();
    _navigationService = _getIt.get<NavigationService>(); // Initialize before usage

    Timer(Duration(seconds: 3), () {
      _navigationService.pushReplacementnamed("/home");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png", height: 50),
            SizedBox(height: 20), // Add spacing
            Text(
              "On Demand Home Services",
              style: TextStyle(fontSize: 18, color: Colors.white), // Add color
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
