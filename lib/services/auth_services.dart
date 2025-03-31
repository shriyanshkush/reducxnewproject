import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthServices {
  static const String baseUrl = "http://3.110.124.83:2030/api/User";

  /// ✅ **Sign Up**
  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
    required String mobileNumber,
    String? contactPerson,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/UserSignUp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
          "active": true,
          "userId": 0,
          "locationId": 0,
          "mobileNumber": mobileNumber,
          "contactPerson": contactPerson ?? "",
          "emailId": email,
          "countyId": 0,
          "municipalityId": 0,
          "countyName": "",
          "municipalityName": ""
        }),
      );

      if (response.statusCode == 201) {
        print("✅ Sign-up successful: ${response.body}");
        return true;
      } else if(response.statusCode == 200) {
        print("✅ Sign-up successful with code 200 : ${response.body}");
        return true;
      } else{
    print("❌ Sign-up failed: ${response.body}");
    }
    } catch (e) {
      print("⚠️ Sign-up error: $e");
    }
    return false;
  }

  /// ✅ **Log In**
  Future<bool> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/UserSignIn"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "emailId": email,
          "password": password,
          "active": true,
        }),
      );

      if (response.statusCode == 201) {
        print("✅ Login successful: ${response.body}");
        return true;
      } else if(response.statusCode == 200){
        print("✅ Login successful: ${response.body}");
        return true;
      } else{
        print("❌ Login failed: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Login error: $e");
    }
    return false;
  }

  /// ✅ **Forgot Password**
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/ForgotPassword"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(email), // API expects raw string
      );

      if (response.statusCode == 200) {
        print("✅ Password reset email sent");
        return true;
      } else {
        print("❌ Forgot password failed: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Forgot password error: $e");
    }
    return false;
  }

  /// ✅ **Reset Password**
  Future<bool> resetPassword({
    required String email,
    required String newPassword,
    required String token, // Assuming reset token is required
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/ResetPassword"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "emailId": email,
          "token": token,
          "newPassword": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Password reset successful");
        return true;
      } else {
        print("❌ Reset password failed: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Reset password error: $e");
    }
    return false;
  }

  /// ✅ **Get User Details**
  Future<Map<String, dynamic>?> getUserDetails(String email) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/GetUserDetail?EmailId=$email"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print("✅ User details fetched: ${response.body}");
        return jsonDecode(response.body);
      } else {
        print("❌ Failed to fetch user details: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Get user details error: $e");
    }
    return null;
  }

  /// ✅ **Log Out** (Handled locally)
  void logout() {
    print("✅ User logged out successfully");
  }
}
