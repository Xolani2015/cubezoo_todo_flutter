import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserEvent extends RegistrationEvent {
  final String name;
  final String surname;
  final String email;
  final String password;

  const RegisterUserEvent({
    required this.name,
    required this.surname,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, surname, email, password];
}
