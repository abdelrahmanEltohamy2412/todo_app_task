import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_states.dart';
import '../models/todo_model.dart';
import 'add_todo_screen.dart';

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            final todos = state.todos;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Dismissible(
                  key: Key(todo.id.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    context.read<TodoBloc>().add(DeleteTodo(todo.id!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${todo.title} deleted')),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text('Priority: ${todo.priority}'),
                    trailing: Checkbox(
                      value: todo.isCompleted,
                      onChanged: (value) {
                        if (value == true) {
                          _showConfirmationDialog(context, todo);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is TodoError) {
            return Center(child: Text('Failed to load todos'));
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddTodoScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // دالة لعرض مربع حوار التأكيد
  void _showConfirmationDialog(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Completion'),
          content: Text('Are you sure you have completed the task "${todo.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق مربع الحوار
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                context.read<TodoBloc>().add(DeleteTodo(todo.id!));
                Navigator.of(context).pop(); // إغلاق مربع الحوار
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${todo.title} completed and deleted')),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
