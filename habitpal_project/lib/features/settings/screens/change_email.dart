import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitpal_project/utils/color_utils.dart';
import 'package:habitpal_project/widgets/Text_Fields.dart';
import 'package:habitpal_project/widgets/UI_Buttons.dart';
import 'package:habitpal_project/widgets/password_fields.dart';


class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _newEmailTextController = TextEditingController();
  late final PasswordField passwordField = PasswordField(controller: _passwordTextController, labelText: "Old Password",);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Change Email",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                const SizedBox(
                  height: 20,
                ),
                passwordField,
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("New Email", Icons.person_outline, false,
                    _newEmailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableUIButton(context, "Confirm", 0, () async {
                  // Get the current user
                  User? user = FirebaseAuth.instance.currentUser;

                  // Create a credential using the entered password
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user!.email!,
                    password: _passwordTextController.text,
                  );

                  try {
                    // Reauthenticate the user with the entered password
                    await user.reauthenticateWithCredential(credential);

                    // Check if the new email is already in use
                    List<String> signInMethods =
                        await FirebaseAuth.instance.fetchSignInMethodsForEmail(_newEmailTextController.text);

                    if (signInMethods.isEmpty) {
                      // If the email is not in use, update the email for the current user
                      await user.updateEmail(_newEmailTextController.text);

                      // Check if the new email is verified
                      if (user.emailVerified) {
                        print("Email updated successfully");
                        Navigator.of(context).pop();
                      } else {
                        // If the email is not verified, you can handle this scenario
                        print("Error: Email is not verified");
                        // You can show a snackbar or any other error message handling here
                      }
                    } else {
                      // If the email is already in use, display an error message
                      print("Error: Email is already in use by another account");
                      // You can show a snackbar or any other error message handling here
                    }
                  } catch (error) {
                    print("Error reauthenticating user: $error");
                    // Handle reauthentication error, e.g., wrong password
                  }
                }),
              ],
            ),
          ))),
    );
  }
}