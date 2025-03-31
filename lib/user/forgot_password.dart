import 'package:flutter/material.dart';
import '../services/Alert_services.dart';
import '../services/auth_services.dart';
import '../widgets/Text_form_feild.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final AuthServices authServices = AuthServices();
  final AlertServices _alertServices=AlertServices();
   String email="";

  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 15,),
            Center(child: Text("Reset Your Password !",style: TextStyle(fontSize: 18),)),
            SizedBox(height: 30,),
            RoundedTextFormField(
              textEditingController: _emailController,
              hintText: "Email",
              onChanged: (value) {
                email=value!;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
              onPressed: () async {
                if (email.isNotEmpty) {
                  bool success = await authServices.forgotPassword(email);
                  if (success) {
                   _alertServices.showToast(text: "Reset link has been sent to your email, reset password and login again !");
                  } else {
                    _alertServices.showToast(text: 'Failed to send reset email');
                  }
                } else {
                  _alertServices..showToast(text: 'Please enter an email');
                }
              },
              child: Text(
                'Reset Password',
                style: TextStyle(color: Colors.white,fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
