import 'dart:developer';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/helper/common_button.dart';
import 'package:shop_app/screens/products/price_slider.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/search_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../helper/heigh_width.dart';
import '../cart/cart_screen.dart';
import '../home/components/search_field.dart';
import '../common_product/common_product_format.dart';
import '../products/discount_filter.dart';
import '../products/multiple_checkbox.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
  });
  final String categoryId;

  static String routeName = "/products";

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final wishListController = Get.put(WishListController());
  final cartController = Get.put(CartController());
  final searchController = Get.put(ProductSearchController());
  bool isFavourite = false;
  String imgLInk = "https://shopdemo.bitlogiq.co.za/products/";
  late String fetchProducts;

  @override
  void initState() {
    super.initState();
    log(widget.categoryId);
    fetchProducts = """
    query ProductCategories {
    productCategory(id: "${widget.categoryId}", idType: DATABASE_ID) {
        children {
            edges {
                node {
                    name
                    slug
                    productCategoryId
                    image {
                        sourceUrl
                    }
                    children {
                        edges {
                            node {
                                name
                                slug
                                productCategoryId
                                image {
                                    sourceUrl
                                }
                            }
                        }
                    }
                }
            }
        }
        products {
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
                    reviewCount
                    type
                    ... on VariableProduct {
                        id
                        name
                        price
                        regularPrice
                        salePrice
                        averageRating
                        reviewCount
                        sku
                        stockStatus
                    }
                    ... on SimpleProduct {
                        id
                        name
                        price
                        regularPrice
                        salePrice
                        averageRating
                        reviewCount
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
}

  """;
  }

  String calDis(String regPrice, String salePrice) {
    bool isVar = regPrice.contains(' - ');
    double disCount = 0;

    if (isVar) {
      List<String> regPrices = regPrice.split(' - ');
      List<String> salePrices = salePrice.split(' - ');
      double regPriceMin =
          double.parse(regPrices[0].replaceAll(RegExp(r'[^\d.]'), ''));
      double salePriceMin =
          double.parse(salePrices[0].replaceAll(RegExp(r'[^\d.]'), ''));
      disCount = ((regPriceMin - salePriceMin) / regPriceMin) * 100;
    } else {
      double regPriceValue =
          double.parse(regPrice.replaceAll(RegExp(r'[^\d.]'), ''));
      double salePriceValue =
          double.parse(salePrice.replaceAll(RegExp(r'[^\d.]'), ''));

      disCount = ((regPriceValue - salePriceValue) / regPriceValue) * 100;
    }

    return (disCount.toInt()).toString();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // elevation: 1,
          leadingWidth: 20,
          title: const SearchField(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      pushScreen(context,
                          screen: CartScreen(), withNavBar: true);
                    },
                    child: Badge(
                      badgeStyle: BadgeStyle(
                        badgeColor: AppThemeColor.primaryColor,
                      ),
                      badgeContent: Obx(() {
                        return Text(
                          cartController.cartCount.value,
                          style: TextStyle(color: Colors.white),
                        );
                      }),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        body: Query(
            options: QueryOptions(document: gql(fetchProducts)),
            builder: (QueryResult result,
                {Refetch? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return Center(
                    child: CircularProgressIndicator(
                  color: AppThemeColor.primaryColor,
                ));
              }

              final productCategory = result.data?['productCategory'];
              if (productCategory == null) {
                return const Center(child: Text('No data available'));
              }

              final List<dynamic>? allProducts =
                  productCategory['products']['edges'];
              log("CATEGORY PRODUCTS ${allProducts}");
              if (allProducts == null || allProducts.isEmpty) {
                return const Center(child: Text('No products available'));
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 8),
                        itemCount: allProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 0,
                          mainAxisExtent: 290,
                        ),
                        itemBuilder: (context, index) {
                          String disPercentage = '';
                          final productsData = allProducts[index]['node'];

                          final image = productsData['image'];
                          String imageUrl = '';
                          if (image != null && image['sourceUrl'] != null) {
                            imageUrl = image['sourceUrl'];
                          }
                          String regularPriceStr =
                              productsData['regularPrice'] ?? '0';
                          String salePriceStr =
                              productsData['salePrice'] ?? '0';
                          if (salePriceStr != "0") {
                            disPercentage =
                                calDis(regularPriceStr, salePriceStr);
                          }
                          return
                            CommonProductFormat(
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
                          // GestureDetector(
                          //   onTap: (){
                          //     log("PRODUCT ID of category product ${productsData['databaseId'].toString()}");
                          //     // Get.to(()=> DetailsScreen(productId: productsData['id'],));
                          //     pushScreen(context,
                          //         screen:  DetailsScreen(productId: productsData['databaseId'].toString(),  productStatus: productsData['stockStatus'],),
                          //
                          //         withNavBar: true);
                          //   },
                          //   child:
                          //   Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       addHeight(10),
                          //       Stack(
                          //         children: [
                          //           Container(
                          //             height: 275,
                          //               padding: const EdgeInsets.symmetric(horizontal: 10,),
                          //               margin: const EdgeInsets.symmetric(horizontal: 6,),
                          //               decoration: BoxDecoration(
                          //                 color: Colors.white,
                          //                 borderRadius: BorderRadius.circular(7),
                          //                 border: Border.all(color: Colors.black12),
                          //                 boxShadow: [
                          //                   BoxShadow(
                          //                       offset: const Offset(4, 4),
                          //                       spreadRadius: 2,
                          //                       blurRadius: 5,
                          //                       color: Colors.black.withOpacity(0.10)
                          //                   )
                          //                 ],
                          //               ),
                          //               child:
                          //               Column(
                          //                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                 children: [
                          //                   ClipRRect(
                          //                     borderRadius: BorderRadius.circular(7),
                          //                     child: CachedNetworkImage(
                          //                       imageUrl: imageUrl,
                          //                       height: height *.20,
                          //                       width: width *.45,
                          //                       fit: BoxFit.contain,
                          //                       errorWidget: (_, __, ___) => Image.asset(
                          //                         "assets/images/Image Popular Product 2.png",
                          //                         fit: BoxFit.cover,
                          //                         height: 50,
                          //                         width: 50,
                          //                       ),
                          //                       placeholder: (_, __) =>  Container(
                          //                         color: Colors.grey.shade200,
                          //                       ),
                          //
                          //                     ),
                          //                   ),
                          //                   // const SizedBox(height: 3),
                          //                   Text(
                          //                       productsData['name'],
                          //                       maxLines: 1,
                          //                       style: const TextStyle(
                          //                           fontWeight: FontWeight.w500,color: CupertinoColors.black,fontSize: 14)
                          //                   ),
                          //                   addHeight(3),
                          //                   Text(
                          //                       productsData['stockStatus'] == "IN_STOCK" ? "INSTOCK" : "OUT OF STOCK",
                          //                       maxLines: 1,
                          //                       style:  TextStyle(
                          //                           fontWeight: FontWeight.w500,
                          //                           color: productsData['stockStatus'] == "IN_STOCK" ? Colors.green:Colors.red,fontSize: 10)
                          //                   ),
                          //                   addHeight(3),
                          //                     productsData['averageRating']!=null ?
                          //                     Row(
                          //
                          //                         children: [
                          //                           ...List.generate(productsData['averageRating'], (index){
                          //                             return  SingleChildScrollView(
                          //                               scrollDirection: Axis.vertical,
                          //                               child: Row(
                          //                                 children: [
                          //                                   Icon(Icons.star,color: Colors.yellow.shade600,size: 17,),
                          //                                 ],
                          //                               ),
                          //                             );
                          //                           }),
                          //                           addWidth(3),
                          //                           Text(
                          //                             "${productsData['reviewCount']}",
                          //                             style: const TextStyle(
                          //                               fontSize: 16,
                          //                               fontFamily: "IBM Plex Sans",
                          //                               fontWeight: FontWeight.w700,
                          //                               color: Colors.black38,
                          //                             ),
                          //                           ),
                          //                         ]
                          //                     ):addHeight(16),
                          //                   addHeight(2),
                          //                   (salePriceStr!="0") ?
                          //                   Column(
                          //                     crossAxisAlignment: CrossAxisAlignment.start,
                          //                     children: [
                          //                       // addWidth(8),
                          //                       Row(
                          //                         children: [
                          //                           Flexible(
                          //                             child: Text(
                          //                               regularPriceStr,
                          //                               style: TextStyle(
                          //                                 fontSize: 12,
                          //                                 fontFamily: "IBM Plex Sans",
                          //                                 fontWeight: FontWeight.w700,
                          //                                 decoration:
                          //                                 TextDecoration.lineThrough,
                          //                                 decorationStyle: TextDecorationStyle.solid,
                          //                                 color: Colors.grey.shade400,
                          //                               ),
                          //                             ),
                          //                           ),
                          //                           addWidth(5),
                          //                           Flexible(
                          //                             child: Text(
                          //                               salePriceStr,
                          //                               style: TextStyle(
                          //                                 fontSize: 14,
                          //                                 fontFamily: "IBM Plex Sans",
                          //                                 fontWeight: FontWeight.w700,
                          //                                 color: AppThemeColor.primaryColor,
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ],
                          //                   ):Text(
                          //                     productsData['price'],
                          //                     style: TextStyle(
                          //                       fontSize: 14,
                          //                       fontFamily: "IBM Plex Sans",
                          //                       fontWeight: FontWeight.w700,
                          //                       color: AppThemeColor.primaryColor,
                          //                     ),
                          //                   ),
                          //                   addHeight(5),
                          //                   productsData['type'] =="SIMPLE" ?
                          //                   Container(
                          //                     height: 25,
                          //                     alignment: Alignment.centerRight,
                          //                     width: width * .5,
                          //                     child: ElevatedButton(
                          //                       style: ElevatedButton.styleFrom(
                          //
                          //                         shape: RoundedRectangleBorder(),
                          //                           backgroundColor: AppThemeColor.primaryColor,
                          //                         ),
                          //                       onPressed: () async {
                          //                         wishListController.addToCart(
                          //                             productsData['databaseId'],
                          //                           0,
                          //                           1,
                          //                           context);
                          //
                          //                         cartController.getCartDataLocally();
                          //                       },
                          //                       child: const Text("ADD TO CART",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
                          //                     ),
                          //                   ):
                          //                   Container(
                          //                     height: 25,
                          //                     alignment: Alignment.centerRight,
                          //                     width: width * .5,
                          //                     child: ElevatedButton(
                          //                       style: ElevatedButton.styleFrom(
                          //
                          //                         shape: RoundedRectangleBorder(),
                          //                           backgroundColor: AppThemeColor.primaryColor,
                          //                         ),
                          //                       onPressed: () async {
                          //                         pushScreen(context,
                          //                             screen:  DetailsScreen(productId: productsData['databaseId'].toString(),  productStatus: productsData['stockStatus'],), withNavBar: true);
                          //                       },
                          //                       child: const Text("VIEW OPTION",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               )
                          //             //
                          //             // Image.asset("assets/images/glap.png",),
                          //           ),
                          //           (disPercentage!='') ?
                          //           Positioned(
                          //               top: height*0.015,
                          //               left: 10,
                          //               child: Container(
                          //                 padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                          //                 decoration: BoxDecoration(
                          //                     borderRadius: BorderRadius.circular(4),
                          //                     color: AppThemeColor.primaryColor
                          //                 ),
                          //                 child: Text(
                          //                     disPercentage+ '%',
                          //                     maxLines: 1,
                          //                     style: const TextStyle(
                          //                         fontWeight: FontWeight.w500,color: CupertinoColors.white,fontSize: 12)
                          //                 ),)) :SizedBox()
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
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
