import "package:flutter/material.dart";
Image imageWidget(String imageName, double size) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: size,
    height : size,
  );
}