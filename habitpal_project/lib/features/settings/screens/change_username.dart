import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitpal_project/utils/color_utils.dart';
import 'package:habitpal_project/widgets/Text_Fields.dart';
import 'package:habitpal_project/widgets/UI_Buttons.dart';
import 'package:habitpal_project/widgets/password_fields.dart';


class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  late final PasswordField passwordField = PasswordField(controller: _passwordTextController, labelText: "Current Password",);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Change Username",
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
                reusableTextField("New Username", Icons.person_outline, false,
                    _usernameTextController),
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

                    // Print the old display name before updating
                    print("Old Display Name: ${user.displayName}");

                    // Update the user's display name with the entered username
                    await user.updateDisplayName(_usernameTextController.text);

                    // Print the new display name after updating
                    print("New Display Name: ${user.displayName}");

                    // You can add a success message or navigation logic here
                  } catch (error) {
                    print("Error reauthenticating user: $error");
                    // Handle reauthentication error, e.g., wrong password
                    // You can also display an error message to the user
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}