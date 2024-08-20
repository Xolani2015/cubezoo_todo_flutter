import 'package:cubezoo_mobile_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:cubezoo_mobile_app/blocs/authentication_bloc/authentication_event.dart';
import 'package:cubezoo_mobile_app/blocs/todo_bloc/todo_bloc.dart';
import 'package:cubezoo_mobile_app/blocs/todo_bloc/todo_event.dart';
import 'package:cubezoo_mobile_app/blocs/todo_bloc/todo_state.dart';
import 'package:cubezoo_mobile_app/models/todo_model.dart';
import 'package:cubezoo_mobile_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch todos when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ToDoBloc>().add(FetchToDos());
    });
  }

  void _logout() {
    context.read<AuthenticationBloc>().add(reqLogout());

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search ToDos...',
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintStyle: TextStyle(color: Color.fromARGB(179, 152, 147, 147)),
            ),
            style: const TextStyle(color: Color.fromARGB(255, 174, 174, 174)),
            onChanged: (query) {
              setState(() {
                searchQuery = query;
              });
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),
      body: BlocBuilder<ToDoBloc, ToDoState>(
        builder: (context, state) {
          if (state is ToDoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ToDoLoaded) {
            final toDos = state.toDos.where((todo) {
              final titleLower = todo.title.toLowerCase();
              final searchLower = searchQuery.toLowerCase();
              return titleLower.contains(searchLower);
            }).toList();

            if (toDos.isEmpty) {
              return const Center(child: Text('No ToDos match your search.'));
            }

            return ListView.builder(
              itemCount: toDos.length,
              itemBuilder: (context, index) {
                final toDo = toDos[index];
                return ListTile(
                  title: Text(toDo.title),
                  subtitle: Text(toDo.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(context, toDo);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context.read<ToDoBloc>().add(DeleteToDo(toDo.id));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is ToDoError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('No ToDos found.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add ToDo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;
                if (title.isNotEmpty && description.isNotEmpty) {
                  context.read<ToDoBloc>().add(AddToDo(ToDo(
                        id: '',
                        title: title,
                        description: description,
                        createdAt: DateTime.now(),
                      )));
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, ToDo toDo) {
    final titleController = TextEditingController(text: toDo.title);
    final descriptionController = TextEditingController(text: toDo.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ToDo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;
                if (title.isNotEmpty && description.isNotEmpty) {
                  context.read<ToDoBloc>().add(UpdateToDo(ToDo(
                        id: toDo.id,
                        title: title,
                        description: description,
                        createdAt: toDo.createdAt,
                      )));
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
