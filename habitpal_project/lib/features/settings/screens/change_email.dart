import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpal_project/features/auth/controller/auth_controller.dart';
import 'package:habitpal_project/utils/gradient_themes.dart';
import 'package:habitpal_project/widgets/auth/Text_Fields.dart';
import 'package:habitpal_project/widgets/auth/UI_Buttons.dart';
import 'package:habitpal_project/widgets/auth/password_fields.dart';
import 'package:routemaster/routemaster.dart';


class ChangeEmail extends ConsumerStatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends ConsumerState<ChangeEmail> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _newEmailTextController = TextEditingController();
  late final PasswordField passwordField = PasswordField(controller: _passwordTextController, labelText: "Old Password",);

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
          'Change Email',       
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
                  try {
                    ref.read(authControllerProvider.notifier).changeEmail(
                                context,
                                _passwordTextController.text,
                                _newEmailTextController.text,
                              );
                    Navigator.pop(context);
                  } catch (e) {
                    print("Error: $e");
                  }
                }),
              ],
            ),
          ))),
    );
  }
}