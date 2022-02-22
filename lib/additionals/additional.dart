import 'package:demo/pages/login_page/login_page.dart';
import 'package:demo/pages/user_details/user_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/home_page/home_page.dart';
import '../pages/splash_screen/splash_screen.dart';

Map<String, Widget Function(BuildContext)> mapRoutes = {
  '/': (context) => const SplashScreen(),
  '/home': (context) => FirebaseAuth.instance.currentUser == null
      ? const LoginPage()
      : FirebaseAuth.instance.currentUser?.displayName == null
          ? const UserDetailsUpdate()
          : const HomePage(),
  '/login': (context) => const LoginPage(),
  '/h': (context) => const HomePage(),
};

late BuildContext dialogContext;

Future<void> pleaseWaitDialog(BuildContext context,
    {required String title, required String msg}) {

  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      dialogContext = context;
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  msg,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}