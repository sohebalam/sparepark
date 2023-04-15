import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sms_otp/firebase_options.dart';
import 'package:sms_otp/home.dart';
import 'package:sms_otp/auth/sign_in.dart';
import 'package:sms_otp/profile/profile_setting.dart';
import 'package:sms_otp/screens/cards.dart';
import 'package:sms_otp/style/contstants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SMS OTP',
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white,

        // Define the default font family.
        fontFamily: 'Poppins',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(
            fontSize: 36.0,
          ),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Text('Error');
              }
              break;
            default:
              break;
          }

          if (snapshot.data == null) {
            return const SignInView();
          }

          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else if (snapshot.data!.exists) {
                    return HomeScreen();
                  } else {
                    return const ProfileSettingScreen();
                  }
                default:
                  return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }
}
