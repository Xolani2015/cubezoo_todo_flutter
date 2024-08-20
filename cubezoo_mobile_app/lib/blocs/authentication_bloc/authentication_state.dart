import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class PostAuthentication extends AuthState {}

class ReqLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final String userEmail;

  LoginSuccess(this.userEmail);

  @override
  List<Object> get props => [userEmail];
}

class NotLogedin extends AuthState {}

class LoginError extends AuthState {
  final String message;

  LoginError(this.message);

  @override
  List<Object> get props => [message];
}
