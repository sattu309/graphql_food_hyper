import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helper/assets_image.dart';
import '../login_flow/login_page.dart';
import '../new_common_tab.dart';

class FoodSplash extends StatefulWidget {
  static String routeName = "/foodSplash";
  const FoodSplash({super.key});

  @override
  State<FoodSplash> createState() => _FoodSplashState();
}

class _FoodSplashState extends State<FoodSplash> {
  userInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getString('auth_token') != null){
      Get.offAll(()=>const MinimalExample());
    }else{
      Get.offAll(()=>const LoginPage());
    }
  }
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2 ), ()async{
      userInfo();
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
            Image.asset(AppAssets.splashImage),
        ],
      ),
    );
  }
}
