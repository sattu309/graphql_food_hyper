import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/screens/login_flow/login_page.dart';
import 'package:shop_app/screens/profile/user_details.dart';
import '../notification_screen.dart';
import '../orders/myorder_screen.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
             const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Order",
              icon: "assets/icons/User Icon.svg",
              press: () => {
                pushScreen(context, screen: const MyOrdersOfMart(), withNavBar: true)
              // Get.to(()=>const MyOrdersOfMart())

              },
            ),
            ProfileMenu(
              text: "User Profile",
              icon: "assets/icons/Settings.svg",
              press: () => {
                pushScreen(context, screen: const UserProfile(), withNavBar: true)
              // Get.to(()=>const MyOrdersOfMart())

              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {
                Get.to(()=>const NotificationScreen());
              },
            ),
            // ProfileMenu(
            //   text: "Settings",
            //   icon: "assets/icons/Settings.svg",
            //   press: () {},
            // ),
            // ProfileMenu(
            //   text: "Help Center",
            //   icon: "assets/icons/Question mark.svg",
            //   press: () {
            //   },
            // ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                 // pref.remove('auth_token');
                pref.clear();
                log(pref.get('auth_token').toString());
                Get.offAll(()=> const LoginPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
