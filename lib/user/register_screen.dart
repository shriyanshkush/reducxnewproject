import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../widgets/Text_form_feild.dart';

class RegisterScreen extends StatelessWidget {
  final AuthServices authServices;

  RegisterScreen({required this.authServices});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
            children: [
            SizedBox(height: 20),
        RoundedTextFormField(
          textEditingController: usernameController,
          hintText: "Full Name",
        ),
        SizedBox(height: 20),
        RoundedTextFormField(
          textEditingController: emailController,
          hintText: "Email Address",

        ),
        SizedBox(height: 20),
        RoundedTextFormField(
          textEditingController: mobileNumberController,
          hintText: "Phone Number",
        ),
        SizedBox(height: 20),
        RoundedTextFormField(
          textEditingController: passwordController,
          hintText: "Password",
          obscureText: true,
        ),
        SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            onPressed: () async {
              await authServices.signUp(
                email: emailController.text,
                password: passwordController.text,
                username: usernameController.text,
                mobileNumber: mobileNumberController.text,
              );
            },
            child: Text(
              "Register",
              style: TextStyle(fontSize: 18),
            ),
          )]
      ),
      ),
    );
  }
}