import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubezoo_mobile_app/pages/edit_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<Map<String, dynamic>> _userProfileData;

  @override
  void initState() {
    super.initState();
    _userProfileData = _fetchUserProfile();
  }

  Future<Map<String, dynamic>> _fetchUserProfile() async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        throw Exception('User profile not found.');
      }
    } else {
      throw Exception('No user is currently signed in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final userData = await _userProfileData;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(userData: userData),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userProfileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${userData['name']}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Surname: ${userData['surname']}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('Email: ${userData['email']}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text('UID: ${userData['uid']}',
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          } else {
            return Center(child: Text('No profile data found.'));
          }
        },
      ),
    );
  }
}
