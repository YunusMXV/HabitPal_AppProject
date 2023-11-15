import 'package:flutter/material.dart';

// class PasswordField extends StatefulWidget {
//   const PasswordField({Key? key}) : super(key: key);

//   @override
//   _PasswordFieldState createState() => _PasswordFieldState();
// }

// class _PasswordFieldState extends State<PasswordField> {
//   final textFieldFocusNode = FocusNode();
//   bool _obscured = false;

//   void _toggleObscured() {
//     setState(() {
//       _obscured = !_obscured;
//       if (textFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
//       textFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       keyboardType: TextInputType.visiblePassword,
//       obscureText: _obscured,
//       focusNode: textFieldFocusNode,
//       decoration: InputDecoration(
//         floatingLabelBehavior: FloatingLabelBehavior.never, //Hides label on focus or if filled
//         labelText: "Password",
//         filled: true, // Needed for adding a fill color
//         fillColor: Colors.grey.shade800, 
//         isDense: true,  // Reduces height a bit
//         border: OutlineInputBorder(
//           borderSide: BorderSide.none,              // No border
//           borderRadius: BorderRadius.circular(12),  // Apply corner radius
//         ),
//         prefixIcon: Icon(Icons.lock_rounded, size: 24),
//         suffixIcon: Padding(
//           padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
//           child: GestureDetector(
//             onTap: _toggleObscured,
//             child: Icon(
//               _obscured
//                   ? Icons.visibility_rounded
//                   : Icons.visibility_off_rounded,
//               size: 24,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

TextField reusableTextField(String text, IconData icon, bool isPasswordType, TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.white70,),
      labelText : text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0), 
        borderSide: const BorderSide(color: Colors.transparent),
      ),
    ),
    keyboardType: isPasswordType 
      ? TextInputType.visiblePassword 
      : TextInputType.emailAddress,
  );
}