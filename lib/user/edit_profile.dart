import 'package:flutter/material.dart';

import '../services/Alert_services.dart';
import '../services/Navigation_services.dart';

class EditProfile extends StatelessWidget {
  final String uid; // Pass the user's UID to this page
  final TextEditingController _nameController = TextEditingController();
  final AlertServices _alertServices=AlertServices();
  final NavigationService _navigationService=NavigationService();

  EditProfile({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'New Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal
              ),
              onPressed: () async {
                String newName = _nameController.text.trim();

              },
              child: Text('Update Name',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
