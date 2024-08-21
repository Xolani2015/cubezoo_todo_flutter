import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubezoo_mobile_app/pages/edit_profile_page.dart';
import 'package:cubezoo_mobile_app/pages/to_do_page.dart';
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
    final double mediaSize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: mediaSize * 0.1,
              color: const Color.fromARGB(255, 221, 221, 221),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Container(
                          height: mediaSize * 0.1,
                          width: mediaSize * 0.1,
                          child: Image.asset(
                            'assets/images/lion.png', // Path to your image
                            fit: BoxFit.cover, // Adjust as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: mediaSize * 0.02,
            ),
            FutureBuilder<Map<String, dynamic>>(
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
                        Row(
                          children: [
                            Text(
                              'My Profile Picture',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: mediaSize * 0.03,
                                color: const Color.fromARGB(255, 238, 129, 129),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mediaSize * 0.05,
                        ),
                        Container(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          padding: EdgeInsets.all(mediaSize * 0.03),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Name:',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 238, 129, 129),
                                          fontSize: 18)),
                                  SizedBox(
                                    width: mediaSize * 0.05,
                                  ),
                                  Text(userData['name'],
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 128, 128, 128),
                                          fontSize: 18)),
                                ],
                              ),
                              SizedBox(height: mediaSize * 0.02),
                              Row(
                                children: [
                                  Text('Surname:',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 238, 129, 129),
                                          fontSize: 18)),
                                  SizedBox(
                                    width: mediaSize * 0.02,
                                  ),
                                  Text(userData['surname'],
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 128, 128, 128),
                                          fontSize: 18)),
                                ],
                              ),
                              SizedBox(height: mediaSize * 0.02),
                              Row(
                                children: [
                                  Text('Email:',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 238, 129, 129),
                                          fontSize: 18)),
                                  SizedBox(
                                    width: mediaSize * 0.05,
                                  ),
                                  Text(userData['email'],
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 128, 128, 128),
                                          fontSize: 18)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: mediaSize * 0.1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: mediaSize * 0.15,
                              height: mediaSize * 0.06,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (Route<dynamic> route) => false,
                                  );
                                }, // Action to be executed on tap
                                child: const Center(
                                  child: Text(
                                    'Back',
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 16, // Text size
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: mediaSize * 0.02),
                            Container(
                              width: mediaSize * 0.15,
                              height: mediaSize * 0.06,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 238, 129, 129),
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                              ),
                              child: InkWell(
                                onTap: () async {
                                  final userData = await _userProfileData;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfilePage(userData: userData),
                                    ),
                                  );
                                }, // Action to be executed on tap
                                child: const Center(
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 16, // Text size
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('No profile data found.'));
                }
              },
            ),
            SizedBox(
              height: mediaSize * 0.27,
            ),
          ],
        ),
      ),
    );
  }
}
