import 'package:cubezoo_mobile_app/authentication_bloc/authentication_bloc.dart';
import 'package:cubezoo_mobile_app/authentication_bloc/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? emailError;
  String? passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: BlocListener<AuthenticationBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: emailError,
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: passwordError,
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              BlocBuilder<AuthenticationBloc, AuthState>(
                builder: (context, state) {
                  if (state is ReqLoading) {
                    return ElevatedButton(
                      onPressed: null,
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {},
                    child: Text('Login'),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
