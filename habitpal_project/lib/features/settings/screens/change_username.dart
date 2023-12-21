import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/utils/color_utils.dart';
import 'package:habitpal_project/utils/gradient_themes.dart';
import 'package:habitpal_project/widgets/Text_Fields.dart';
import 'package:habitpal_project/widgets/UI_Buttons.dart';
import 'package:habitpal_project/widgets/password_fields.dart';
import 'package:routemaster/routemaster.dart';


class ChangeUsername extends ConsumerStatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends ConsumerState<ChangeUsername> {
  //final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  //late final PasswordField passwordField = PasswordField(controller: _passwordTextController, labelText: "Current Password",);

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
          'Change Username',       
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
              gradient: currentGradient
          ),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                // passwordField,
                // const SizedBox(
                //   height: 20,
                // ),
                reusableTextField("New Username", Icons.person_outline, false,
                    _usernameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableUIButton(context, "Confirm", 0, () async {
                  try {
                    ref.read(authControllerProvider.notifier).changeUsername(
                                context,
                                _usernameTextController.text,
                              );
                    Navigator.pop(context);
                  } catch (e) {
                    print("Error: $e");
                  }

                  // Get the current user
                  // User? user = FirebaseAuth.instance.currentUser;

                  // // Create a credential using the entered password
                  // AuthCredential credential = EmailAuthProvider.credential(
                  //   email: user!.email!,
                  //   password: _passwordTextController.text,
                  // );

                  // try {
                  //   // Reauthenticate the user with the entered password
                  //   await user.reauthenticateWithCredential(credential);

                  //   // Print the old display name before updating
                  //   print("Old Display Name: ${user.displayName}");

                  //   // Update the user's display name with the entered username
                  //   await user.updateDisplayName(_usernameTextController.text);

                  //   // Print the new display name after updating
                  //   print("New Display Name: ${user.displayName}");

                  //   // You can add a success message or navigation logic here
                  // } catch (error) {
                  //   print("Error reauthenticating user: $error");
                  //   // Handle reauthentication error, e.g., wrong password
                  //   // You can also display an error message to the user
                  // }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}