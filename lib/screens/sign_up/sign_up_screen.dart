import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/screens/login_flow/login_page.dart';
import 'package:shop_app/screens/new_common_tab.dart';
import '../../components/socal_card.dart';
import '../../helper/common_button.dart';
import '../../helper/common_textfiled.dart';
import '../../helper/custom_snackbar.dart';
import '../../helper/heigh_width.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "/sign_up";

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passWordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;

  signUpMutation(
      {
        required String userName,
        required String firstName,
        required String lastName,
        required String email,
        required String userPassword,}) async {


    final MutationOptions options = MutationOptions(
      document: gql('''
      mutation RegisterUser(\$input: RegisterUserInput!) {
        registerUser(
       input:\$input
       ) {
      user {
            id
            username
            firstName
            lastName
            email
            jwtAuthToken
            jwtRefreshToken
            jwtAuthExpiration
        }
        }
      }
    '''),
      variables: {
        'input':{
          'username': userName,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': userPassword,
        }
      },
    );

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      String error = 'An unknown error occurred';
      if (result.exception!.graphqlErrors.isNotEmpty) {
        error = result.exception!.graphqlErrors.first.message;
      }
      print("Register ERROR::::: $error");
      showAddToCartPopup(context,"${error}");
      // final snackBar = CustomSnackbar.build(
      //   message: error,
      //   backgroundColor: AppThemeColor.primaryColor,
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? createLogin = result.data?['registerUser'];
      if (createLogin != null) {
        // SharedPreferences pref = await SharedPreferences.getInstance();
        // var map = {
        //   "authToken": createLogin['authToken'],
        //   "id": createLogin['user']['id'].toString(),
        //   "username": createLogin['user']['username'].toString(),
        //   "email": createLogin['user']['email'].toString(),
        //   "firstName": createLogin['user']['firstName'].toString(),
        //   "lastName": createLogin['user']['lastName'].toString(),
        // };
        // pref.setString("auth_token", jsonEncode(map));
        log("User Registration information ${createLogin['user'].toString()}");
        // Get.offAll(()=>const MinimalExample());
        Get.offAll(()=>const LoginPage());
      } else {
        print('Register errors: Invalid response data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
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
                    addHeight(18),
                    // SizedBox(height: height*.1,),
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

                    decoration: const BoxDecoration(
                      color: Color(0xfff75f11),
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
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            addHeight(10),
                             Text("Sign Up",
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black,),),
                            addHeight(5),
                             Text("Please Sign Up to continue",
                              style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black),),
                            addHeight(15),
                            const Text(
                              "FIRST NAME",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.black),
                            ),
                            addHeight(2),
                            CommonTextFieldWidget(
                              controller: nameController,
                                validator: MultiValidator([
                                  RequiredValidator(errorText: 'Please enter your name '),
                                  // EmailValidator(errorText: "please enter valid mail")
                                ])

                            ),
                            addHeight(10),
                            const Text(
                              "LAST NAME",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.black),
                            ),
                            addHeight(2),
                            CommonTextFieldWidget(
                                controller: lastNameController,
                                validator: MultiValidator([
                                  RequiredValidator(errorText: 'Please enter your name '),
                                  // EmailValidator(errorText: "please enter valid mail")
                                ])

                            ),
                            addHeight(10),
                            const Text(
                              "EMAIL",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.black),
                            ),
                            addHeight(2),
                            CommonTextFieldWidget(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              suffix: Icon(Icons.mail),
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Please enter your email '),
                                // EmailValidator(errorText: "please enter valid mail")
                              ]),
                            ),
                            addHeight(10),
                            Text(
                              "PASSWORD",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.black),
                            ),
                            addHeight(2),
                            CommonTextFieldWidget(
                              controller: passWordController,
                                validator: MultiValidator([
                                  RequiredValidator(errorText: 'Please enter your password '),
                                  // EmailValidator(errorText: "please enter valid mail")
                                ]),
                              suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscureText = !obscureText;
                                    });
                                  },
                                  child: obscureText
                                      ? const Icon(
                                    Icons.visibility_off,
                                    color: Color(0xFF6A5454),
                                  )
                                      : const Icon(Icons.visibility,
                                      color: Color(0xFF6A5454))),
                            ),
                            addHeight(10),
                            GestureDetector(
                              onTap: (){
                                Get.to(()=>const LoginPage());
                              },
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("Already have an account?",
                                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: AppThemeColor.primaryColor),),
                                ],
                              ),
                            ),
                            addHeight(10),
                            CommonButtonGreen(
                              title: 'SIGN UP',
                              onPressed: (){
                                   if (formKey.currentState!.validate()) {
                                  signUpMutation(
                                      userName: emailController.text,
                                      email: emailController.text,
                                      userPassword: passWordController.text,
                                      firstName: nameController.text,
                                      lastName: lastNameController.text);
                                   }
                              },
                            ),
                            addHeight(3),
                            const Center(
                              child: Text("Or sign up with social account",
                                style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Color(0xff222222)),),
                            ),
                            addHeight(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SocalCard(
                                  icon: "assets/icons/google-icon.svg",
                                  press: () {},
                                ),
                                SocalCard(
                                  icon: "assets/icons/facebook-2.svg",
                                  press: () {},
                                ),
                                SocalCard(
                                  icon: "assets/icons/twitter.svg",
                                  press: () {},
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
