import 'dart:convert';
import 'dart:developer';
import 'package:client_information/client_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_token_model.dart';

class SessionController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastController = TextEditingController();
  RxString sessionId = ''.obs;
  RxString userId = ''.obs;
  RxString randomSession = ''.obs;

  Future<void> getAccessToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    LoginTokenModel? user = LoginTokenModel.fromJson(jsonDecode(pref.getString('auth_token')!));
    log("USER INFOOO ${pref.getString('auth_token')!}");
    sessionId.value = user.authToken.toString();
    userId.value = user.id.toString();
    emailController.text = user.email.toString();
    nameController.text = user.firstName.toString();
    lastController.text = user.lastName.toString();
    print("GET SESSION ID: $sessionId");
    print("GET USER ID: $userId");
    print("GET USER ID: ${emailController.text}");
    print("GET USER ID: ${nameController.text}");
    print("GET USER ID: ${lastController.text}");

  }
  ClientInformation? _clientInfo;
  Future<void> getClientInformation() async {
    ClientInformation? info;
    try {
      info = await ClientInformation.fetch();
    } on PlatformException {}

    _clientInfo = info!;
    print('deviceId controller  ${_clientInfo!.deviceId.toString()}');
  }

@override
  void onInit() {
    super.onInit();
    getAccessToken();
    getClientInformation();
  }
}

