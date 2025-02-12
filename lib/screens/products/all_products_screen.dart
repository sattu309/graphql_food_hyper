import 'dart:developer';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart'hide Badge;
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/helper/common_button.dart';
import 'package:shop_app/screens/products/price_slider.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../helper/heigh_width.dart';
import '../cart/cart_screen.dart';
import '../home/components/search_field.dart';
import '../common_product/common_product_format.dart';
import 'discount_filter.dart';
import 'multiple_checkbox.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key,});

  static String routeName = "/products";

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final wishListController = Get.put(WishListController());
  final cartController = Get.put(CartController());
  final String fetchProducts =   """
query GetProducts {
  products(first: 100) {
    edges {
      node {
        image {
          sourceUrl
        }
        id
        databaseId
        name
        description
        shortDescription
        sku
        averageRating
        reviewCount
        onSale
        type
        ... on VariableProduct {
          id
          name
          price
          regularPrice
          salePrice
          sku
          stockStatus
          
        }
        ... on SimpleProduct {
          id
          name
          price
          regularPrice
          salePrice
          stockStatus
        }
        ... on SimpleProductVariation {
          id
          name
          price
          regularPrice
          salePrice
          stockStatus
        }
        ... on GroupProduct {
          id
          name
          price
          regularPrice
          salePrice
        }
        ... on ExternalProduct {
          id
          name
          price
          regularPrice
          salePrice
        }
      }
    }
  }
}
  """;



  @override
  void initState() {
    super.initState();
    wishListController.fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:   const SearchField(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    pushScreen(context, screen:CartScreen(),withNavBar: true );

                  },
                  child: Badge(
                    badgeStyle: BadgeStyle(badgeColor: AppThemeColor.primaryColor,),
                    badgeContent:     Obx((){
                      return Text(cartController.cartCount.value,style: TextStyle(color: Colors.white),);}),
                    child: Icon(Icons.shopping_bag_outlined,color: Colors.grey,size: 25,),
                  ),
                )
              ],
            ),
          )
        ],
      ),

      body: Query(
          options: QueryOptions(
            document: gql(fetchProducts),
            variables: const {
            'limit': 10,
            'offset': 0,
          },),
          builder:  (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}){
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return  Center(child: CircularProgressIndicator(
                color: AppThemeColor.primaryColor,));
            }

            final  List<dynamic>? allProducts = result.data!['products']['edges'];
              log("WP PRODUCTS $allProducts");
            if (allProducts == null || allProducts.isEmpty) {
              return const Center(child: Text('No products available'));
            }
            return
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,),
              child:
              GridView.builder(
                padding: const EdgeInsets.only(bottom: 60.0),
                itemCount: allProducts.length,
                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  mainAxisExtent: 270,

                ),
                itemBuilder: (context, index) {
                  final productsData = allProducts[index]['node'];
                  String disPercentage='';
                  final image = productsData['image'];
                  String imageUrl = '';
                  if (image != null &&  image['sourceUrl'] != null) {
                    imageUrl = image['sourceUrl'];
                  }
                  String regularPriceStr = productsData['regularPrice'] ?? '0';
                  String salePriceStr = productsData['salePrice'] ?? '0';

                  if(salePriceStr!="0"){
                    disPercentage = calDis(regularPriceStr, salePriceStr);
                  }


                  return CommonProductFormat(
                    onPress: () {},
                    itemName: productsData['name'],
                    stockStatus:
                    productsData['stockStatus'] == "IN_STOCK"
                        ? "INSTOCK"
                        : "OUT OF STOCK",
                    itemPrice: productsData['price'],
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
            );
          }),
    );
  }

  showFilters() {
    var height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  width: double.maxFinite,
                  //height: height * .6,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          addHeight(3),
                          Center(
                            child: Container(
                              height: 10,
                              width: 85,
                              decoration: BoxDecoration(
                                // color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Divider(
                                thickness: 5,
                                height: 2,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          addHeight(15),
                          const Text("Filters",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18)),
                          // addHeight(5),
                          // Divider(
                          //   thickness: 1.5,
                          //   height: 2,
                          //   color: Colors.black54,
                          // ),
                          addHeight(25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PRICE",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                addHeight(10),
                                PriceRangeSlider(),
                                addHeight(15),
                                const MultipleCheckboxScreen(
                                  title: '',
                                ),
                                addHeight(15),
                                const DiscountFilter(),
                                addHeight(20),
                                CommonButtonGreen(
                                  title: "APPLY",
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                addHeight(55),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          );
        });
  }
}
