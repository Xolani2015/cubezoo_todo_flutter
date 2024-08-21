import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> userData;

  ProfileLoaded(this.userData);

  @override
  List<Object?> get props => [userData];
}

class ProfileUpdateSuccess extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String error;

  ProfileFailure(this.error);

  @override
  List<Object?> get props => [error];
}
