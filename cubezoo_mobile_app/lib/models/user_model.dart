import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String userEmail;
  final String name;

  User({
    required this.id,
    required this.userEmail,
    required this.name,
  });

  // Convert a User into a Map. The keys must correspond to the names of the fields in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'name': name,
    };
  }

  // Create a User from a Map
  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      userEmail: map['userEmail'] ?? '', // Provide default values if needed
      name: map['name'] ?? '', // Provide default values if needed
    );
  }
}
