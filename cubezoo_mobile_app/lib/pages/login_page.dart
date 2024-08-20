import 'package:cubezoo_mobile_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:cubezoo_mobile_app/blocs/authentication_bloc/authentication_event.dart';
import 'package:cubezoo_mobile_app/blocs/authentication_bloc/authentication_state.dart';
import 'package:cubezoo_mobile_app/pages/to_do_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? emailError;
  String? passwordError;

  bool validateInputs() {
    setState(() {
      emailError = EmailValidator.validate(emailController.text.trim())
          ? null
          : 'Invalid userEmail address';
      passwordError =
          passwordController.text.isEmpty ? 'Password is required' : null;
    });
    return emailError == null && passwordError == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: BlocListener<AuthenticationBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
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
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: emailError,
                ),
              ),
              TextField(
                controller: passwordController,
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
                    onPressed: () {
                      if (validateInputs()) {
                        context.read<AuthenticationBloc>().add(
                              reqLogin(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              ),
                            );
                      }
                    },
                    child: Text('Login'),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthenticationBloc>().add(reqLogout());
                },
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
