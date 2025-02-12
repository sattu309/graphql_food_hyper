
import 'dart:developer';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  // var image = Rx<File?>(null);

  // Rx<File> image = File("").obs;
  var image = Rx<File?>(null); // Nullable Rx<File?>

  void loadImageFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImagePath = prefs.getString("save_img");

    if (savedImagePath != null && savedImagePath.isNotEmpty) {
      File file = File(savedImagePath);

      if (await file.exists()) {
        image.value = file;
      } else {
        log("File does not exist at path: $savedImagePath");
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadImageFromLocalStorage();
  }
}
