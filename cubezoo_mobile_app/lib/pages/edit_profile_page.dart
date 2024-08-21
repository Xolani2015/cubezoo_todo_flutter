import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(labelText: 'Surname'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
