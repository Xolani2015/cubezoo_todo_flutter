import 'package:equatable/equatable.dart';
import 'package:cubezoo_mobile_app/models/todo_model.dart';

abstract class ToDoState extends Equatable {
  const ToDoState();

  @override
  List<Object?> get props => [];
}

class ToDoInitial extends ToDoState {}

class ToDoLoading extends ToDoState {}

class ToDoLoaded extends ToDoState {
  final List<ToDo> toDos;

  const ToDoLoaded(this.toDos);

  @override
  List<Object?> get props => [toDos];
}

class ToDoError extends ToDoState {
  final String message;

  const ToDoError(this.message);

  @override
  List<Object?> get props => [message];
}
