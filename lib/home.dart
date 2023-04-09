import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_otp/auth/function.dart';
import 'package:sms_otp/auth/sign_in.dart';

final auth = FirebaseAuth.instance;

final user = auth.currentUser;

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () async {
              await disconnect();
              if (user != null) {
              } else {
                Get.to(SignInView());
              }
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
