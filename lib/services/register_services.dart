import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'Alert_services.dart';
import 'Navigation_services.dart';
import 'auth_services.dart';

Future<void> registerServices() async{
  final GetIt getIt=GetIt.instance;
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<AuthServices>(AuthServices());
  getIt.registerSingleton<AlertServices>(AlertServices());
}

