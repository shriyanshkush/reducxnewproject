import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_services.dart';
import '../widgets/Text_form_feild.dart';

class CompanyLogin extends StatelessWidget {
  final AuthServices authServices;

  CompanyLogin({required this.authServices});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            _buildLabel("Email Address"),
            RoundedTextFormField(
              textEditingController: emailController,
              hintText: "Enter your email",
            ),
            SizedBox(height: 20),
            _buildLabel("Password"),
            RoundedTextFormField(
              textEditingController: passwordController,
              hintText: "Enter your password",
              obscureText: true,
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () async {
                  await authServices.logIn(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                },
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 30,),
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Column(
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           ElevatedButton.icon(
            //             onPressed: () {
            //               // Implement Google login
            //             },
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: Colors.white,
            //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //               elevation: 1,
            //             ),
            //             icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
            //             label: Text("Login with Google", style: TextStyle(color: Colors.black)),
            //           ),
            //           SizedBox(width: 10),
            //           ElevatedButton.icon(
            //             onPressed: () {
            //               // Implement Apple login
            //             },
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: Colors.white,
            //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //               elevation: 1,
            //             ),
            //             icon: FaIcon(FontAwesomeIcons.apple, color: Colors.black),
            //             label: Text("Login with Apple", style: TextStyle(color: Colors.black)),
            //           ),
            //         ],
            //       ),
            //       SizedBox(height: 20),
            //     ],
            //   ),
            // ),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Handle user login
                },
                child: Text(
                  "Login as user",
                  style: TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }


}
