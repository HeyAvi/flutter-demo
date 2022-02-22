import 'package:demo/pages/splash_screen/app_logo.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: AppLogo(
      fontSize: 100,
    ));
  }

  Future<void> navigate() async {
    await Future.delayed(
        const Duration(
          milliseconds: 500,
        ), () {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    });
  }
}
