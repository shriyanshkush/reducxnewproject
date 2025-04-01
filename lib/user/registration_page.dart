import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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

  File? _companyLogo;

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
                RoundedTextFormField(textEditingController: _nameController, hintText: "Enter your username",validator: (value) => value!.isEmpty ? 'Required field' : null,),
                SizedBox(height: 16),
                // _buildLabel("Upload Profile Picture"),
                // Row(
                //   children: [
                //     _companyLogo != null
                //         ? ClipRRect(
                //       borderRadius: BorderRadius.circular(8),
                //       child: Image.file(_companyLogo!, width: 60, height: 60, fit: BoxFit.cover),
                //     )
                //         : Container(
                //       width: 60,
                //       height: 60,
                //       decoration: BoxDecoration(
                //         color: Colors.grey[300],
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       child: Icon(Icons.image, color: Colors.grey[600]),
                //     ),
                //     SizedBox(width: 12),
                //     ElevatedButton.icon(
                //       onPressed: _pickLogo,
                //       icon: Icon(Icons.cloud_upload),
                //       label: Text("User Photo"),
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.black87,
                //         foregroundColor: Colors.white,
                //       ),
                //     )
                //   ],
                // ),

                _buildLabel("Email address"),
                RoundedTextFormField(
                  textEditingController: _emailController,
                  hintText: "Eg: name@email.com",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required field';
                    }
                    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                _buildLabel("Mobile Number"),
                RoundedTextFormField(textEditingController: _mobileNumberController, hintText: "Enter your mobile number",validator: (value) => value!.isEmpty ? 'Required field' : null,),
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
                RoundedTextFormField(textEditingController: _passwordController, hintText: "Enter your password", obscureText: true,validator: (value) => value!.isEmpty ? 'Required field' : null,),
                SizedBox(height: 16),

                _buildLabel("Confirm Password"),
                RoundedTextFormField(textEditingController: _confirmPasswordController, hintText: "Confirm your password", obscureText: true,validator: (value) => value!.isEmpty ? 'Required field' : null,),
                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.grey[800],
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
                      child: Text("Register as a partener", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800])),
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
    _navigationService.pushnamed("/companyregistration");
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await _authServices.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: _nameController.text.trim(),
        mobileNumber: _mobileNumberController.text.trim(),
      );

      if (success) {
        _navigationService.pushReplacementnamed("/homeloggedIn");
      } else {
        _alertServices.showToast(text: "Registration failed", icon: Icons.error);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickLogo() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _companyLogo = File(pickedFile.path);
        });
      }
    } catch (e) {
      _alertServices.showToast(
        text: "Error picking image: $e",
        icon: Icons.error,
      );
    }
  }
}
