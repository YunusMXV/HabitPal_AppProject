import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitpal_project/utils/color_utils.dart';
import 'package:habitpal_project/widgets/Text_Fields.dart';
import 'package:habitpal_project/widgets/UI_Buttons.dart';
import 'package:habitpal_project/widgets/password_fields.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordTextController = TextEditingController();
  final TextEditingController _newPasswordTextController = TextEditingController();
  late final PasswordField oldpasswordField = PasswordField(controller: _oldPasswordTextController, labelText: "Old Password",);
  late final PasswordField newpasswordField = PasswordField(controller: _newPasswordTextController, labelText: "New Password",);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Change Password",
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
                oldpasswordField,
                const SizedBox(
                  height: 20,
                ),
                newpasswordField,
                const SizedBox(
                  height: 20,
                ),
                reusableUIButton(context, "Confirm", 0, () {
                  // Get the current user
                  User? user = FirebaseAuth.instance.currentUser;

                  // Create a credential using the old password
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user!.email!,
                    password: _oldPasswordTextController.text,
                  );

                  // Reauthenticate the user with the old password
                  user.reauthenticateWithCredential(credential).then((_) {
                    // If reauthentication is successful, update the password
                    user.updatePassword(_newPasswordTextController.text).then((_) {
                      // Password updated successfully
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      print("Error updating password: $error");
                    });
                  }).catchError((error) {
                    print("Error reauthenticating user: $error");
                    // Handle reauthentication error, e.g., wrong password
                  });
                }),
              ],
            ),
          ))),
    );
  }
}