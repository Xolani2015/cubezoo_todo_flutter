import 'package:cubezoo_mobile_app/pages/to_do_page.dart';
import 'package:cubezoo_mobile_app/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfilePage({required this.userData, super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userData['name'];
    _surnameController.text = widget.userData['surname'];
  }

  Future<void> _updateProfile() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'name': _nameController.text.trim(),
        'surname': _surnameController.text.trim(),
      });

      Fluttertoast.showToast(
          backgroundColor: Color.fromARGB(255, 255, 179, 0),
          msg: "Firebase Edit Succesful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          textColor: Color.fromARGB(255, 0, 0, 0),
          fontSize: 11);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double mediaSize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: <Widget>[
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
          Container(
            padding: EdgeInsets.all(mediaSize * 0.05),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: mediaSize * 0.03,
                        color: const Color.fromARGB(255, 238, 129, 129),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: mediaSize * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white),
                      errorStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: mediaSize * 0.02),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: _surnameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.white),
                      errorStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: mediaSize * 0.07),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: mediaSize * 0.15,
                      height: mediaSize * 0.07,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: mediaSize * 0.03),
                    Container(
                      width: mediaSize * 0.15,
                      height: mediaSize * 0.07,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 238, 129, 129),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () {
                          _updateProfile();
                        },
                        child: Center(
                          child: Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white, // Text color
                              fontSize: 16, // Text size
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
