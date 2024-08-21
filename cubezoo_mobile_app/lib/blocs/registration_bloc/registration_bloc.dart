import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  RegistrationBloc(this._firebaseAuth, this._firestore)
      : super(RegistrationInitial()) {
    on<RegisterUserEvent>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
      RegisterUserEvent event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());

    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: event.email, password: event.password);

      String uid = userCredential.user?.uid ?? '';

      await _firestore.collection('users').doc(uid).set({
        'name': event.name,
        'surname': event.surname,
        'email': event.email,
        'uid': uid,
      });

      emit(RegistrationSuccess());
    } on FirebaseAuthException catch (e) {
      emit(RegistrationFailure(
        error: e.message ?? 'An unknown error occurred.',
      ));
    } catch (e) {
      emit(RegistrationFailure(
        error: 'An unexpected error occurred: $e',
      ));
    }
  }
}
