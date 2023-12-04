import 'package:flutter/material.dart';
import 'package:habitpal_project/utils/color_utils.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
        hexToColor("315b7d"), // #B4E1C5 to #ABCEAF to #B0DDD9
        hexToColor("1d4769"), // #315b7d to #1d4769 to #223F57
        hexToColor("223F57")
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}