import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:untitled2/models/Services_model.dart';


class AllServicesPage extends StatelessWidget {
  final List<ServicesModel> services;

  const AllServicesPage({Key? key, required this.services}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Categories"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.1,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            return _buildServiceCard(services[index]);
          },
        ),
      ),
    );
  }

  Widget _buildServiceCard(ServicesModel service) {
    IconData icon;
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
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Handle service tap
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
                ),
              ),
              SizedBox(height: 12), // Correctly placed inside the column
              Text(
                service.serviceName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
