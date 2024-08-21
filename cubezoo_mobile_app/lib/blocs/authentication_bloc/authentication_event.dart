import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class reqLogin extends AuthenticationEvent {
  final String userEmail;
  final String userPassword;

  reqLogin(this.userEmail, this.userPassword);

  @override
  List<Object> get props => [userEmail, userPassword];
}

class reqLogout extends AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class UpdateProfile extends AuthenticationEvent {
  final String name;
  final String email;

  UpdateProfile(this.name, this.email);

  @override
  List<Object> get props => [name, email];
}
