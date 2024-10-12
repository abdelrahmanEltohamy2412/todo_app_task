import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_states.dart';
import '../data/todo_database.dart';
import 'todo_event.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoDatabase database;

  TodoBloc(this.database) : super(TodoLoading()) {
    on<LoadTodos>((event, emit) async {
      try {
        final todos = await database.readAllTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError('Failed to load todos.'));
      }
    });

    on<AddTodo>((event, emit) async {
      try {
        await database.create(event.todo);
        add(LoadTodos());
      } catch (e) {
        emit(TodoError('Failed to add todo.'));
      }
    });

    on<UpdateTodo>((event, emit) async {
      try {
        await database.update(event.todo);
        add(LoadTodos());
      } catch (e) {
        emit(TodoError('Failed to update todo.'));
      }
    });

    on<DeleteTodo>((event, emit) async {
      try {
        await database.delete(event.id);
        add(LoadTodos());  // لإعادة تحميل القائمة بعد الحذف
      } catch (e) {
        emit(TodoError('Failed to delete todo.'));
      }
    });
  }
}
