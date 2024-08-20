import 'package:cubezoo_mobile_app/blocs/todo_bloc/todo_event.dart';
import 'package:cubezoo_mobile_app/blocs/todo_bloc/todo_state.dart';
import 'package:cubezoo_mobile_app/services/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  final FirestoreService _firestoreService;
  String userEmail; // Change to mutable

  ToDoBloc(this._firestoreService, this.userEmail) : super(ToDoInitial()) {
    on<FetchToDos>(_onFetchToDos);
    on<AddToDo>(_onAddToDo);
    on<UpdateToDo>(_onUpdateToDo);
    on<DeleteToDo>(_onDeleteToDo);
    // Optionally handle email update
    on<UpdateUserEmail>(_onUpdateUserEmail);
  }

  void _onFetchToDos(FetchToDos event, Emitter<ToDoState> emit) async {
    try {
      emit(ToDoLoading());
      final toDos = await _firestoreService
          .getToDos(userEmail)
          .first; // Pass userEmail to filter
      emit(ToDoLoaded(toDos));
    } catch (e) {
      emit(const ToDoError('Failed to fetch ToDos'));
    }
  }

  void _onAddToDo(AddToDo event, Emitter<ToDoState> emit) async {
    try {
      await _firestoreService.createToDo(
          event.toDo, userEmail); // Pass userEmail to associate ToDo
      add(FetchToDos()); // Re-fetch ToDos after adding
    } catch (e) {
      emit(const ToDoError('Failed to add ToDo'));
    }
  }

  void _onUpdateToDo(UpdateToDo event, Emitter<ToDoState> emit) async {
    try {
      await _firestoreService.updateToDo(event.toDo);
      add(FetchToDos()); // Re-fetch ToDos after updating
    } catch (e) {
      emit(const ToDoError('Failed to update ToDo'));
    }
  }

  void _onDeleteToDo(DeleteToDo event, Emitter<ToDoState> emit) async {
    try {
      await _firestoreService.deleteToDo(event.id);
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
