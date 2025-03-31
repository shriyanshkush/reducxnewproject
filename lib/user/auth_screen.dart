import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/user/register_screen.dart';
import 'package:untitled2/user/registration_page.dart';

import '../services/auth_services.dart';
import 'login_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthServices _authServices = AuthServices();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,

          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            tabs: [
              Tab(text: "Create Account"),
              Tab(text: "Login"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            RegistrationPage(authServices: _authServices),
            LoginScreen(authServices: _authServices),
          ],
        ),
      ),
    );
  }
}