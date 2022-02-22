import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double fontSize;
  const AppLogo({Key? key, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Demo',
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.indigo,
          fontFamily: 'Akaya',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
