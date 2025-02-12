import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import '../../constants.dart';
import '../login_flow/login_page.dart';
import '../new_common_tab.dart';
import 'components/splash_content.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to FoodHyper, Let’s shop!",
      "image": "assets/images/splash_1.png"
    },
    {
      "text":
          "We help people conect with store \naround United State of America",
      "image": "assets/images/splash_2.png"
    },
    {
      "text": "We show the easy way to shop. \nJust stay at home with us",
      "image": "assets/images/splash_3.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    onPageChanged: (value) async {
                      setState(() {
                        currentPage = value;
                      });
                      if(value == splashData.length-1){
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        if( pref.getString("auth_token") != null){
                          // Get.offAll(()=>const CustomNavigationBar());
                          Get.offAll(()=>const MinimalExample());
                        }else{
                          Get.offAll(()=>const LoginPage());
                        }
                      }
                    },
                    itemCount: splashData.length,
                    itemBuilder: (context, index) => SplashContent(
                      image: splashData[index]["image"],
                      text: splashData[index]['text'],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            splashData.length,
                            (index) => AnimatedContainer(
                              duration: kAnimationDuration,
                              margin: const EdgeInsets.only(right: 5),
                              height: 6,
                              width: currentPage == index ? 20 : 6,
                              decoration: BoxDecoration(
                                color: currentPage == index
                                    ? AppThemeColor.primaryColor
                                    : const Color(0xFFD8D8D8),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 3),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemeColor.primaryColor
                          ),
                          onPressed: () async {
                            SharedPreferences pref = await SharedPreferences.getInstance();
                            if( pref.getString("auth_token") != null){
                              Get.offAll(()=>const MinimalExample());
                              // Get.offAll(()=>const CustomNavigationBar());
                            }else{
                              Get.offAll(()=>const LoginPage());
                            }
                            // Get.offAll(()=>const CustomNavigationBar());
                            // Navigator.pushNamed(context, SignInScreen.routeName);
                          },
                          child: const Text("Get started"),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
