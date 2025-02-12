import 'package:get/get.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/helper/heigh_width.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import '../controllers/cart_controller.dart';
import '../controllers/main_controller.dart';
import '../controllers/session_controller.dart';
import '../controllers/wishlist_controller.dart';
import 'cart/cart_screen.dart';
import 'favorite/favorite_screen.dart';
import 'package:flutter/material.dart' hide Badge;

import 'category/categories_list.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({
    Key? key,
  }) : super(key: key);
  static var customNavigationBar = "/customNavigationBar";

  @override
  CustomNavigationBarState createState() => CustomNavigationBarState();
}

class CustomNavigationBarState extends State<CustomNavigationBar> {
  final favController = Get.put(WishListController());
  final controller = Get.put(MainHomeController());
  final sessionIdController = Get.put(SessionController());
  final cartController = Get.put(CartController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    sessionIdController.getAccessToken();
    favController.fetchWishlist();
    // cartController.fetchCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // color: Color(0xfff3f3f3),
        image: DecorationImage(
          image: AssetImage(
              "assets/images/Image Banner 2.png"
          ),
          alignment: Alignment.topCenter,
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: Obx(() {
            return BottomAppBar(
                color: Colors.white,
                shape: const CircularNotchedRectangle(),
                clipBehavior: Clip.hardEdge,
                elevation: 1,
                child: Theme(
                    data: ThemeData(
                        splashColor: Colors.transparent,
                        // backgroundColor: Colors.transparent,
                        bottomNavigationBarTheme:
                            const BottomNavigationBarThemeData(
                                backgroundColor: Colors.white, elevation: 0)),
                    child: BottomNavigationBar(
                        unselectedLabelStyle: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                        selectedLabelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppThemeColor.primaryColor),
                        items: [
                          BottomNavigationBarItem(
                            icon: GestureDetector(
                                onTap: () {
                                  controller.onItemTap(0);
                                },
                                child: const Icon(Icons.home_filled)),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: GestureDetector(
                                onTap: () {
                                  controller.onItemTap(1);
                                },
                                child: const Icon(Icons.category_outlined)),
                            label: 'Category',
                          ),
                          const BottomNavigationBarItem(
                              icon: Padding(
                                  padding: EdgeInsets.symmetric(
                                      // vertical: 08,
                                      ),
                                  child: null),
                              label: ''),
                          BottomNavigationBarItem(
                              icon: GestureDetector(
                                  onTap: () {
                                    favController.fetchWishlist();
                                    controller.onItemTap(3);
                                  },
                                  child: const Icon(Icons.favorite)),
                              label: 'Wishlist'),
                          // BottomNavigationBarItem(
                          //   icon: InkWell(
                          //       onTap: () async {
                          //         controller.onItemTap(2);
                          //         getCartData.getCartDataLocally();
                          //       },
                          //       child: const Icon(Icons.shopping_cart_outlined)
                          //   ),
                          //   label: 'Basket',
                          // ),
                          BottomNavigationBarItem(
                            icon: GestureDetector(
                                onTap: () {
                                  controller.onItemTap(4);
                                },
                                child: const Icon(Icons.account_circle_rounded)
                                // const ImageIcon(
                                //   AssetImage(AppAssets.wishlist),
                                //   size: 18,
                                // ),
                                ),
                            label: 'Profile',
                          ),
                        ],
                        type: BottomNavigationBarType.fixed,
                        currentIndex: controller.currentIndex.value,
                        selectedItemColor: AppThemeColor.primaryColor,
                        iconSize: 25,
                        onTap: controller.onItemTap,
                        elevation: 0)));
          }),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          floatingActionButton: Visibility(
            child: GestureDetector(
              onTap: () {
                cartController.getCartDataLocally();
                controller.onItemTap(2);
              },
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: AppThemeColor.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                  // border: Border.all(color: AppThemeColor.backgroundcolor, width: 1)),
                ),
                child: const Center(
                    child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                )),
              ),
            ),
          ),
          body:
          Center(
            child: Obx(() {
              return IndexedStack(
                index: controller.currentIndex.value,
                children: const [
                  HomeScreen(),
                  CategoryList(),
                  CartScreen(),
                  FavoriteScreen(),
                  ProfileScreen()
                ],
              );
            }),
          )),
    );
  }
}
