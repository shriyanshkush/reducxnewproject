// Navigation_services.dart
import 'package:flutter/material.dart';

import '../Splash_screen.dart';
import '../company/company_auth_screen.dart';
import '../user/HomePage.dart';
import '../user/LoginPage.dart';
import '../user/auth_screen.dart';
import '../user/edit_profile.dart';
import '../user/forgot_password.dart';
import '../user/registration_page.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

  final Map<String, Widget Function(BuildContext)> routes = {
    "/splash": (context) => SplashScreen(),
    "/login": (context) => LoginPage(),
    "/forgotPassword": (context) => ForgotPasswordPage(),
    "/home": (context) => HomePage(),
    "/registration": (context) => AuthScreen(),
    "/companyregistration":(context)=>CompanyAuthScreen(),
  };

  void push(MaterialPageRoute route) {
    navigatorkey.currentState?.push(route);
  }

  void pushnamed(String routeName, {Object? arguments}) {
    navigatorkey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  void pushReplacementnamed(String routname) {
    navigatorkey.currentState?.pushReplacementNamed(routname);
  }

  void goback() {
    navigatorkey.currentState?.pop();
  }

  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/editprofile':
        final uid = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => EditProfile(uid: uid),
        );
      default:
        return null;
    }
  }
}