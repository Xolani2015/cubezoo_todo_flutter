import 'package:equatable/equatable.dart';
import 'package:cubezoo_mobile_app/models/todo_model.dart';

abstract class ToDoEvent extends Equatable {
  const ToDoEvent();

  @override
  List<Object?> get props => [];
}

class FetchToDos extends ToDoEvent {}

class AddToDo extends ToDoEvent {
  final ToDo toDo;

  const AddToDo(this.toDo);

  @override
  List<Object?> get props => [toDo];
}

class UpdateToDo extends ToDoEvent {
  final ToDo toDo;

  const UpdateToDo(this.toDo);

  @override
  List<Object?> get props => [toDo];
}

class DeleteToDo extends ToDoEvent {
  final String id;

  const DeleteToDo(this.id);

  @override
  List<Object?> get props => [id];
}
