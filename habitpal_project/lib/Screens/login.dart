import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitpal_project/Screens/Home.dart';
import 'package:habitpal_project/utils/color_utils.dart';
import 'package:habitpal_project/widgets/Text_Fields.dart';
import 'package:habitpal_project/widgets/UI_Buttons.dart';
import 'package:habitpal_project/Screens/signup.dart';
import 'package:habitpal_project/widgets/image_widget.dart';
import 'package:habitpal_project/Screens/forgot_password.dart';
//import 'package:habitpal_project/widgets/google_sign_in.dart';
import 'package:habitpal_project/widgets/password_fields.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  late final PasswordField passwordField = PasswordField(controller: _passwordTextController, labelText: "Password",);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexToColor("315b7d"), // #B4E1C5 to #ABCEAF to #B0DDD9
            hexToColor("1d4769"), // #315b7d to #1d4769 to #223F57
            hexToColor("223F57") // #000000 to #161618 to #212124
          ], begin: Alignment.topLeft, end: Alignment.bottomRight
          )
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.1, 20, 0
            ),
            child: Column(
              children: <Widget>[
                imageWidget("assets/images/Login.png", 240.0),
                const SizedBox(height: 30.0),
                reusableTextField(
                  "Enter Username", 
                  Icons.person_outline, 
                  false, 
                  _emailTextController
                ),
                const SizedBox(height: 30.0),
                passwordField,
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const ResetPassword())
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: reusableUIButton(
                          context, "Log In", 250, () {
                            FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _emailTextController.text, 
                              password: _passwordTextController.text
                            ).then((value) {
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => const Home())));
                            }).onError((error, stackTrace) {
                              print("Error ${error.toString()}");
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal : 40.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // signInWithGoogle().then((value){
                      //   Navigator.push(context, MaterialPageRoute(builder: ((context) => const Home())));
                      // }).onError((error, stackTrace) {
                      //   print("Error ${error.toString()}");
                      // });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.black26;
                      }
                      return Colors.white;
                    })),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/google.png",
                            height: 32,
                            width: 32,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Login with Gmail",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have account? ",
                        style: TextStyle(color: Colors.white70)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const SignUpScreen()));
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            )
          )
        )
      ),
    );
  }
}