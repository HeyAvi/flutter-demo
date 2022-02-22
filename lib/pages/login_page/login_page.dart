import 'package:demo/pages/login_page/otp_page.dart';
import 'package:demo/pages/splash_screen/app_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? phone, vid, errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SvgPicture.asset(
                        'assets/svg/phone.svg',
                        height: 200,
                        width: 50,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const AppLogo(
                        fontSize: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: (val) {
                            setState(() {
                              phone = val;
                            });
                          },
                          onSubmitted: submit,
                          decoration: InputDecoration(
                              prefix: const Text('+'),
                              errorText: errorText,
                              label: const Text(
                                'Phone',
                                style: TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                              hintText: '',
                              helperText: 'Enter your number to proceed',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Flexible(
                              child: Text(
                                'By logging in, you accept our terms and conditions',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            CircleAvatar(
                              radius: 25,
                              child: IconButton(
                                  iconSize: 25,
                                  onPressed: () {
                                    submit(null);
                                  },
                                  icon:
                                      const Icon(Icons.navigate_next_outlined)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void submit(String? text) async {
    setState(() {
      errorText = null;
    });
    if (phone == null || phone!.isEmpty) {
      setState(() {
        errorText = 'Please enter a phone number';
      });
    } else {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+$phone',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            errorText = e.code;
          });
        },
        timeout: const Duration(seconds: 5),
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) =>
                      OtpPage(phone: '+$phone', vid: verificationId)),
            );
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }
}
