import 'package:cubezoo_mobile_app/authentication_bloc/authentication_bloc.dart';
import 'package:cubezoo_mobile_app/authentication_bloc/authentication_state.dart';
import 'package:cubezoo_mobile_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc()),
      ],
      child: MaterialApp(
        title: 'CubeZoo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<AuthenticationBloc, AuthState>(
          builder: (context, state) {
            return LoginPage();
          },
        ),
      ),
    );
  }
}
