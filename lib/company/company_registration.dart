import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../services/auth_services.dart';
import '../services/Navigation_services.dart';
import '../services/Alert_services.dart';
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
  final TextEditingController _contactPersonController = TextEditingController();

  List<dynamic> counties = [];
  List<dynamic> municipalities = [];
  List<dynamic> services = [];

  // Change from String? to List<String>
  List<String> selectedCounties = [];
  List<String> selectedMunicipalities = [];

  String? selectedCounty;
  String? selectedMunicipality;
  String? selectedService;

  File? _companyLogo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCounties();
    fetchServices();
  }

  Future<void> fetchCounties() async {
    try {
      final response = await http.get(Uri.parse("http://3.110.124.83:2030/api/County/GetCountyList"));
      if (response.statusCode == 200) {
        setState(() {
          counties = json.decode(response.body);
        });
      } else {
        _alertServices.showToast(
          text: "Failed to load counties",
          icon: Icons.error,
        );
      }
    } catch (e) {
      _alertServices.showToast(
        text: "Error loading counties: $e",
        icon: Icons.error,
      );
    }
  }

  Future<void> fetchMunicipalities(String countyId) async {
    try {
      final response = await http.get(Uri.parse("http://3.110.124.83:2030/api/Municipality/GetMunicipalityList"));
      if (response.statusCode == 200) {
        final allMunicipalities = json.decode(response.body);
        setState(() {
          municipalities = allMunicipalities.where((m) => m['countyId'].toString() == countyId).toList();
          selectedMunicipality = null;
        });
      } else {
        _alertServices.showToast(
          text: "Failed to load municipalities",
          icon: Icons.error,
        );
      }
    } catch (e) {
      _alertServices.showToast(
        text: "Error loading municipalities: $e",
        icon: Icons.error,
      );
    }
  }

  Future<void> fetchServices() async {
    try {
      final response = await http.get(Uri.parse("http://3.110.124.83:2030/api/Service/GetServiceList"));
      if (response.statusCode == 200) {
        setState(() {
          services = json.decode(response.body);
        });
      } else {
        _alertServices.showToast(
          text: "Failed to load services",
          icon: Icons.error,
        );
      }
    } catch (e) {
      _alertServices.showToast(
        text: "Error loading services: $e",
        icon: Icons.error,
      );
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
                  validator: (value) => value!.isEmpty ? 'Required field' : null,
                ),

                _buildLabel("Registration Number"),
                RoundedTextFormField(
                  textEditingController: _registrationNumberController,
                  hintText: "Enter your registration number",
                  validator: (value) => value!.isEmpty ? 'Required field' : null,
                ),

                _buildLabel("Company Logo"),
                Row(
                  children: [
                    _companyLogo != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_companyLogo!, width: 60, height: 60, fit: BoxFit.cover),
                    )
                        : Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.image, color: Colors.grey[600]),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _pickLogo,
                      icon: Icon(Icons.cloud_upload),
                      label: Text("Upload Logo"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                      ),
                    )
                  ],
                ),

                _buildLabel("Company Description"),
                RoundedTextFormField(
                  textEditingController: _descriptionController,
                  hintText: "Enter company description",
                  validator: (value) => value!.isEmpty ? 'Required field' : null,
                ),

                _buildLabel("Contact Person"),
                RoundedTextFormField(
                  textEditingController: _contactPersonController,
                  hintText: "Enter contact person name",
                  validator: (value) => value!.isEmpty ? 'Required field' : null,
                ),

                // _buildLabel("County"),
                // DropdownButtonFormField<String>(
                //   value: selectedCounty,
                //   hint: Text("Select County"),
                //   validator: (value) => value == null ? 'Please select a county' : null,
                //   onChanged: (val) {
                //     setState(() => selectedCounty = val);
                //     fetchMunicipalities(val!);
                //   },
                //   items: counties.map<DropdownMenuItem<String>>((county) {
                //     return DropdownMenuItem<String>(
                //       value: county['countyId'].toString(),
                //       child: Text(county['countyName']),
                //     );
                //   }).toList(),
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //   ),
                // ),
                //
                // if (selectedCounty != null) ...[
                //   _buildLabel("Municipality"),
                //   DropdownButtonFormField<String>(
                //     value: selectedMunicipality,
                //     hint: Text("Select Municipality"),
                //     validator: (value) => value == null ? 'Please select a municipality' : null,
                //     onChanged: (val) => setState(() => selectedMunicipality = val),
                //     items: municipalities.map<DropdownMenuItem<String>>((municipality) {
                //       return DropdownMenuItem<String>(
                //         value: municipality['municipalityId'].toString(),
                //         child: Text(municipality['municipalityName']),
                //       );
                //     }).toList(),
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //     ),
                //   ),
                // ],
                _buildLabel("County"),
                MultiSelectDropdown(
                  items: counties,
                  selectedValues: selectedCounties,
                  hintText: "Select one or more counties",
                  displayItem: (county) => county['countyName'],
                  getValue: (county) => county['countyId'].toString(),
                  onChanged: (values) {
                    setState(() {
                      selectedCounties = values;
                      selectedMunicipalities = [];
                    });

                    if (values.isNotEmpty) {
                      fetchMunicipalities(values.last); // Fetch municipalities for the latest selected county
                    }
                  },
                  validator: (values) => values.isEmpty ? 'Please select at least one county' : null,
                ),

                if (selectedCounties.isNotEmpty) ...[
                  _buildLabel("Municipality"),
                  MultiSelectDropdown(
                    items: municipalities
                        .where((m) => selectedCounties.contains(m['countyId'].toString()))
                        .toList(),
                    selectedValues: selectedMunicipalities,
                    hintText: "Select one or more municipalities",
                    displayItem: (municipality) => municipality['municipalityName'],
                    getValue: (municipality) => municipality['municipalityId'].toString(),
                    onChanged: (values) {
                      setState(() => selectedMunicipalities = values);
                    },
                    validator: (values) => values.isEmpty ? 'Please select at least one municipality' : null,
                  ),
                ],


                _buildLabel("Service"),
                DropdownButtonFormField<String>(
                  value: selectedService,
                  hint: Text("Select service"),
                  validator: (value) => value == null ? 'Please select a service' : null,
                  onChanged: (val) => setState(() => selectedService = val),
                  items: services.map<DropdownMenuItem<String>>((service) {
                    return DropdownMenuItem<String>(
                      value: service['serviceId'].toString(),
                      child: Text(service['serviceName']),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),

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

                _buildLabel("Phone Number"),
                RoundedTextFormField(
                  textEditingController: _mobileNumberController,
                  hintText: "Eg: +91 8372902802",
                  validator: (value) => value!.isEmpty ? 'Required field' : null,
                ),

                _buildLabel("Password"),
                RoundedTextFormField(
                  textEditingController: _passwordController,
                  hintText: "**** ****",
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Required field' : null,
                ),

                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _registerCompany,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                    onPressed: () => _navigationService.pushnamed("/registration"),
                    child: Text(
                      "Register as user",
                      style: TextStyle(color: Colors.grey[800]),
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

  Future<void> _registerCompany() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Prepare logo bytes if image was selected
      Uint8List? logoBytes;
      String? logoName;
      if (_companyLogo != null) {
        logoBytes = await _companyLogo!.readAsBytes();
        logoName = _companyLogo!.path.split('/').last;
      }

      // Call the company signup API
      final result = await _authServices.companySignUp(
        username: _nameController.text,
        password: _passwordController.text,
        mobileNumber: _mobileNumberController.text,
        contactPerson: _contactPersonController.text,
        emailId: _emailController.text,
        companyName: _nameController.text,
        companyRegistrationNumber: _registrationNumberController.text,
        companyPresentation: _descriptionController.text,
        competenceDescription: _descriptionController.text,
        // countyIdList: selectedCounty != null ? [selectedCounty] : [],
        // municipalityIdList: selectedMunicipality != null ? [selectedMunicipality] : [],
        countyIdList: selectedCounties.isNotEmpty ? selectedCounties : [],
        municipalityIdList: selectedMunicipalities.isNotEmpty ? selectedMunicipalities : [],
        serviceIdList: selectedService != null ? [selectedService] : [],
        logoImageBytes: logoBytes,
        logoImageName: logoName,
      );

      if (result?['statusCode'] == 1) {
        _alertServices.showToast(text: "Company registration successful!", icon: Icons.check);
        _navigationService.pushReplacementnamed("/homeloggedIn");
      } else {
        _alertServices.showToast(
          text: result?['statusMessage'] ?? "Registration failed",
          icon: Icons.error,
        );
      }
    } catch (e) {
      _alertServices.showToast(
        text: "Error during registration: $e",
        icon: Icons.error,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

}


class MultiSelectDropdown extends StatefulWidget {
  final List<dynamic> items;
  final List<String> selectedValues;
  final String hintText;
  final String Function(dynamic) displayItem;
  final String Function(dynamic) getValue;
  final void Function(List<String>) onChanged;
  final String? Function(List<String>)? validator;

  const MultiSelectDropdown({
    Key? key,
    required this.items,
    required this.selectedValues,
    required this.hintText,
    required this.displayItem,
    required this.getValue,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  void _openMultiSelectDialog() async {
    List<String> tempSelected = List.from(widget.selectedValues);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Select Options",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: widget.items.map((item) {
                        String itemValue = widget.getValue(item);
                        return CheckboxListTile(
                          title: Text(widget.displayItem(item)),
                          value: tempSelected.contains(itemValue),
                          onChanged: (checked) {
                            setState(() {
                              checked == true
                                  ? tempSelected.add(itemValue)
                                  : tempSelected.remove(itemValue);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                    ),
                    onPressed: () {
                      widget.onChanged(tempSelected);
                      Navigator.pop(context);
                    },
                    child: Text("Done",style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openMultiSelectDialog,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Wrap(
          spacing: 6.0,
          children: widget.selectedValues.map((value) {
            return Chip(
              label: Text(value),
              onDeleted: () {
                List<String> updatedValues = List.from(widget.selectedValues);
                updatedValues.remove(value);
                widget.onChanged(updatedValues);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
