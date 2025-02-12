import "package:badges/badges.dart";
import "package:client_information/client_information.dart";
import "package:flutter/material.dart"hide Badge;
import "package:flutter/services.dart";
import "package:get/get.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";
import "package:shop_app/helper/apptheme_color.dart";
import "package:shop_app/screens/profile/profile_screen.dart";
import "../controllers/cart_controller.dart";
import "../controllers/main_controller.dart";
import "../controllers/order_controller.dart";
import "../controllers/session_controller.dart";
import "cart/cart_screen.dart";
import "category/categories_list.dart";
import "home/static_home.dart";

class MinimalExample extends StatefulWidget {
  const MinimalExample({super.key});

  @override
  State<MinimalExample> createState() => _MinimalExampleState();
}

class _MinimalExampleState extends State<MinimalExample> {
  final checkOutController = Get.put(OrderController());
  final controller = Get.put(MainHomeController());
  final sessionIdController = Get.put(SessionController());
  final cartController = Get.put(CartController());
  final PersistentTabController persistentTabController = PersistentTabController(initialIndex: 0);
  List<PersistentTabConfig> tabs() => [
        PersistentTabConfig(
          // screen: const Emptypage(),
          screen: const DemoPage(),
          item: ItemConfig(
            icon: const Icon(Icons.home_filled),
            title: "Home",
              activeForegroundColor: AppThemeColor.primaryColor,
          ),
        ),
        PersistentTabConfig(
          screen: const CategoryList(),
          item: ItemConfig(
            icon: const Icon(Icons.category_outlined),
            title: "Category",
            activeForegroundColor: AppThemeColor.primaryColor
          ),
        ),
        PersistentTabConfig(
      screen: const CartScreen(),
      item: ItemConfig(
          icon:
          Badge(
            badgeStyle: BadgeStyle(badgeColor: AppThemeColor.primaryColor),
            badgeContent:
                Obx((){
                  return Text(cartController.cartCount.value,style: TextStyle(color: Colors.white),);}),

              child: const Icon(Icons.shopping_cart_outlined)),
          title: "Cart",
          activeForegroundColor: AppThemeColor.primaryColor
      ),
    ),
        PersistentTabConfig(
          screen: const ProfileScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.person),
            title: "MyProfile",
              activeForegroundColor: AppThemeColor.primaryColor
          ),
        ),
      ];

@override
  void initState() {
    super.initState();
    sessionIdController.getAccessToken();
    checkOutController.getCheckoutData();
    cartController.fetchCartData();
  }
  @override
  Widget build(BuildContext context){
    return
      Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
      body:
      PersistentTabView(
        controller: persistentTabController,
          tabs: tabs(),
          onTabChanged: (index) {
            controller.currentIndex.value = index;
            print("INDEX: ${controller.currentIndex.value}");
          },
          // onTabChanged: (index) {
          //   switch (index) {
          //     case 0:
          //       persistentTabController.jumpToTab(index);
          //       // Navigator.popUntil(context, (route) => route.isFirst);
          //       // controller.onItemTap(0);
          //       break;
          //     case 1:
          //       Navigator.of(context).popUntil((route) => route.isFirst);
          //       break;
          //     case 2:
          //       cartController.fetchCartData();
          //       cartController.getCartDataLocally();
          //       Navigator.of(context).popUntil((route) => route.isFirst);
          //       break;
          //     case 3:
          //       Navigator.of(context).popUntil((route) => route.isFirst);
          //       break;
          //   }
          // },
          navBarBuilder: (navBarConfig) => Style1BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(

              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  // spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),

            ),
          )),

          );

  }

}




