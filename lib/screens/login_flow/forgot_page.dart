
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../helper/apptheme_color.dart';
import '../../helper/common_button.dart';
import '../../helper/common_textfiled.dart';
import '../../helper/heigh_width.dart';

class Forgotpage extends StatefulWidget {
  const Forgotpage({Key? key}) : super(key: key);

  @override
  State<Forgotpage> createState() => _ForgotpageState();
}

class _ForgotpageState extends State<Forgotpage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body:
      Container(
        width: width,
          color: Colors.white,
          child:
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height*.13,),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Image.asset("assets/images/food_logo.png",),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                child:   Container(
                  width: width,
                  //padding: EdgeInsets.symmetric(horizontal: 35,vertical: 7),
                  decoration:  BoxDecoration(
                    color: AppThemeColor.primaryColor,
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [ Colors.white,Color(0xfffc8907),],
                      // colors: [Color(0xfffc8907), Color(0xfff75f11)],
                    ),
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
                  child:

                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          addHeight(50),
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    Get.back();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Image.asset("assets/images/backArrow.png",height: 40,width: 40,)
                                    ],
                                  )),
                              Text("Forgot Password",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color: Color(0xff222222)),),
                            ],
                          ),
                          addHeight(20),
                          Text("Please, enter your email address you will recive a link to create new password",
                            style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Color(0xff222222)),),
                          addHeight(30),
                          CommonTextFieldWidget(
                            controller: emailController,
                            hint: "Email",
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText:
                                  'Please enter your email '),
                              EmailValidator(errorText: "please enter valid mail")

                            ]),
                          ),
                          addHeight(40),

                          CommonButtonGreen(
                            title: 'SEND',
                            onPressed: (){

                            },
                          ),
                          addHeight(30),
                        ],
                      ),
                    ),
                  ),
                ), )

            ],
          )

      ),
    );
  }
}