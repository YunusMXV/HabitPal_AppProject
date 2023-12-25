import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/utils/color_utils.dart';
import 'package:habitpal_project/widgets/Text_Fields.dart';
import 'package:habitpal_project/widgets/UI_Buttons.dart';
import 'package:habitpal_project/widgets/image_widget.dart';
import 'package:habitpal_project/widgets/password_fields.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmedpasswordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  late final PasswordField passwordField = PasswordField(controller: _passwordTextController, labelText: "Password",);
  late final PasswordField confirmpasswordField = PasswordField(controller: _confirmedpasswordTextController, labelText: "Confirm Password",);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Sign Up',       
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
          hexToColor("315b7d"), // #B4E1C5 to #ABCEAF to #B0DDD9
          hexToColor("1d4769"), // #315b7d to #1d4769 to #223F57
          hexToColor("223F57")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                imageWidget("assets/images/Signup.png", 150.0),
                const SizedBox(
                  height: 10,
                ),
                reusableTextField("Enter Username", Icons.account_circle_outlined, false,
                    _userNameTextController),
                const SizedBox(
                  height: 15,
                ),
                reusableTextField("Enter Email ID", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 15,
                ),
                passwordField,
                const SizedBox(
                  height: 15,
                ),
                confirmpasswordField,
                const SizedBox(
                  height: 5,
                ),
                reusableUIButton(context, "Sign Up", 0, () {
                  if (_passwordTextController.text == _confirmedpasswordTextController.text) {
                    try {     
                      ref.read(authControllerProvider.notifier).signUpWithEmail(
                        context, 
                        _emailTextController.text, 
                        _passwordTextController.text,
                        _userNameTextController.text,
                      );
                      AlertDialog(
                        title: const Text("Account Created"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      print("Error ${e.toString()}");
                    } 
                  }
                  else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Error"),
                          content: const Text("Password and Confirm Password do not match."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",
                        style: TextStyle(color: Colors.white70)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

