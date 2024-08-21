import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubezoo_mobile_app/models/todo_model.dart';
import 'package:cubezoo_mobile_app/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _todosCollection = 'todos';
  final String _usersCollection = 'users';

  // Create a new task for a specific user by userEmail
  Future<void> createToDo(ToDo toDo, String userEmail) async {
    await _firestore.collection(_todosCollection).add({
      ...toDo.toMap(),
      'userEmail': userEmail,
    });
  }

  // Get all tasks for a specific user by userEmail
  Stream<List<ToDo>> getToDos(String userEmail) {
    return _firestore.collection(_todosCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ToDo.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Update a task
  Future<void> updateToDo(ToDo toDo) async {
    await _firestore
        .collection(_todosCollection)
        .doc(toDo.id)
        .update(toDo.toMap());
  }

  // Delete a task
  Future<void> deleteToDo(String id) async {
    await _firestore.collection(_todosCollection).doc(id).delete();
  }

  // Fetch user by userEmail
  Future<User?> getUserByEmail(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_usersCollection)
          .where('userEmail', isEqualTo: userEmail)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return User.fromMap(
            querySnapshot.docs.first.data() as Map<String, dynamic>,
            querySnapshot.docs.first.id);
      }
    } catch (e) {
      print("Error getting user: $e");
    }
    return null;
  }
}

// Get all tasks for a specific user by userEmail
// Stream<List<ToDo>> getToDos(String userEmail) {
//   return _firestore
//       .collection(_todosCollection)
//       .where('userEmail', isEqualTo: userEmail)
//       .snapshots()
//       .map((snapshot) {
//     return snapshot.docs.map((doc) {
//       return ToDo.fromMap(doc.data(), doc.id);
//     }).toList();
//   });
// }

class AuthenticationService {
  Future<void> updateUserProfile(String name, String email) async {
    // Implement the code to update the user profile in your backend
    // This could involve making an API call or updating Firebase user details
  }

  // Other methods...
}
