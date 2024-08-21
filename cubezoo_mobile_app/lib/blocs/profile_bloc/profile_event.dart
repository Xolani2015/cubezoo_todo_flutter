import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserProfile extends ProfileEvent {}

class UpdateUserProfile extends ProfileEvent {
  final String name;
  final String surname;

  UpdateUserProfile(this.name, this.surname);

  @override
  List<Object?> get props => [name, surname];
}
