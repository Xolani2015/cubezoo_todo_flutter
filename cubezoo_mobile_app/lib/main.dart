import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubezoo_mobile_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:cubezoo_mobile_app/blocs/authentication_bloc/authentication_state.dart';
import 'package:cubezoo_mobile_app/blocs/registration_bloc/registration_bloc.dart';
import 'package:cubezoo_mobile_app/blocs/todo_bloc/todo_bloc.dart';
import 'package:cubezoo_mobile_app/pages/to_do_page.dart';
import 'package:cubezoo_mobile_app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cubezoo_mobile_app/pages/login_page.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cubezoo_mobile_app/pages/login_page.dart';
import 'package:cubezoo_mobile_app/pages/registration_page.dart'; // Import the RegistrationPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyB27HplczhCPZ4IyNQs5dA7N5lhcTaFqHo',
      appId: '1:76986740027:android:0e696ada3a323fa5505b1e',
      messagingSenderId: '76986740027',
      projectId: 'cubetodoapp',
      storageBucket: 'cubetodoapp.appspot.com',
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc()),
        BlocProvider(create: (context) => ToDoBloc(FirestoreService(), '')),
        BlocProvider(
            create: (context) => RegistrationBloc(FirebaseAuth.instance,
                FirebaseFirestore.instance)), // Add the RegistrationBloc
      ],
      child: MaterialApp(
        title: 'CubeZoo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<AuthenticationBloc, AuthState>(
          builder: (context, state) {
            if (state is LoginSuccess) {
              final toDoBloc = context.read<ToDoBloc>();
              toDoBloc.add(UpdateUserEmail(state.userEmail));
              return HomePage();
            } else {
              return LoginPage();
            }
          },
        ),
        routes: {
          '/registration': (context) => RegistrationPage(),
        },
      ),
    );
  }
}
