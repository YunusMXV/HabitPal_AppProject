import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/utils/gradient_themes.dart';
import 'package:habitpal_project/widgets/auth/UI_Buttons.dart';
import 'package:habitpal_project/widgets/auth/password_fields.dart';
import 'package:routemaster/routemaster.dart';


class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  final TextEditingController _oldPasswordTextController = TextEditingController();
  final TextEditingController _newPasswordTextController = TextEditingController();
  late final PasswordField oldpasswordField = PasswordField(controller: _oldPasswordTextController, labelText: "Old Password",);
  late final PasswordField newpasswordField = PasswordField(controller: _newPasswordTextController, labelText: "New Password",);
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final currentGradient =
        user!.selectedTheme == 'Original'
            ? GradientThemes.originalGradient
            : user.selectedTheme == 'Natural'
                ? GradientThemes.naturalGradient
                : GradientThemes.darkGradient; // Set dark theme gradient
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Change Password',       
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            final currentRoute = Routemaster.of(context).currentRoute;
            print(currentRoute);
            Routemaster.of(context).pop();
            print(currentRoute);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: currentGradient),
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

                  try {
                    ref.read(authControllerProvider.notifier).changePassword(
                                context,
                                _oldPasswordTextController.text,
                                _newPasswordTextController.text,
                              );
                    Navigator.pop(context);
                  } catch (e) {
                    print("Error: $e");
                  }



                  // Get the current user
                  // User? user = FirebaseAuth.instance.currentUser;

                  // // Create a credential using the old password
                  // AuthCredential credential = EmailAuthProvider.credential(
                  //   email: user!.email!,
                  //   password: _oldPasswordTextController.text,
                  // );

                  // // Reauthenticate the user with the old password
                  // user.reauthenticateWithCredential(credential).then((_) {
                  //   // If reauthentication is successful, update the password
                  //   user.updatePassword(_newPasswordTextController.text).then((_) {
                  //     // Password updated successfully
                  //     Navigator.of(context).pop();
                  //   }).catchError((error) {
                  //     print("Error updating password: $error");
                  //   });
                  // }).catchError((error) {
                  //   print("Error reauthenticating user: $error");
                  //   // Handle reauthentication error, e.g., wrong password
                  // });
                }),
              ],
            ),
          ))),
    );
  }
}