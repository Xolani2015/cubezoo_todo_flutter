import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  ProfileBloc(this._firebaseAuth, this._firestore) : super(ProfileInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (snapshot.exists) {
          emit(ProfileLoaded(snapshot.data()!));
        } else {
          emit(ProfileFailure('User profile not found.'));
        }
      } else {
        emit(ProfileFailure('No user is currently signed in.'));
      }
    } catch (e) {
      emit(ProfileFailure('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'name': event.name,
          'surname': event.surname,
        });

        emit(ProfileUpdateSuccess());
        add(FetchUserProfile()); // Refresh the profile data after update
      } else {
        emit(ProfileFailure('No user is currently signed in.'));
      }
    } catch (e) {
      emit(ProfileFailure('An unexpected error occurred: $e'));
    }
  }
}
