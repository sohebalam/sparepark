import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms_otp/shared/auth_controller.dart';

import '../profile/my_profile.dart';

// final auth = FirebaseAuth.instance;

// final user = auth.currentUser;
AuthController authController = Get.put(AuthController());

MyDrawer(user) {
  // AuthController authController = Get.put(AuthController());
  return Drawer(
    child: Column(
      children: [
        InkWell(
          onTap: authController.myUser.value == null
              ? null
              : () {
                  if (user == null) {
                    Fluttertoast.showToast(msg: "No user loaded");
                  } else {
                    Get.to(() => const MyProfile());
                  }
                },
          child: SizedBox(
            height: 150,
            child: DrawerHeader(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: authController.myUser.value.image == null
                          ? const DecorationImage(
                              image: AssetImage('assets/person.png'),
                              fit: BoxFit.fill)
                          : DecorationImage(
                              image: NetworkImage(
                                  authController.myUser.value.image!),
                              fit: BoxFit.fill)),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Good Morning, ',
                          style: GoogleFonts.poppins(
                              color: Colors.black.withOpacity(0.28),
                              fontSize: 14)),
                      Text(
                        authController.myUser.value.name == null
                            ? "Mark"
                            : authController.myUser.value.name!,
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
                    ],
                  ),
                )
              ],
            )),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              buildDrawerItem(title: 'Payment History', onPressed: () {}),
              buildDrawerItem(
                  title: 'Ride History', onPressed: () {}, isVisible: true),
              buildDrawerItem(title: 'Invite Friends', onPressed: () {}),
              buildDrawerItem(title: 'Promo Codes', onPressed: () {}),
              buildDrawerItem(title: 'Settings', onPressed: () {}),
              buildDrawerItem(title: 'Support', onPressed: () {}),
              buildDrawerItem(title: 'Log Out', onPressed: () {}),
            ],
          ),
        ),
        Spacer(),
        Divider(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            children: [
              buildDrawerItem(
                  title: 'Do more',
                  onPressed: () {},
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.15),
                  height: 20),
              const SizedBox(
                height: 5,
              ),
              buildDrawerItem(
                  title: 'Get food delivery',
                  onPressed: () {},
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.15),
                  height: 20),
              buildDrawerItem(
                  title: 'Make money driving',
                  onPressed: () {},
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.15),
                  height: 20),
              buildDrawerItem(
                title: 'Rate us on store',
                onPressed: () {},
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.15),
                height: 20,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}

buildDrawerItem({
  required String title,
  required Function onPressed,
  Color color = Colors.black,
  double fontSize = 20,
  FontWeight fontWeight = FontWeight.w700,
  double height = 45,
  bool isVisible = false,
}) {
  return SizedBox(
    height: height,
    child: ListTile(
      contentPadding: EdgeInsets.all(0),
      // minVerticalPadding: 0,
      dense: true,
      onTap: () => onPressed(),
      title: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: fontSize, fontWeight: fontWeight, color: color),
          ),
          const SizedBox(
            width: 5,
          ),
          isVisible
              ? CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 15,
                  child: Text(
                    '1',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                )
              : Container()
        ],
      ),
    ),
  );
}

Widget buildProfileTile() {
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Obx(() => authController.myUser.value.name == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            width: Get.width,
            height: Get.width * 0.5,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(color: Colors.white70),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: authController.myUser.value.image == null
                          ? DecorationImage(
                              image: AssetImage('assets/person.png'),
                              fit: BoxFit.fill)
                          : DecorationImage(
                              image: NetworkImage(
                                  authController.myUser.value.image!),
                              fit: BoxFit.fill)),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Good Morning, ',
                            style:
                                TextStyle(color: Colors.black, fontSize: 14)),
                        TextSpan(
                            text: authController.myUser.value.name,
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ),
                    Text(
                      "Where are you going?",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                )
              ],
            ),
          )),
  );
}

Widget textWidget(
    {required String text,
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black}) {
  return Text(
    text,
    style: GoogleFonts.poppins(
        fontSize: fontSize, fontWeight: fontWeight, color: color),
  );
}
