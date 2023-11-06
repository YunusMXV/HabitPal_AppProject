import 'package:flutter/material.dart';
// import 'package:habitpal_project/widgets/BottomNav.dart';

class Acheivment extends StatefulWidget {
  const Acheivment({super.key});

  @override
  State<Acheivment> createState() => _AcheivmentState();
}

class _AcheivmentState extends State<Acheivment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('Acheivments'),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
    ));
  }
}
