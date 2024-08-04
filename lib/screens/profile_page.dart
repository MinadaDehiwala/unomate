import 'package:app/screens/login.dart';
import 'package:app/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentSnapshot> _getUserData() async {
    User? user = _auth.currentUser;
    return await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
  }

  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()), // Navigate to login screen
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/business_signup.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
            future: _getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No user data found.'));
              }

              var userData = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/profile_image.png'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      userData['name'] ?? 'N/A',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      userData['email'] ?? 'N/A',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: ListTile(
                        title: Text('Date of Birth'),
                        subtitle: Text(userData['dob'] ?? 'N/A'),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: ListTile(
                        title: Text('Gender'),
                        subtitle: Text(userData['gender'] ?? 'N/A'),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: ListTile(
                        title: Text('NIC'),
                        subtitle: Text(userData['nic'] ?? 'N/A'),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: ListTile(
                        title: Text('University'),
                        subtitle: Text(userData['university'] ?? 'N/A'),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _logout(context),
                      child: Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
