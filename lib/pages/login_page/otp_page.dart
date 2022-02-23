import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:demo/pages/user_details/user_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../splash_screen/app_logo.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key, required this.phone, required this.vid})
      : super(key: key);
  final String phone, vid;

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String? otpError;

  TextEditingController textEditingController = TextEditingController();

  String? _otpListened;

  Future<void> otpListener() async {
    String? otpListened;
    try {
      otpListened = await AltSmsAutofill().listenForSms;
      textEditingController.clear();
    } on PlatformException {
      otpListened = 'Failed to get Sms.';
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _otpListened = otpListened;
        print("====>Message: $_otpListened");
        print(_otpListened![0]);
        textEditingController.text = _otpListened![0] +
            _otpListened![1] +
            _otpListened![2] +
            _otpListened![3] +
            _otpListened![4] +
            _otpListened![5];
      });
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    otpListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
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
                        'assets/svg/otp.svg',
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
                            if (val.length == 6) {
                              setState(() {
                                submit();
                              });
                            }
                          },
                          onSubmitted: (v) {
                            setState(() {
                              submit();
                            });
                          },
                          maxLength: 6,
                          controller: textEditingController,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              errorText: otpError,
                              prefixIcon: const Icon(Icons.fact_check_rounded),
                              label: const Text(
                                'One Time Password',
                                style: TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                              helperText: 'Enter the OTP received to proceed',
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
                                  onPressed: submit,
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

  void submit() async {
    // todo verify verification
    setState(() {
      otpError = null;
    });
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.vid, smsCode: textEditingController.text);
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        otpError = e.code;
      });
    }
  }
}
