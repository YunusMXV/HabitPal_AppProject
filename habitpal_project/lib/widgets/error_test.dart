import "package:flutter/material.dart";

class ErrorTest extends StatelessWidget {
  final String error;
  const ErrorTest({
    Key? key,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}