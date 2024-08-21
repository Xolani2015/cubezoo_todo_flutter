import 'package:cubezoo_mobile_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:cubezoo_mobile_app/blocs/authentication_bloc/authentication_event.dart';
import 'package:cubezoo_mobile_app/blocs/todo_bloc/todo_bloc.dart';
import 'package:cubezoo_mobile_app/blocs/todo_bloc/todo_event.dart';
import 'package:cubezoo_mobile_app/blocs/todo_bloc/todo_state.dart';
import 'package:cubezoo_mobile_app/models/todo_model.dart';
import 'package:cubezoo_mobile_app/models/user_profile_model.dart';
import 'package:cubezoo_mobile_app/pages/login_page.dart';
import 'package:cubezoo_mobile_app/pages/user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  bool doneLoading = false;
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
  @override
  @override
  Widget build(BuildContext context) {
    final double mediaSize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocBuilder<ToDoBloc, ToDoState>(
        builder: (context, state) {
          if (state is ToDoError && doneLoading) {
            return Center(child: Text('Error: ${state.message}'));
          }

          // Type cast the list to List<ToDo>
          final List<ToDo> toDos = (state is ToDoLoaded ? state.toDos : [])
              .whereType<ToDo>() // Ensure we only work with ToDo items
              .where((todo) {
            final titleLower = todo.title.toLowerCase();
            final searchLower = searchQuery.toLowerCase();
            return titleLower.contains(searchLower);
          }).toList();

          return _todoList(mediaSize, toDos, context);
        },
      ),
    );
  }

  SingleChildScrollView _todoList(
      double mediaSize, List<ToDo> toDos, BuildContext context) {
    return SingleChildScrollView(
      // Add this
      child: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 221, 221, 221),
            child: Row(
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
          ),
          SizedBox(
            height: mediaSize * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: mediaSize * 0.02),
            child: Column(
              children: [
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
                  height: mediaSize * 0.05,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search ToDos...',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      hintStyle:
                          TextStyle(color: Color.fromARGB(179, 152, 147, 147)),
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
                  height: mediaSize * 0.01,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: mediaSize * 0.49,
                        child: ListView.builder(
                          itemCount: toDos.length,
                          itemBuilder: (context, index) {
                            final toDo = toDos[index];
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: mediaSize * 0.01,
                                  horizontal:
                                      mediaSize * 0.01), // Margin for each ToDo
                              decoration: BoxDecoration(
                                color: Colors.black, // Gray background color
                                borderRadius: BorderRadius.circular(
                                    mediaSize * 0.01), // Rounded corners
                              ),
                              child: ListTile(
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
                                          right: mediaSize *
                                              0.01), // Margin between buttons
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
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 238, 129, 129),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.white),
                                        onPressed: () {
                                          if (toDos.length > 1) {
                                            context
                                                .read<ToDoBloc>()
                                                .add(DeleteToDo(toDo.id));
                                          }
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
                            width: mediaSize * 0.17,
                            height: mediaSize * 0.066,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        ProfilePage(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.ease;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));

                                      return SlideTransition(
                                        position: animation.drive(tween),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  'View Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: mediaSize * 0.02,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: mediaSize * 0.01,
                          ),
                          Container(
                            width: mediaSize * 0.17,
                            height: mediaSize * 0.066,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 238, 129, 129),
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                            child: InkWell(
                              onTap: () {
                                _showAddDialog(context);
                              }, // Action to be executed on tap
                              child: Center(
                                child: Text(
                                  'Add Note',
                                  style: TextStyle(
                                    color: Colors.white, // Text color
                                    fontSize: mediaSize * 0.02, // Text size
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
                  ],
                ),
                SizedBox(
                  height: mediaSize * 0.07,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: const Color.fromARGB(255, 221, 221, 221),
                  height: mediaSize * 0.07,
                ),
              )
            ],
          ),
        ],
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
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: 'Description'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black, // Button background color
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: TextButton(
                child: Text('Add', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  final title = titleController.text;
                  final description = descriptionController.text;
                  if (title.isNotEmpty && description.isNotEmpty) {
                    final newToDo = ToDo(
                      id: DateTime.now().toString(),
                      title: title,
                      description: description,
                      createdAt: DateTime(0),
                    );
                    context.read<ToDoBloc>().add(AddToDo(newToDo));
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black, // Button background color
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: TextButton(
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Less rounded dialog
          ),
          title: Text('Edit ToDo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(hintText: 'Description'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black, // Button background color
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: TextButton(
                child: Text('Save', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  final title = titleController.text;
                  final description = descriptionController.text;
                  if (title.isNotEmpty && description.isNotEmpty) {
                    final updatedToDo = ToDo(
                        id: toDo.id,
                        title: title,
                        description: description,
                        createdAt: DateTime(0));
                    context.read<ToDoBloc>().add(UpdateToDo(updatedToDo));
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 238, 129, 129), // Button background color
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: TextButton(
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
