import 'package:badges/badges.dart';
import 'package:flutter/material.dart'hide Badge;
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import '../../../controllers/cart_controller.dart';
import '../../cart/cart_screen.dart';
import 'search_field.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final cartController = Get.put(CartController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Image.asset("assets/images/food_logo.png",height: 50,width: 111,,),

              SearchField(),
              // GestureDetector(
              //   onTap: (){
              //     pushScreen(context, screen:CartScreen(),withNavBar: true );
              //   },
              //   child: Badge(
              //     badgeStyle: BadgeStyle(badgeColor: Colors.white,),
              //     badgeContent:     Obx((){
              //       return Text(cartController.cartCount.value,style: TextStyle(color: AppThemeColor.primaryColor),);}),
              //     child: Container(
              //         height: 24,
              //         width: 24,
              //         child:
              //         Icon(Icons.shopping_bag_outlined,color: Colors.white,size: 30,)
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
  }
}
