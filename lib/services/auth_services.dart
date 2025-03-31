import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // For media type

class AuthServices {
  static const String baseUrl = "http://3.110.124.83:2030/api/User";
  static const String companyBaseUrl = "http://3.110.124.83:2030/api/Company";

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

  /// ✅ **Company Sign Up**
  Future<Map<String, dynamic>?> companySignUp({
    required String username,
    required String password,
    required String mobileNumber,
    required String contactPerson,
    required String emailId,
    required String companyName,
    required String companyRegistrationNumber,
    String? companyPresentation,
    String? competenceDescription,
    String? companyReferences,
    List<dynamic>? jobList,
    List<dynamic>? countyIdList,
    List<dynamic>? municipalityIdList,
    List<dynamic>? serviceIdList,
    List<int>? logoImageBytes,
    String? logoImageName,
    String? logoImagePath,
    String? logoImageContentType,
    List<dynamic>? countyList,
    List<dynamic>? municipalityList,
    List<dynamic>? countyRelationList,
    List<dynamic>? serviceList,
    bool is24X7 = false,
  }) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$companyBaseUrl/CompanySignUp'),
      );

      // Add text fields
      request.fields['Username'] = username;
      request.fields['Password'] = password;
      request.fields['Active'] = 'true';
      request.fields['pCompId'] = '0';
      request.fields['LocationId'] = '0';
      request.fields['MobileNumber'] = mobileNumber;
      request.fields['ContactPerson'] = contactPerson;
      request.fields['EmailId'] = emailId;
      request.fields['CreatedOn'] = DateTime.now().toIso8601String();
      request.fields['UpdatedOn'] = DateTime.now().toIso8601String();
      request.fields['Is24X7'] = is24X7.toString();
      request.fields['CompanyName'] = companyName;
      request.fields['CompanyRegistrationNumber'] = companyRegistrationNumber;
      request.fields['CompanyPresentation'] = companyPresentation ?? '';
      request.fields['CompetenceDescription'] = competenceDescription ?? '';
      request.fields['CompanyReferences'] = companyReferences ?? '';

      // Add list fields as JSON strings
      if (jobList != null) {
        request.fields['JobList'] = jsonEncode(jobList);
      }
      if (countyIdList != null) {
        request.fields['CountyIdList'] = jsonEncode(countyIdList);
      }
      if (municipalityIdList != null) {
        request.fields['MunicipalityIdList'] = jsonEncode(municipalityIdList);
      }
      if (serviceIdList != null) {
        request.fields['ServiceIdList'] = jsonEncode(serviceIdList);
      }
      if (countyList != null) {
        request.fields['CountyList'] = jsonEncode(countyList);
      }
      if (municipalityList != null) {
        request.fields['MunicipalityList'] = jsonEncode(municipalityList);
      }
      if (countyRelationList != null) {
        request.fields['CountyRelationList'] = jsonEncode(countyRelationList);
      }
      if (serviceList != null) {
        request.fields['ServiceList'] = jsonEncode(serviceList);
      }

      // Add logo image if provided
      if (logoImageBytes != null && logoImageName != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'LogoImage',
          logoImageBytes,
          filename: logoImageName,
          contentType: logoImageContentType != null
              ? MediaType.parse(logoImageContentType)
              : null,
        ));
      }

      // Send request
      var response = await request.send();
      print("response: ${response.toString()}");
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("✅ Company sign-up successful: $responseString");
        return jsonDecode(responseString);
      } else {
        print("❌ Company sign-up failed: $responseString");
        return {
          'statusCode': response.statusCode,
          'statusMessage': 'Failed to sign up company',
          'response': responseString
        };
      }
    } catch (e) {
      print("⚠️ Company sign-up error: $e");
      return {
        'statusCode': 500,
        'statusMessage': 'Exception occurred: $e'
      };
    }
  }

  /// ✅ **Log Out** (Handled locally)
  void logout() {
    print("✅ User logged out successfully");
  }
}
