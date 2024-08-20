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
    final double mediaSize = MediaQuery.of(context).size.height;
    return Scaffold(
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

            return Padding(
              padding: EdgeInsets.all(mediaSize * 0.02),
              child: Column(
                children: [
                  SizedBox(
                    height: mediaSize * 0.01,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            Container(
                              height: mediaSize * 0.1,
                              width: mediaSize * 0.1,
                              child: Image.asset(
                                'assets/images/lion.png', // Path to your image
                                fit: BoxFit.cover, // Adjust as needed
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _logout();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black, // Background color
                            ),
                            height: mediaSize * 0.06,
                            child: Icon(
                              Icons.login,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: mediaSize * 0.03,
                  ),
                  Row(
                    children: [
                      Text(
                        'My To Do List',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: mediaSize * 0.03,
                            color: const Color.fromARGB(255, 238, 129, 129)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mediaSize * 0.03,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          const Color.fromARGB(255, 3, 3, 3).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search ToDos...',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        hintStyle: TextStyle(
                            color: Color.fromARGB(179, 152, 147, 147)),
                      ),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 174, 174, 174)),
                      onChanged: (query) {
                        setState(() {
                          searchQuery = query;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: mediaSize * 0.03,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: mediaSize * 0.5,
                          child: ListView.builder(
                            itemCount: toDos.length,
                            itemBuilder: (context, index) {
                              final toDo = toDos[index];
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0), // Margin for each ToDo
                                decoration: BoxDecoration(
                                  color: Colors.black, // Gray background color
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Rounded corners
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(
                                      12.0), // Padding inside the container
                                  title: Text(
                                    toDo.title,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    toDo.description,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right:
                                                8.0), // Margin between buttons
                                        decoration: BoxDecoration(
                                          color: Colors
                                              .white, // White background for edit button
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors
                                                  .black), // Black edit icon
                                          onPressed: () {
                                            _showEditDialog(context, toDo);
                                          },
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255,
                                              238,
                                              129,
                                              129), // Black background for trash button
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors
                                                  .white), // White trash icon
                                          onPressed: () {
                                            context
                                                .read<ToDoBloc>()
                                                .add(DeleteToDo(toDo.id));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: mediaSize * 0.02,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.only(right: mediaSize * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: mediaSize * 0.1,
                              height: mediaSize * 0.04,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: InkWell(
                                onTap: () {},
                                child: Center(
                                  child: Text(
                                    'View Profile',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: mediaSize * 0.01,
                            ),
                            Container(
                              width: mediaSize * 0.1,
                              height: mediaSize * 0.04,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 238, 129, 129),
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
                              ),
                              child: InkWell(
                                onTap: () {
                                  _showAddDialog(context);
                                }, // Action to be executed on tap
                                child: const Center(
                                  child: Text(
                                    'Add Note',
                                    style: TextStyle(
                                      color: Colors.white, // Text color
                                      fontSize: 16, // Text size
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                    ],
                  )
                ],
              ),
            );
          } else if (state is ToDoError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('No ToDos found.'));
        },
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Less rounded dialog
          ),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20), // Rounded container
              ),
              child: TextButton(
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
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white), // White text color
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 238, 129, 129),
                borderRadius: BorderRadius.circular(20), // Rounded container
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white), // White text color
                ),
              ),
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
