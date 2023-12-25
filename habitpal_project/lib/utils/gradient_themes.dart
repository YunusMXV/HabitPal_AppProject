
import 'package:flutter/material.dart';
import 'color_utils.dart';

class GradientThemes {
  static final originalGradient = LinearGradient(
    colors: [
      hexToColor("#315b7d"),
      hexToColor("#1d4769"),
      hexToColor("#223F57"),
    ],
    begin: Alignment.topCenter, end: Alignment.bottomCenter
  );

  static final naturalGradient = LinearGradient(
    colors: [
      hexToColor("#067466"),
      hexToColor("#067488"),
      hexToColor("#A18DD6"),
    ],
    begin: Alignment.topCenter, end: Alignment.bottomCenter
  );

  static final darkGradient = LinearGradient(
    colors: [
      hexToColor("#000000"),
      hexToColor("#161618"),
      hexToColor("#212124"),
    ],
    begin: Alignment.topCenter, end: Alignment.bottomCenter
  );
}
