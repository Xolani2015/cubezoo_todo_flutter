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
          : 'Invalid email address';
      passwordError =
          passwordController.text.isEmpty ? 'Password is required' : null;
    });
    return emailError == null && passwordError == null;
  }

  @override
  Widget build(BuildContext context) {
    final double mediaSize = MediaQuery.of(context).size.height;
    return Scaffold(
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 233, 233, 233),
                      child: Column(
                        children: [
                          Container(
                            height: mediaSize * 0.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.only(right: mediaSize * 0.03),
                                  width: mediaSize * 0.05,
                                  child: Image.asset(
                                    'assets/images/icon.png', // Path to your image
                                    fit: BoxFit.cover, // Adjust as needed
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: mediaSize * 0.35,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: mediaSize * 0.03,
                                          left: mediaSize * 0.03),
                                      child: Image.asset(
                                        'assets/images/lion.png', // Path to your image
                                        fit: BoxFit.cover, // Adjust as needed
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.only(
                                    right: mediaSize * 0.04,
                                  ),
                                  child: Image.asset(
                                    'assets/images/words.png', // Path to your image
                                    fit: BoxFit.cover, // Adjust as needed
                                  ),
                                ))
                              ],
                            ),
                          ),
                          SizedBox(height: mediaSize * 0.08),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: mediaSize * 0.03, horizontal: mediaSize * 0.08),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: mediaSize * 0.02),
                    Row(
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: mediaSize * 0.04,
                              color: const Color.fromARGB(255, 238, 129, 129)),
                        ),
                      ],
                    ),
                    SizedBox(height: mediaSize * 0.02),
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
                    SizedBox(height: mediaSize * 0.08),
                    BlocBuilder<AuthenticationBloc, AuthState>(
                      builder: (context, state) {
                        if (state is ReqLoading) {
                          return ElevatedButton(
                            onPressed: null,
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container(
                          width: 200, // Width of the button
                          height: 50, // Height of the button
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                                255, 238, 129, 129), // Background color
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                          ),
                          child: InkWell(
                            onTap: () {
                              if (validateInputs()) {
                                context.read<AuthenticationBloc>().add(
                                      reqLogin(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      ),
                                    );
                              }
                            }, // Action to be executed on tap
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white, // Text color
                                  fontSize: 16, // Text size
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: mediaSize * 0.03),
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
        ),
      ),
    );
  }
}
