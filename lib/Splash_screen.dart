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
  final GetIt _getIt=GetIt.instance;
  late NavigationService _navigationService;
  late AuthServices _authservice;
  //late DatabaseServices _databaseServices;
  @override
  void initState() {
    super.initState();
    _authservice = _getIt.get<AuthServices>();
    //_databaseServices = _getIt.get<DatabaseServices>();

    Timer(Duration(seconds: 3), () async {
      _navigationService = _getIt.get<NavigationService>();

      _navigationService.pushReplacementnamed("/home");

    });
  }

  // Future<String> DecideUserRole(String userId) async {
  //   String isUser = await _databaseServices.decideUser(userId);
  //   print("printing user:${isUser}");
  //   return isUser=='user' ? "/userhome" : "/admindash";
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "ProFixer",
      debugShowCheckedModeBanner: false,
      home: Scaffold(backgroundColor:Colors.black,
        body: Center(
          child: Image.asset("assets/logo.png", height: 24),
        )),
    );
  }

}