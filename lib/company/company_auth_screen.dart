import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/company/company_registration.dart';
import 'package:untitled2/user/register_screen.dart';
import 'package:untitled2/user/registration_page.dart';

import '../services/auth_services.dart';
import '../user/login_screen.dart';
import 'company_login.dart';

class CompanyAuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<CompanyAuthScreen> {
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
            CompanyRegistration(authServices: _authServices),
            CompanyLogin(authServices: _authServices),
          ],
        ),
      ),
    );
  }
}