import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/screens/sign_up/sign_up_screen.dart';
import '../../components/socal_card.dart';
import '../../helper/common_button.dart';
import '../../helper/common_textfiled.dart';
import '../../helper/heigh_width.dart';
import '../../helper/snackbar_popup.dart';
import '../new_common_tab.dart';
import '../profile/components/custom_loader.dart';
import 'forgot_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.grey.shade50,
        body:
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: height,
            width: width,
            color: Colors.white,
            child:
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height*.10,),
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
                    decoration:  const BoxDecoration(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          addHeight(20),

                           const Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 25,
                                color: Colors.black),
                          ),
                          addHeight(5),
                           const Text(
                            "Please Sign in to Continue",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black),
                          ),
                          addHeight(20),
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
                            suffix:const Icon(Icons.mail,color: Colors.black,),
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Please enter your email '),
                              // EmailValidator(errorText: "please enter valid mail")
                            ]),
                          ),
                          addHeight(10),
                          const Text(
                            "PASSWORD",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: Colors.black),
                          ),
                          addHeight(2),
                          CommonTextFieldWidget(
                            obscureText: obscureText,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: passWordController,
                            suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: obscureText
                                    ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.black,
                                )
                                    : const Icon(Icons.visibility,
                                    color: Colors.black)),
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'Please Enter Your Password'),
                            ]),
                          ),
                          addHeight(7),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const Forgotpage());
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                 Text(
                                  "Forgot your password?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          addHeight(10),
                          isLoading == true ?  CustomLoader():
                          CommonButtonGreen(
                            title: 'LOGIN',
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                               setState(() {
                                 isLoading = true;
                               });
                                await loginMutation(userName: emailController.text,userPassword: passWordController.text);
                               setState(() {
                                 isLoading = false;

                               });
                              }
                            },
                          ),
                          addHeight(25),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have account",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Color(0xff222222)),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Get.to(()=>const SignUpScreen());
                                },
                                child: Text(
                                  "  SIGN UP",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppThemeColor.primaryColor),
                                ),
                              ),
                            ],
                          ),
                          addHeight(15),

                          // if (_isLoading)
                          //   Container(
                          //     color: Colors.black.withOpacity(0.5),
                          //     child: CustomLoader(),
                          //   ),

                         ],
                      ),
                    ),
                                  ),
                  ), )

              ],
            )

          ),
        ),
      ),
    );
  }

  loginMutation(
      {
        required String userName,
        required String userPassword,}) async {


    final MutationOptions options = MutationOptions(
      document: gql('''
      mutation login(\$input: LoginInput!) {
        login(input:\$input) {
             authToken
            user {
              id
             username
             firstName
             lastName
             email
            }
          }
          }
    '''),
      variables: {
        'input':{
          'username': userName,
          'password': userPassword
        }
      },
    );

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      log("GraphQL Exception: ${result.exception.toString()}");
      String error = 'An unknown error occurred';
      if (result.exception!.graphqlErrors.isNotEmpty) {
        error = result.exception!.graphqlErrors.first.message;

      }
      log("Logins ERROR::::: $error");
      // showAddToCartPopup(context,"${error}");
      showSnackBarView(context, "${error.toUpperCase()}", Colors.red );

    } else {
      final Map<String, dynamic>? createLogin = result.data?['login'];
      if (createLogin != null) {
        log("User Details ${createLogin['user']['id'].toString()}");
        SharedPreferences pref = await SharedPreferences.getInstance();
        var map = {
          "authToken": createLogin['authToken'],
          "id": createLogin['user']['id'].toString(),
          "username": createLogin['user']['username'].toString(),
          "email": createLogin['user']['email'].toString(),
          "firstName": createLogin['user']['firstName'].toString(),
          "lastName": createLogin['user']['lastName'].toString(),
        };
        pref.setString("auth_token", jsonEncode(map));
        log("SAVED USER INFORMATION ${pref.getString("auth_token").toString()}");

        log("User Info ${createLogin.toString()}");
        log("User Info ${createLogin['authToken'].toString()}");
        // final snackBar = CustomSnackbar.build(
        //   message: "Login successfully!",
        //   backgroundColor: AppThemeColor.primaryColor,
        //   onPressed: () {
        //   },
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Get.offAll(()=>const MinimalExample());
      } else {
        log('Login erros: Invalid response data');
      }
    }
  }
}

