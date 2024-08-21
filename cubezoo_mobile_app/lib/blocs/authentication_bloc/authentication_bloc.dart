// auth_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubezoo_mobile_app/blocs/authentication_bloc/authentication_event.dart';
import 'package:cubezoo_mobile_app/blocs/authentication_bloc/authentication_state.dart';
import 'package:cubezoo_mobile_app/models/user_profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthenticationBloc() : super(PostAuthentication()) {
    final AuthenticationService _authenticationService;

    on<reqLogin>((event, emit) async {
      emit(ReqLoading());
      try {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: event.userEmail,
          password: event.userPassword,
        );
        final userEmail = userCredential.user?.email ?? '';
        Fluttertoast.showToast(
            backgroundColor: Color.fromARGB(255, 255, 179, 0),
            msg: "Firebase Auth Succesful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            textColor: Color.fromARGB(255, 0, 0, 0),
            fontSize: 11);
        emit(LoginSuccess(userEmail));
      } catch (e) {
        print('Error during login: ${e.toString()}');
        String errorMessage;
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'invalid-userEmail':
              errorMessage = 'The userEmail address is badly formatted.';
              break;
            case 'user-disabled':
              errorMessage =
                  'The user account has been disabled by an administrator.';
              break;
            case 'invalid-credential':
              errorMessage =
                  'There is no user record corresponding to this identifier.';
              break;
            case 'wrong-userPassword':
              errorMessage =
                  'The userPassword is invalid or the user does not have a userPassword.';
              break;
            default:
              errorMessage = 'An undefined error happened.';
          }
        } else {
          errorMessage = 'An unexpected error occurred.';
        }
        print('Error message: $errorMessage');
        emit(LoginError(errorMessage));
      }
    });

    on<reqLogout>((event, emit) async {
      await _firebaseAuth.signOut();
      emit(NotLogedin());
    });
  }
}

Future<UserModel?> getUserDetails(String uid) async {
  final docSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (docSnapshot.exists) {
    return UserModel.fromMap(docSnapshot.data()!);
  }
  return null;
}

class AuthenticationService {
  Future<void> updateUserProfile(String name, String email) async {
    // Implement the code to update the user profile in your backend
    // This could involve making an API call or updating Firebase user details
  }

  // Other methods...
}
