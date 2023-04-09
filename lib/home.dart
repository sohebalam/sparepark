import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_otp/auth/function.dart';
import 'package:sms_otp/auth/sign_in.dart';

class AuthController extends GetxController {
  String userUid = '';
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  @override
  final _auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () async {
              await disconnect();
            },
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Phone number: " + (user?.phoneNumber ?? "")),
            Text("Uid: " + (user?.uid ?? ""))
          ],
        ),
      ),
    );
  }
}
