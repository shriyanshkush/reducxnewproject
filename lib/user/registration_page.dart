import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../services/auth_services.dart';
import '../services/Navigation_services.dart';
import '../services/Alert_services.dart';
import '../services/service_locator.dart';
import '../widgets/Text_form_feild.dart';
import '../models/user_model.dart';

class RegistrationPage extends StatefulWidget {
  final AuthServices authServices;

  RegistrationPage({required this.authServices});

  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AuthServices _authServices;
  late AlertServices _alertServices;


  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _contactPersonController;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  List<dynamic> counties = [];
  List<dynamic> municipalities = [];
  List<dynamic> filteredMunicipalities = [];
  String? selectedCounty;
  String? selectedMunicipality;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _mobileNumberController = TextEditingController();
    _contactPersonController = TextEditingController();
    _navigationService = _getIt.get<NavigationService>();
    _authServices = _getIt.get<AuthServices>();
    _alertServices = _getIt.get<AlertServices>();
    fetchCounties();
  }

  Future<void> fetchCounties() async {
    final response = await http.get(Uri.parse("http://3.110.124.83:2030/api/County/GetCountyList"));
    if (response.statusCode == 200) {
      setState(() {
        counties = json.decode(response.body);
      });
    }
  }

  Future<void> fetchMunicipalities(String countyId) async {
    final response = await http.get(Uri.parse("http://3.110.124.83:2030/api/Municipality/GetMunicipalityList"));
    if (response.statusCode == 200) {
      final allMunicipalities = json.decode(response.body);
      setState(() {
        municipalities = allMunicipalities;
        filteredMunicipalities = municipalities.where((m) => m['countyId'].toString() == countyId).toList();
        selectedMunicipality = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align labels to left
              children: [
                SizedBox(height: 20),

                _buildLabel("Username"),
                RoundedTextFormField(textEditingController: _nameController, hintText: "Enter your username"),
                SizedBox(height: 16),

                _buildLabel("Email"),
                RoundedTextFormField(textEditingController: _emailController, hintText: "Enter your email"),
                SizedBox(height: 16),

                _buildLabel("Mobile Number"),
                RoundedTextFormField(textEditingController: _mobileNumberController, hintText: "Enter your mobile number"),
                SizedBox(height: 16),

                _buildLabel("County"),
                DropdownButtonFormField<String>(
                  value: selectedCounty,
                  hint: Text("Select County"),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCounty = newValue;
                    });
                    fetchMunicipalities(newValue!);
                  },
                  items: counties.map((county) {
                    return DropdownMenuItem<String>(
                      value: county['countyId'].toString(),
                      child: Text(county['countyName']),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),

                _buildLabel("Municipality"),
                DropdownButtonFormField<String>(
                  value: selectedMunicipality,
                  hint: Text("Select Municipality"),
                  onChanged: (newValue) {
                    setState(() {
                      selectedMunicipality = newValue;
                    });
                  },
                  items: filteredMunicipalities.map((municipality) {
                    return DropdownMenuItem<String>(
                      value: municipality['municipalityId'].toString(),
                      child: Text(municipality['municipalityName']),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),

                _buildLabel("Password"),
                RoundedTextFormField(textEditingController: _passwordController, hintText: "Enter your password", obscureText: true),
                SizedBox(height: 16),

                _buildLabel("Confirm Password"),
                RoundedTextFormField(textEditingController: _confirmPasswordController, hintText: "Confirm your password", obscureText: true),
                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      backgroundColor: Colors.black,
                    ),
                    child: _isLoading ? CircularProgressIndicator(color: Colors.white) : Text('REGISTER', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _navigateToLogin,
                      child: Text("Register as a partener", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _navigateToLogin() {
    _navigationService.pushnamed("/login");
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        bool success = await _authServices.signUp(
          email: _emailController.text,
          password: _passwordController.text,
          username: _nameController.text,
          mobileNumber: _mobileNumberController.text,
        );

        print("Success: $success");

        if (success) {
          _navigationService.pushReplacementnamed("/home");
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
