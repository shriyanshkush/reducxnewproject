import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import '../services/Navigation_services.dart';
import '../services/auth_services.dart';
import '../widgets/Text_form_feild.dart';

class LoginScreen extends StatefulWidget {
  final AuthServices authServices;


  LoginScreen({required this.authServices});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GetIt _getIt=GetIt.instance;
  late NavigationService _navigationService;
  late AuthServices _authServices;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigationService=_getIt.get<NavigationService>();
    _authServices=_getIt.get<AuthServices>();
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              _buildLabel("Email Address"),
              RoundedTextFormField(
                textEditingController: emailController,
                hintText: "Enter your email",
                validator: (value) => value!.isEmpty ? 'Required field' : null,
              ),
              SizedBox(height: 20),
              _buildLabel("Password"),
              RoundedTextFormField(
                textEditingController: passwordController,
                hintText: "Enter your password",
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Required field' : null,
              ),
              SizedBox(height: 30),
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => showForgotPasswordDialog(context),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  onPressed: _login,
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
              //       GestureDetector(
              //         onTap: () {
              //
              //         },
              //         child: Text(
              //           "Login as Partner",
              //           style: TextStyle(
              //             color: Colors.brown,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _navigationService.pushReplacementnamed("/companyregistration");
                  },
                  child: Text(
                    "Login as Partner",
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

  void showForgotPasswordDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    bool isPartner = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Forgot password?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter your email address", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),

                  /// 📧 Email TextField
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email Address",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 10),

                  /// ✅ Partner Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: isPartner,
                        onChanged: (bool? value) {
                          setState(() {
                            isPartner = value!;
                          });
                        },
                      ),
                      Text("Partner"),
                    ],
                  ),
                  SizedBox(height: 10),

                  /// ℹ️ Info Text
                  Text(
                    "Password reset link will be sent to your above email address",
                    style: TextStyle(color: Colors.orange, fontSize: 13),
                  ),
                ],
              ),
              actions: [
                /// 🔘 OK Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      String email = emailController.text.trim();

                      if (email.isNotEmpty) {
                        bool success = await _authServices.forgotPassword(email);
                        if (success) {
                          Navigator.pop(context); // Close current dialog
                          showResetPasswordDialog(context, email);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Failed to send reset link")),
                          );
                        }
                      }
                    },
                    child: Text("Ok", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Show Reset Password Dialog
  void showResetPasswordDialog(BuildContext context, String email) {
    TextEditingController otpController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text("Reset Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Enter OTP sent to $email", style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),

              /// 🔢 OTP Field
              TextField(
                controller: otpController,
                decoration: InputDecoration(
                  hintText: "Enter OTP",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                ),
              ),
              SizedBox(height: 10),

              /// 🔑 New Password Field
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "New Password",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  String otp = otpController.text.trim();
                  String newPassword = newPasswordController.text.trim();

                  if (otp.isNotEmpty && newPassword.isNotEmpty) {
                    bool resetSuccess = await _authServices.resetPassword(email: email, newPassword: newPassword, token: otp);
                    if (resetSuccess) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Password Reset Successful!")),
                      );
                      _navigationService.pushReplacementnamed("/registration");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Invalid OTP or Password Reset Failed")),
                      );
                    }
                  }
                },
                child: Text("Reset Password", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        );
      },
    );
  }
  void _login() async{
    if (!_formKey.currentState!.validate()) return;
    bool success=await widget.authServices.logIn(
      email: emailController.text,
      password: passwordController.text,
    );
    if(success) {
      _navigationService.pushReplacementnamed("/homeloggedIn");
    }
  }
}
