import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _auth = FirebaseAuth.instance;
void authWithPhoneNumber(String phone,
    {required Function(String value, int? value1) onCodeSend,
    required Function(PhoneAuthCredential value) onAutoVerify,
    required Function(FirebaseAuthException value) onFailed,
    required Function(String value) autoRetrieval}) async {
  _auth.verifyPhoneNumber(
    phoneNumber: phone,
    timeout: const Duration(seconds: 20),
    verificationCompleted: onAutoVerify,
    verificationFailed: onFailed,
    codeSent: onCodeSend,
    codeAutoRetrievalTimeout: autoRetrieval,
  );
}

Future<void> validateOtp(String smsCode, String verificationId) async {
  try {
    final _credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    await _auth.signInWithCredential(_credential);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'invalid-verification-code') {
      print('The verification code provided is invalid.');
    }
    Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  } catch (e) {
    print("Error signing in with credential: $e");
    Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

Future<void> disconnect() async {
  await _auth.signOut();
  return;
}

User? get user => _auth.currentUser;
