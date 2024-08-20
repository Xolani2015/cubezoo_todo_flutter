import 'package:bloc/bloc.dart';
import 'package:cubezoo_mobile_app/authentication_bloc/authentication_event.dart';
import 'package:cubezoo_mobile_app/authentication_bloc/authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthState> {
  AuthenticationBloc() : super(PostAuthentication()) {
    on<reqLogin>((event, emit) async {
      emit(ReqLoading());
      try {} catch (e) {
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
