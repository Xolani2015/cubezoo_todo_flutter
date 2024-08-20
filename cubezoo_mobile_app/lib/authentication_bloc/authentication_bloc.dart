import 'package:bloc/bloc.dart';
import 'package:cubezoo_mobile_app/authentication_bloc/authentication_event.dart';
import 'package:cubezoo_mobile_app/authentication_bloc/authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthState> {
  AuthenticationBloc() : super(PostAuthentication()) {
    on<reqLogin>((event, emit) async {
      emit(ReqLoading());
      try {} catch (e) {}
    });

    on<reqLogout>((event, emit) async {
      emit(NotLogedin());
    });
  }
}
