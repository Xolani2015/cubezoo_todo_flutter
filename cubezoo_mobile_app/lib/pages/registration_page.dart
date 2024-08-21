import 'package:cubezoo_mobile_app/blocs/registration_bloc/registration_bloc.dart';
import 'package:cubezoo_mobile_app/blocs/registration_bloc/registration_event.dart';
import 'package:cubezoo_mobile_app/blocs/registration_bloc/registration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_page.dart';

class RegistrationPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
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
  }

  @override
  Widget build(BuildContext context) {
    final double mediaSize = MediaQuery.of(context).size.height;
    return Scaffold(
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
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    height: mediaSize * 0.1,
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: mediaSize * 0.01,
                  ),
                  Container(
                    padding: EdgeInsets.all(mediaSize * 0.01),
                    child: Column(
                      children: [
                        SizedBox(height: mediaSize * 0.05),
                        Row(
                          children: [
                            Text(
                              'Register Your Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: mediaSize * 0.03,
                                color: const Color.fromARGB(255, 238, 129, 129),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: mediaSize * 0.05),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: mediaSize * 0.02),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextFormField(
                            controller: _surnameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Surname',
                              labelStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your surname';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: mediaSize * 0.02),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: mediaSize * 0.02),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextFormField(
                            obscureText: true,
                            controller: _passwordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: mediaSize * 0.04),
                        state is RegistrationLoading
                            ? CircularProgressIndicator()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: mediaSize * 0.15,
                                    height: mediaSize * 0.06,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(
                                          8), // Rounded corners
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()),
                                          (Route<dynamic> route) => false,
                                        );
                                      }, // Action to be executed on tap
                                      child: const Center(
                                        child: Text(
                                          'Back',
                                          style: TextStyle(
                                            color: Colors.white, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: mediaSize * 0.02),
                                  Container(
                                    width: mediaSize * 0.15,
                                    height: mediaSize * 0.06,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 238, 129, 129),
                                      borderRadius: BorderRadius.circular(
                                          8), // Rounded corners
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        _register(context);
                                      }, // Action to be executed on tap
                                      child: const Center(
                                        child: Text(
                                          'Register',
                                          style: TextStyle(
                                            color: Colors.white, // Text color
                                            fontSize: 16, // Text size
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: mediaSize * 0.2,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          height: mediaSize * 0.12,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
