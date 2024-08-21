import 'dart:ui';

import 'package:cubezoo_mobile_app/blocs/todo_bloc/todo_event.dart';
import 'package:cubezoo_mobile_app/blocs/todo_bloc/todo_state.dart';
import 'package:cubezoo_mobile_app/services/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  final FirestoreService _firestoreService;
  String userEmail;

  ToDoBloc(this._firestoreService, this.userEmail) : super(ToDoInitial()) {
    on<FetchToDos>(_onFetchToDos);
    on<AddToDo>(_onAddToDo);
    on<UpdateToDo>(_onUpdateToDo);
    on<DeleteToDo>(_onDeleteToDo);

    on<UpdateUserEmail>(_onUpdateUserEmail);
  }

  void _onFetchToDos(FetchToDos event, Emitter<ToDoState> emit) async {
    try {
      emit(ToDoLoading());
      //final toDos = await _firestoreService.getToDos(userEmail).first;
      final toDos = await _firestoreService.getToDos(userEmail).first;
      emit(ToDoLoaded(toDos));
    } catch (e) {
      emit(const ToDoError('Failed to fetch ToDos'));
    }
  }

  void _onAddToDo(AddToDo event, Emitter<ToDoState> emit) async {
    try {
      await _firestoreService.createToDo(event.toDo, userEmail);
      Fluttertoast.showToast(
          backgroundColor: Color.fromARGB(255, 255, 179, 0),
          msg: "Firebase Add Succesful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          textColor: Color.fromARGB(255, 0, 0, 0),
          fontSize: 11);
      add(FetchToDos());
    } catch (e) {
      emit(const ToDoError('Failed to add ToDo'));
    }
  }

  void _onUpdateToDo(UpdateToDo event, Emitter<ToDoState> emit) async {
    try {
      await _firestoreService.updateToDo(event.toDo);
      Fluttertoast.showToast(
          backgroundColor: Color.fromARGB(255, 255, 179, 0),
          msg: "Firebase Update Succesful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          textColor: Color.fromARGB(255, 0, 0, 0),
          fontSize: 11);
      add(FetchToDos()); // Re-fetch ToDos after updating
    } catch (e) {
      emit(const ToDoError('Failed to update ToDo'));
    }
  }

  void _onDeleteToDo(DeleteToDo event, Emitter<ToDoState> emit) async {
    try {
      await _firestoreService.deleteToDo(event.id);
      Fluttertoast.showToast(
          backgroundColor: Color.fromARGB(255, 255, 179, 0),
          msg: "Firebase Delele Succesful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          textColor: Color.fromARGB(255, 0, 0, 0),
          fontSize: 11);
      add(FetchToDos()); // Re-fetch ToDos after deleting
    } catch (e) {
      emit(const ToDoError('Failed to delete ToDo'));
    }
  }

  void _onUpdateUserEmail(UpdateUserEmail event, Emitter<ToDoState> emit) {
    userEmail = event.newEmail;

    add(FetchToDos()); // Optionally refetch ToDos
  }
}

// Define UpdateUserEmail event
class UpdateUserEmail extends ToDoEvent {
  final String newEmail;

  UpdateUserEmail(this.newEmail);
}
