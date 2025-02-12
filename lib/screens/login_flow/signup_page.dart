import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helper/apptheme_color.dart';
import '../../helper/common_button.dart';
import '../../helper/common_textfiled.dart';
import '../../helper/heigh_width.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body:
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          // height: height,
            color: AppThemeColor.primaryColor,
            child:
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height*.13,),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Image.asset("assets/images/food_logo.png",),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child:   Container(
                    width: width,
                    //padding: EdgeInsets.symmetric(horizontal: 35,vertical: 7),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:  Colors.white,
                          offset: Offset(.1, .1,
                          ),
                          // blurRadius: 1.0,
                          //spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            addHeight(30),
                            addHeight(25),
                            const Text("Sign Up",
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Color(0xff222222),),),
                            addHeight(65),
                            CommonTextFieldWidget(
                              controller: nameController,
                              hint: "Name",
                            ),
                            addHeight(10),
                            CommonTextFieldWidget(
                              controller: emailController,
                              hint: "Email",
                            ),
                            addHeight(10),
                            CommonTextFieldWidget(
                              controller: passWordController,
                              hint: "Password",
                            ),
                            addHeight(20),
                            GestureDetector(
                              onTap: (){
                                Get.to(()=>const LoginPage());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Already have an account?",
                                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Color(0xff222222)),),
                                  Image.asset("assets/images/red_arrow.png",),
                                ],
                              ),
                            ),
                            addHeight(50),
                            CommonButtonGreen(
                              title: 'SIGN UP',
                              onPressed: (){

                              },
                            ),
                            addHeight(70),
                            const Center(
                              child: Text("Or sign up with social account",
                                style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Color(0xff222222)),),
                            ),
                            addHeight(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 25,vertical: 7),
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset("assets/images/google.png",height: 40,width: 40,),
                                  ),
                                ),
                                addWidth(40),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 25,vertical: 7),
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset("assets/images/fb.jpeg",height: 40,width: 40,),
                                  ),
                                ),
                              ],
                            ),
                            addHeight(10),
                          ],
                        ),
                      ),
                    ),
                  ), )

              ],
            )

        ),
      ),

    );
  }
}