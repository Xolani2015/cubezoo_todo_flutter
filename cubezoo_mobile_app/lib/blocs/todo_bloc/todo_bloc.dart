import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  final FirestoreService _firestoreService;

  ToDoBloc(this._firestoreService, this.userEmail) : super(ToDoInitial()) {
    on<FetchToDos>(_onFetchToDos);
    on<AddToDo>(_onAddToDo);

    on<UpdateUserEmail>(_onUpdateUserEmail);
  }

  void _onFetchToDos(FetchToDos event, Emitter<ToDoState> emit) async {
    try {
      emit(ToDoLoaded(toDos));
    } catch (e) {
      emit(const ToDoError('Failed to fetch ToDos'));
    }
  }

  void _onDeleteToDo(DeleteToDo event, Emitter<ToDoState> emit) async {
    try {
      await _firestoreService.deleteToDo(event.id);
    } catch (e) {
      emit(const ToDoError('Failed to delete ToDo'));
    }
  }
}
