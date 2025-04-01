import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/models/Services_model.dart';
import 'package:untitled2/user/AllServicesPage.dart';
import 'dart:convert';

import '../services/Alert_services.dart';
import '../services/Navigation_services.dart';
import '../services/auth_services.dart';

class HomePageLoggedIN extends StatefulWidget {
  const HomePageLoggedIN({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageLoggedIN> {

  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AuthServices _authServices;
  late AlertServices _alertServices;

  List<ServicesModel> services = [];
  bool isLoading = true;
  String errorMessage = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _navigationService = _getIt.get<NavigationService>();
    _authServices = _getIt.get<AuthServices>();
    _alertServices = _getIt.get<AlertServices>();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      final response = await http.get(
        Uri.parse('http://3.110.124.83:2030/api/Service/GetServiceList'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          services = data.map((json) => ServicesModel.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load services: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching services: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Home", style: TextStyle(color: Colors.white, fontSize: 20)),
            Image.asset("assets/logo.png", height: 24),
            Icon(Icons.settings, color: Colors.white),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔍 Search Bar
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search here...",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              SizedBox(height: 25),

              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 150,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  enlargeCenterPage: true,
                  viewportFraction: 1.1,
                ),
                itemCount: 3, // Repeat the banner 5 times
                itemBuilder: (context, index, realIndex) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      "assets/banner.png",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                },
              ),

              SizedBox(height: 25),

              /// 🏠 Services Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Services",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow[900])),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllServicesPage(services: services),
                        ),
                      );
                    },
                    child: Text("See all",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              SizedBox(height: 15),

              /// 📌 Service Categories - Now loaded from API
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (errorMessage.isNotEmpty)
                Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: services.length > 4 ? 4 : services.length,
                  itemBuilder: (context, index) {
                    return serviceCard(services[index]);
                  },
                ),

              SizedBox(height: 25),

              /// ℹ️ Missing Service Message
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                    children:[ Text(
                      "Didn't find your service?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.yellow[800],
                        fontSize: 15,
                      ),
                    ),
                      Text(
                        "Don't worry, you can post your requirements",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.yellow[800],
                          fontSize: 15,
                        ),
                      ),
                    ]
                ),
              ),
              SizedBox(height: 25),

              /// 🔘 Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () {

                        },
                        child: Text("New job request",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 8.0),
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.grey[800],
                  //         padding: EdgeInsets.symmetric(vertical: 16),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //         elevation: 3,
                  //       ),
                  //       onPressed: () {
                  //         _showDialog(context);
                  //       },
                  //       child: Text("Register",
                  //           style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.bold)),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),

      /// 📌 Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: ClipRRect(
          child: BottomNavigationBar(
            backgroundColor: Colors.grey[800],
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.white70,
            selectedLabelStyle: TextStyle(fontSize: 12),
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });

              // Handle navigation based on the tapped index
              // if (index == 2) { // Category is at index 2
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => AllServicesPage(services: services),
              //     ),
              //   );
              // }
              // You can add more cases for other tabs if needed
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 26),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month, size: 26),
                label: "My bookings",
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.category, size: 26),
              //   label: "Category",
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 26),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceCard(ServicesModel service) {
    IconData icon;
    // Map service names to appropriate icons
    switch (service.serviceName.toLowerCase()) {
      case 'cleaning':
        icon = FontAwesomeIcons.broom;
        break;
      case 'carpenter':
        icon = FontAwesomeIcons.hammer;
        break;
      case 'painter':
        icon = FontAwesomeIcons.paintRoller;
        break;
      case 'electrician':
        icon = FontAwesomeIcons.bolt;
        break;
      case 'plumber':
        icon = FontAwesomeIcons.wrench;
        break;
      default:
        icon = FontAwesomeIcons.tools;
    }

    return Material(
      borderRadius: BorderRadius.circular(2),
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(2),
        onTap: () {
          // Handle service tap
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: service.imagePath != null && service.imagePath!.isNotEmpty
                        ? Image.network(
                      service.imagePath!,
                      height: 32,
                      width: 32,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(icon, size: 28, color: Colors.blue[700]),
                    )
                        : Icon(icon, size: 28, color: Colors.blue[700]),
                  )
              ),
              SizedBox(height: 12),
              Text(
                service.serviceName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Register',style: TextStyle(fontWeight: FontWeight.bold),),
          content: Text('Register as a',style: TextStyle(fontSize: 18),),
          actions: [
            TextButton(
              onPressed: () {
                _navigationService.pushReplacementnamed("/registration");
              },
              child: Text('User',style: TextStyle(fontSize: 16,color: Colors.black),),
            ),
            TextButton(
              onPressed: () {
                _navigationService.pushReplacementnamed("/companyregistration");
              },
              child: Text('Partener',style: TextStyle(fontSize: 16,color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}