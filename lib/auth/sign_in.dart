import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sms_otp/auth/otp_page.dart';
import 'package:sms_otp/style/contstants.dart';

import 'function.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool loading = false;
  String phoneNumber = '';
  void sendOtpCode() {
    loading = true;
    setState(() {});
    final _auth = FirebaseAuth.instance;
    if (phoneNumber.isNotEmpty) {
      authWithPhoneNumber(phoneNumber, onCodeSend: (verificationId, v) {
        loading = false;
        setState(() {});
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => VerificationOtp(
                  verificationId: verificationId,
                  phoneNumber: phoneNumber,
                )));
      }, onAutoVerify: (v) async {
        await _auth.signInWithCredential(v);
        Navigator.of(context).pop();
      }, onFailed: (e) {
        loading = false;
        setState(() {});
        print("Error code not sent");
      }, autoRetrieval: (v) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Builder(builder: (context) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                  child: Image.asset(
                    'assets/parking.png', // Replace with your logo image
                    width: 200,
                    height: 200,
                  ),
                ),
                const Text("Spare Park"),
                const SizedBox(height: 95),
                Text(
                  "Sign in",
                  style: Theme.of(context).textTheme.titleLarge,
                  // style: TextStyle(
                  //     fontSize: 30,
                  //     // fontWeight: FontWeight.bold,
                  //     fontFamily: "Poppins"),
                ),
                const SizedBox(
                  height: 40,
                ),
                IntlPhoneField(
                  initialCountryCode: "GB",
                  onChanged: (value) {
                    phoneNumber = value.completeNumber;
                  },
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: loading ? null : sendOtpCode,
                      child: loading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              'Sign In',
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
