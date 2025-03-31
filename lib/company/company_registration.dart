import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // <-- Add this for logo picker

import '../services/auth_services.dart';
import '../services/navigation_services.dart';
import '../services/alert_services.dart';
import '../widgets/Text_form_feild.dart';

class CompanyRegistration extends StatefulWidget {
  final AuthServices authServices;

  CompanyRegistration({required this.authServices});

  @override
  State<StatefulWidget> createState() => _CompanyRegistrationState();
}

class _CompanyRegistrationState extends State<CompanyRegistration> {
  NavigationService get _navigationService => GetIt.I<NavigationService>();
  AuthServices get _authServices => GetIt.I<AuthServices>();
  AlertServices get _alertServices => GetIt.I<AlertServices>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _registrationNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  List<dynamic> counties = [];
  List<dynamic> municipalities = [];
  List<dynamic> serviceCategories = [];

  String? selectedCounty;
  String? selectedMunicipality;
  String? selectedServiceCategory;

  File? _companyLogo;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCounties();
    fetchServiceCategories();
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
        selectedMunicipality = null;
      });
    }
  }

  Future<void> fetchServiceCategories() async {
    final response = await http.get(Uri.parse("http://3.110.124.83:2030/api/ServiceCategory/GetAllServiceCategory"));
    if (response.statusCode == 200) {
      setState(() {
        serviceCategories = json.decode(response.body);
      });
    }
  }

  Future<void> _pickLogo() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _companyLogo = File(pickedFile.path);
      });
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, top: 16),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Company Name"),
                RoundedTextFormField(
                  textEditingController: _nameController,
                  hintText: "Enter your company name",
                ),

                _buildLabel("Registration Number"),
                RoundedTextFormField(
                  textEditingController: _registrationNumberController,
                  hintText: "Enter your registration number",
                ),

                _buildLabel("Company Logo"),
                Row(
                  children: [
                    _companyLogo != null
                        ? Image.file(_companyLogo!, width: 60, height: 60)
                        : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: Icon(Icons.image),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _pickLogo,
                      icon: Icon(Icons.cloud_upload),
                      label: Text("Upload Logo"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                      ),
                    )
                  ],
                ),

                _buildLabel("Company Description"),
                RoundedTextFormField(
                  textEditingController: _descriptionController,
                  hintText: "Enter company description",
                ),

                _buildLabel("Country"),
                DropdownButtonFormField<String>(
                  value: selectedCounty,
                  hint: Text("Select Country"),
                  onChanged: (val) {
                    setState(() => selectedCounty = val);
                    fetchMunicipalities(val!);
                  },
                  items: counties.map<DropdownMenuItem<String>>((county) {
                    return DropdownMenuItem<String>(
                      value: county['countyId'].toString(),
                      child: Text(county['countyName']),
                    );
                  }).toList(),
                ),

                _buildLabel("Municipality"),
                DropdownButtonFormField<String>(
                  value: selectedMunicipality,
                  hint: Text("Select Municipality"),
                  onChanged: (val) => setState(() => selectedMunicipality = val),
                  items: municipalities
                      .where((m) => m['countyId'].toString() == selectedCounty)
                      .map<DropdownMenuItem<String>>((municipality) {
                    return DropdownMenuItem<String>(
                      value: municipality['municipalityId'].toString(),
                      child: Text(municipality['municipalityName']),
                    );
                  }).toList(),
                ),

                _buildLabel("Service Category"),
                DropdownButtonFormField<String>(
                  value: selectedServiceCategory,
                  hint: Text("Select service category"),
                  onChanged: (val) => setState(() => selectedServiceCategory = val),
                  items: serviceCategories.map<DropdownMenuItem<String>>((service) {
                    return DropdownMenuItem<String>(
                      value: service['serviceCategoryId'].toString(),
                      child: Text(service['serviceCategoryName']),
                    );
                  }).toList(),
                ),

                _buildLabel("Email address"),
                RoundedTextFormField(
                  textEditingController: _emailController,
                  hintText: "Eg: name@email.com",
                ),

                _buildLabel("Phone Number"),
                RoundedTextFormField(
                  textEditingController: _mobileNumberController,
                  hintText: "Eg: +91 8372902802",
                ),

                _buildLabel("Password"),
                RoundedTextFormField(
                  textEditingController: _passwordController,
                  hintText: "**** ****",
                  obscureText: true,
                ),

                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Register", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),

                SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => _navigationService.pushnamed("/user-registration"),
                    child: Text(
                      "Register as user",
                      style: TextStyle(color: Colors.amber[800]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Call your API logic here
        bool success = await _authServices.signUp(
          email: _emailController.text,
          password: _passwordController.text,
          username: _nameController.text,
          mobileNumber: _mobileNumberController.text,
        );

        if (success) {
          _alertServices.showToast(text: "Registration successful!", icon: Icons.check);
          _navigationService.pushReplacementnamed("/home");
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
