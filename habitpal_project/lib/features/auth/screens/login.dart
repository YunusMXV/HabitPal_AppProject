import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/core/utils.dart';
import 'package:habitpal_project/utils/color_utils.dart';
import 'package:habitpal_project/widgets/auth/Text_Fields.dart';
import 'package:habitpal_project/widgets/auth/UI_Buttons.dart';
import 'package:habitpal_project/features/auth/screens/signup.dart';
import 'package:habitpal_project/widgets/image_widget.dart';
import 'package:habitpal_project/features/auth/screens/forgot_password.dart';
import 'package:habitpal_project/widgets/auth/google_sign_in.dart';
import 'package:habitpal_project/widgets/auth/password_fields.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  ConsumerState<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  late final PasswordField passwordField = PasswordField(controller: _passwordTextController, labelText: "Password",);

  @override
  Widget build(BuildContext context) {
    //final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: Container( //body: isLoading ? const Loader() : Container(
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
                  "Enter Email", 
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
                          context, "Log In", 250, () async {

                            try {
                              ref.read(authControllerProvider.notifier).signInWithEmail(
                                context,
                                _emailTextController.text,
                                _passwordTextController.text,
                              );
                            } catch (e) {
                              showSnackBar(context, e.toString());
                            }
                          }
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                const GoogleSignInButton(),
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