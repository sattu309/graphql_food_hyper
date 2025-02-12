import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/search_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../helper/apptheme_color.dart';
import '../cart/cart_screen.dart';
import '../common_product/common_product_format.dart';
import '../home/components/search_field.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final wishListController = Get.put(WishListController());
  final cartController = Get.put(CartController());
  final searchController = Get.put(ProductSearchController());

  String calDis(String regPrice, String salePrice) {
    bool isVar = regPrice.contains(' - ');
    double disCount = 0;

    if (isVar) {
      List<String> regPrices = regPrice.split(' - ');
      List<String> salePrices = salePrice.split(' - ');
      double regPriceMin = double.parse(regPrices[0].replaceAll(RegExp(r'[^\d.]'), ''));
      double salePriceMin = double.parse(salePrices[0].replaceAll(RegExp(r'[^\d.]'), ''));
      disCount = ((regPriceMin - salePriceMin) / regPriceMin) * 100;
    } else {
      double regPriceValue = double.parse(regPrice.replaceAll(RegExp(r'[^\d.]'), ''));
      double salePriceValue = double.parse(salePrice.replaceAll(RegExp(r'[^\d.]'), ''));
      disCount = ((regPriceValue - salePriceValue) / regPriceValue) * 100;
    }

    return (disCount.toInt()).toString();
  }


  @override
  void initState() {
    super.initState();
    searchController.searchMutation(searchController.keyWordText.text,context);
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return
    Obx((){
      return  Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 1,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SearchField(),
                GestureDetector(
                  onTap: (){
                    pushScreen(context, screen:CartScreen(),withNavBar: true );

                  },
                  child: Badge(
                    badgeStyle: BadgeStyle(badgeColor: AppThemeColor.primaryColor,),
                    badgeContent:     Obx((){
                      return Text(cartController.cartCount.value,style: const TextStyle(color: Colors.white),);}),
                    child: const Icon(Icons.shopping_bag_outlined,color: Colors.grey,size: 25,),
                  ),
                )
              ],
            ),

          ),
          body:
          searchController.getSearchData.isNotEmpty && searchController.getSearchData != [] ?
          Obx((){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.only(bottom: 60),
                      itemCount: searchController.getSearchData.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                        mainAxisExtent: 270,
                      ),
                      itemBuilder: (context, index) {
                        String disPercentage = '';
                        final productsData = searchController.getSearchData[index]['node'];

                        final image = productsData['image'];
                        String imageUrl = '';
                        if (image != null && image['sourceUrl'] != null) {
                          imageUrl = image['sourceUrl'];
                        }
                        String regularPriceStr =
                            productsData['regularPrice'] ?? '0';
                        String salePriceStr = productsData['salePrice'] ?? '0';
                        if (salePriceStr != "0") {
                          disPercentage = calDis(regularPriceStr, salePriceStr);
                        }
                        return
                          CommonProductFormat(
                            onPress: () {},
                            itemName: productsData['name'],
                            stockStatus:
                            productsData['stockStatus'] == "IN_STOCK"
                                ? "INSTOCK"
                                : "OUT OF STOCK",
                            itemPrice: productsData['price'].toString(),
                            salePrice: salePriceStr,
                            regPrice: regularPriceStr,
                            itemImg: imageUrl,
                            disCountPercent: disPercentage,
                            productType: productsData['type'],
                            productID: productsData['databaseId'].toString(),
                            avrRating: productsData['averageRating'].toString(),
                            reviewCount: productsData['reviewCount'].toString(),
                          );

                      },
                    ),
                  ),
                ],
              ),
            );
          }):
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(4, 4),
                        spreadRadius: 2,
                        blurRadius: 5,
                        color: Colors.black
                            .withOpacity(0.10))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Sorry, no result found",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                    Text("Please check the product or try to search something else",textAlign:TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)
                  ],
                ),
              ),
            ),
          )

      );
    });

  }
}
