import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:green_taxi/views/profile_settings.dart';
import 'package:path/path.dart' as Path;
import 'package:sms_otp/shared/app_constants.dart';
import 'package:google_maps_webservice/places.dart';

// import 'package:green_taxi/models/user_model/user_model.dart';
// import 'package:green_taxi/views/home.dart';
// import 'package:green_taxi/views/profile_settings.dart';

import '../models/user_model.dart';

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
}

User? get user => _auth.currentUser;

Future<String> uploadImage(File image) async {
  try {
    String imageUrl = '';
    String fileName = Path.basename(image.path);
    var reference = FirebaseStorage.instance.ref().child('users/$fileName');
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then(
      (value) {
        imageUrl = value;
        print("Download URL: $value");
      },
    );

    return imageUrl;
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    throw e;
  }
}

Future<void> storeUserInfo(File selectedImage, String name, String home,
    String business, String shop, BuildContext context) async {
  try {
    String url = await uploadImage(selectedImage);
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': url,
      'name': name,
      'home_address': home,
      'business_address': business,
      'shopping_address': shop
    });
  } catch (exception) {
    Fluttertoast.showToast(msg: exception.toString());
    throw exception;
  }
}

late Uint8List markIcons;

loadCustomMarker() async {
  markIcons = await loadAsset('assets/dest_marker.png', 100);
}

Future<Uint8List> loadAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetHeight: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

Future<Prediction?> showGoogleAutoComplete(BuildContext context) async {
  try {
    Prediction? p = await PlacesAutocomplete.show(
      offset: 0,
      radius: 1000,
      strictbounds: false,
      region: "uk",
      language: "en",
      context: context,
      mode: Mode.overlay,
      apiKey: AppConstants.kGoogleApiKey,
      components: [new Component(Component.country, "uk")],
      types: ["(cities)"],
      hint: "Search City",
    );

    if (p == null) {
      Fluttertoast.showToast(msg: "No destination selected");
      return null;
    }

    return p;
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    return null;
  }
}
