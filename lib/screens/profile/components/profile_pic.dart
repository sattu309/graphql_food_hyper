import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/helper/apptheme_color.dart';

import '../../../controllers/profile_conftoller.dart';
import '../../../helper/dimentions.dart';
import 'helper.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final controller = Get.put(ProfileController());
  @override
  void initState() {
    super.initState();
    log("USERIMG ${controller.image.value.toString()}");
  }
  @override
  Widget build(BuildContext context) {
    return
    Obx((){
      return SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [

            CircleAvatar(
              radius: 50, // Customize the size if needed
              backgroundImage: controller.image.value != null
                  ? FileImage(controller.image.value!) // If image is picked, display it
                  : AssetImage("assets/images/Profile Image.png") as ImageProvider, // Fallback image
              backgroundColor: Colors.transparent, // Optional, for styling
            ),
            // Positioned(
            //   right: -16,
            //   bottom: 0,
            //   child: SizedBox(
            //     height: 46,
            //     width: 46,
            //     child: TextButton(
            //       style: TextButton.styleFrom(
            //         foregroundColor: Colors.white, shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(50),
            //           side: const BorderSide(color: Colors.white),
            //         ),
            //         backgroundColor: const Color(0xFFF5F6F9),
            //       ),
            //       onPressed: () {
            //         showUploadWindow(context);
            //       },
            //       child:
            //       SvgPicture.asset("assets/icons/Camera Icon.svg"),
            //     ),
            //   ),
            // )
          ],
        ),
      );
    });

  }


}

class ProfilePic1 extends StatefulWidget {
  const ProfilePic1({
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePic1State createState() => _ProfilePic1State();
}

class _ProfilePic1State extends State<ProfilePic1> {
  final controller = Get.put(ProfileController());
  @override
  void initState() {
    super.initState();
    log("USERIMG ${controller.image.value.toString()}");
  }
  @override
  Widget build(BuildContext context) {
    return
    Obx((){
      return SizedBox(
        height: 115,
        width: 115,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 50, // Customize the size if needed
              backgroundImage: controller.image.value != null
                  ? FileImage(controller.image.value!)
                  : AssetImage("assets/images/Profile Image.png") as ImageProvider,
              backgroundColor: Colors.transparent, // Optional, for styling
            ),
            //   CircleAvatar(
            //     backgroundImage: NetworkImage(
            //         controller.image.value != null ?
            //         controller.image.value!.path:"")
            //   // backgroundImage: const AssetImage("assets/images/Profile Image.png") as ImageProvider,
            // ),

            Positioned(
              right: -16,
              bottom: 0,
              child: SizedBox(
                height: 46,
                width: 46,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                    backgroundColor: const Color(0xFFF5F6F9),
                  ),
                  onPressed: () {
                    showUploadWindow(context);
                  },
                  child:
                  SvgPicture.asset("assets/icons/Camera Icon.svg"),
                ),
              ),
            )
          ],
        ),
      );
    });

  }

  showUploadWindow(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AddSize.padding16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AddSize.size10),
                    Text("Choose From Which",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: AddSize.font16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          child: Text("Gallery",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppThemeColor.primaryColor,
                                  fontSize: AddSize.font14)),
                          onPressed: () {
                            NewHelper().addFilePicker().then((value) async {
                              if (value != null) {
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                pref.setString("save_img", value.path );
                                log("SAVE IMAGE PATH "+pref.getString("save_img")!);
                                controller.image.value = value;  // No need for force unwrapping (!)
                                print("This is from camera: ${controller.image.value!.path}");  // Use null check (!)
                              } else {
                                // Handle case where no image is selected
                                print("No image selected");
                              }
                            });
                            Get.back();
                          },
                        ),
                        TextButton(
                          child: Text("Camera",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppThemeColor.primaryColor,
                                  fontSize: AddSize.font14)),
                          onPressed: () {
                            NewHelper()
                                .addImagePicker(imageSource: ImageSource.camera)
                                .then((value) async {
                              if (value != null) {
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                pref.setString("save_img", value.path );
                                log("SAVE IMAGE PATH ${pref.getString("save_img")!}");
                                controller.image.value = value;  // No need for force unwrapping (!)
                                print("This is from camera: ${controller.image.value!.path}");  // Use null check (!)
                              } else {
                                print("No image selected");
                              }
                            });
                            Get.back();
                          },

                        ),
                      ],
                    ),
                    SizedBox(
                      height: AddSize.size20,
                    ),
                  ],
                )),
          ),

        );
      },
    );
  }

}
