import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/alert_services.dart';
import '../services/navigation_services.dart';
import '../services/auth_services.dart';
import '../widgets/text_form_feild.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AuthServices _authServices;
  late AlertServices _alertServices;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _navigationService = _getIt.get<NavigationService>();
    _authServices = _getIt.get<AuthServices>();
    _alertServices = _getIt.get<AlertServices>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  "Hi, Welcome Back!",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Hello again, you've been missed!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1.5,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Login to continue using the app",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1.5,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 30),

                // Email Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                RoundedTextFormField(
                  hintText: "Email",
                  textEditingController: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
                SizedBox(height: 20),

                // Password Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                RoundedTextFormField(
                  textEditingController: _passwordController,
                  hintText: "Password",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {},
                ),
                SizedBox(height: 20),

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
                SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 120, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.teal,
                  ),
                ),
                SizedBox(height: 20),

                // OR Divider
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "OR",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Google Login Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // _authServices.googleLogin();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black38),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            Image.asset(
                              "assets/images/google.png",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 15),
                            Text(
                              "Log in with Google",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    GestureDetector(
                      onTap: _navigateToRegister,
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToRegister() {
    _navigationService.pushnamed("/registration");
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        bool result = await _authServices.logIn(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (result) {
          _navigationService.pushReplacementnamed("/home");
        } else {
          _alertServices.showToast(
            text: "Failed to login. Please try again!",
            icon: Icons.error,
          );
        }
      } catch (e) {
        _alertServices.showToast(
          text: "Error: ${e.toString()}",
          icon: Icons.error,
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
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
                    onPressed: () {
                      Navigator.pop(context);
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
}