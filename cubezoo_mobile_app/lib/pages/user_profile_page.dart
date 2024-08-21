import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubezoo_mobile_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:cubezoo_mobile_app/models/user_profile_model.dart';
import 'package:cubezoo_mobile_app/pages/login_page.dart';
import 'package:cubezoo_mobile_app/pages/to_do_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel _userModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<UserModel?> getUserDetailsByEmail(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: 'xr.mkhwanazi.20@gmail.com')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Assuming email is unique in your collection
        final doc = querySnapshot.docs.first;
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('User not found in Firestore');
        return null;
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDetails = await getUserDetails(user.uid);
      if (userDetails != null) {
        setState(() {
          _userModel = userDetails;
          _isLoading = false;
        });
      } else {
        print('User details not found.');
      }
    } else {
      print('No user is currently signed in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double mediaSize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: !_isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
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
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black, // Background color
                            ),
                            height: mediaSize * 0.06,
                            child: const Icon(
                              Icons.login,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: mediaSize * 0.01,
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(mediaSize * 0.03),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'My To Do List',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: mediaSize * 0.03,
                                      color: const Color.fromARGB(
                                          255, 238, 129, 129)),
                                ),
                              ],
                            ),
                            // CircleAvatar(
                            //   radius: 50,
                            //   backgroundImage: _userModel.photoUrl != null
                            //       ? NetworkImage(_userModel.photoUrl!)
                            //       : AssetImage('assets/default_profile.png') as ImageProvider,
                            // ),
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black, // Background color
                                borderRadius: BorderRadius.circular(
                                    8.0), // Rounded corners
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      12.0), // Padding inside the container
                              child: TextField(
                                //  controller: emailController,
                                style: TextStyle(
                                    color: Colors.white), // White text color
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                      color: Colors.white), // Label text color
                                  //   errorText: emailError,
                                  border:
                                      InputBorder.none, // Remove default border
                                ),
                              ),
                            ),
                            SizedBox(
                              height: mediaSize * 0.02,
                            ),
                            // TextFormField(
                            //   //  initialValue: _userModel.name,
                            //   decoration: InputDecoration(labelText: 'Name'),
                            //   // onChanged: (value) {
                            //   //   _userModel.name = value;
                            //   // },
                            // ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black, // Background color
                                borderRadius: BorderRadius.circular(
                                    8.0), // Rounded corners
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      12.0), // Padding inside the container
                              child: TextField(
                                //  controller: emailController,
                                style: TextStyle(
                                    color: Colors.white), // White text color
                                decoration: InputDecoration(
                                  labelText: 'Surname',
                                  labelStyle: TextStyle(
                                      color: Colors.white), // Label text color
                                  //   errorText: emailError,
                                  border:
                                      InputBorder.none, // Remove default border
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black, // Background color
                                borderRadius: BorderRadius.circular(
                                    8.0), // Rounded corners
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      12.0), // Padding inside the container
                              child: TextField(
                                //  controller: emailController,
                                style: TextStyle(
                                    color: Colors.white), // White text color
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                      color: Colors.white), // Label text color
                                  //   errorText: emailError,
                                  border:
                                      InputBorder.none, // Remove default border
                                ),
                              ),
                            ),
                            // TextFormField(
                            //   // initialValue: _userModel.email,
                            //   decoration: InputDecoration(labelText: 'Email'),
                            //   // onChanged: (value) {
                            //   //   _userModel.email = value;
                            //   // },
                            // ),
                            SizedBox(height: mediaSize * 0.425),
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  padding:
                                      EdgeInsets.only(right: mediaSize * 0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: mediaSize * 0.13,
                                        height: mediaSize * 0.06,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()),
                                              (Route<dynamic> route) => false,
                                            );
                                          },
                                          child: const Center(
                                            child: Text(
                                              'Back',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: mediaSize * 0.01,
                                      ),
                                      Container(
                                        width: mediaSize * 0.13,
                                        height: mediaSize * 0.06,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 238, 129, 129),
                                          borderRadius: BorderRadius.circular(
                                              8), // Rounded corners
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            _updateUserDetails;
                                          }, // Action to be executed on tap
                                          child: const Center(
                                            child: Text(
                                              'Edit',
                                              style: TextStyle(
                                                color:
                                                    Colors.white, // Text color
                                                fontSize: 16, // Text size
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),

                            SizedBox(height: mediaSize * 0.03),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: const Color.fromARGB(255, 221, 221, 221),
                            height: mediaSize * 0.07,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Future<void> _updateUserDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userModel.uid)
          .update(_userModel.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }
}
