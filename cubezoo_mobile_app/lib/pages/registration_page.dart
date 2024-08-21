import 'package:cubezoo_mobile_app/blocs/registration_bloc/registration_bloc.dart';
import 'package:cubezoo_mobile_app/blocs/registration_bloc/registration_event.dart';
import 'package:cubezoo_mobile_app/blocs/registration_bloc/registration_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_page.dart';

class RegistrationPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  void _register(BuildContext context) {
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    context.read<RegistrationBloc>().add(
          RegisterUserEvent(
            name: name,
            surname: surname,
            email: email,
            password: password,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register 2'),
      ),
      body: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (Route<dynamic> route) => false,
            );
          } else if (state is RegistrationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _surnameController,
                  decoration: InputDecoration(labelText: 'Surname'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                state is RegistrationLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () => _register(context),
                        child: Text('Register'),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
