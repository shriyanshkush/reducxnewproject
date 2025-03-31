// service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:untitled2/services/Alert_services.dart';
import 'package:untitled2/services/Navigation_services.dart';
import 'package:untitled2/services/auth_services.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Register NavigationService first as it's needed immediately
  getIt.registerSingleton<NavigationService>(NavigationService());

  // Then register other services
  getIt.registerSingleton<AuthServices>(AuthServices());
  getIt.registerSingleton<AlertServices>(AlertServices());

  // Initialize any async dependencies here if needed
}