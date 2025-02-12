import 'dart:convert';
import 'dart:developer';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/rounded_icon_btn.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/session_controller.dart';
import '../../helper/apptheme_color.dart';
import '../../helper/custom_snackbar.dart';
import '../../helper/heigh_width.dart';
import '../login_flow/login_page.dart';
import '../product_details/details_screen.dart';
import 'checkout_page.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({
    super.key,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final sessionIdController = Get.put(SessionController());
  final cartController = Get.put(CartController());
  late GraphQLClient client;
  GraphQLClient initializeClient() {
    log("JWT TOKEN...${sessionIdController.sessionId.value}");
    final HttpLink httpLink = HttpLink(
      'https://ecom.bitlogiq.co.za/graphql',
      defaultHeaders: {
        'Authorization': 'Bearer ${sessionIdController.sessionId.value}',
      },
    );

    return client = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: httpLink,
    );
  }

  String allQty = "";

  Future<void> deleteCartMutation(String cartKey) async {
     final GraphQLClient client = initializeClient();
    final MutationOptions options = MutationOptions(
      document: gql('''
    mutation RemoveItemsFromCart(\$input: RemoveItemsFromCartInput!) {
      removeItemsFromCart(input:\$input) {
        clientMutationId
          cart {
                subtotal
                total
                shippingTotal
                contents {
                    itemCount
                    nodes {
                        product {
                            node {
                                name
                                sku
                                databaseId
                                productId
                                image{
                                    sourceUrl
                                }
                                ... on VariableProduct {
                                    databaseId
                                    name
                                    price
                                    type
                                    regularPrice
                                    salePrice
                                }
                                ... on SimpleProduct {
                                    databaseId
                                    name
                                    price
                                    type
                                    regularPrice
                                    salePrice
                                }
                                }
                                }
                                key
                                quantity
                                subtotal
                                subtotalTax
                                total
                                tax
                                variation {
                                node {
                                databaseId
                                name
                                price
                                regularPrice
                                salePrice
                                attributes{
                                    edges{
                                        node{
                                            value
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
      }
    }
  '''),
      variables: {
        "input": {
          'keys': cartKey,
        }
      },
    );

    // final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      final error = result.exception!.graphqlErrors.first.message;
      print("DELETE CART ERROR::::: $error");
      final snackBar = CustomSnackbar.build(
        message: error,
        backgroundColor: AppThemeColor.primaryColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? cart =
          result.data?['removeItemsFromCart']['cart'];
      if (cart != null) {
        SharedPreferences cartLocalData = await SharedPreferences.getInstance();
        cartLocalData.setString('cart_data', jsonEncode(cart));
        var rawCartData = cart['contents']['nodes'];
        cartController.cartData.value = rawCartData;
        cartController.totalAmt.value = cart['total'];
        cartController.cartCount.value =
            cart['contents']['itemCount'].toString();
      } else {
        print('Delete cart error: Invalid response data');
      }
    }
  }

  Future<void> updateCartMutation(String cartKey, String qty) async {
   final GraphQLClient client = initializeClient();
    SharedPreferences cartLocalData = await SharedPreferences.getInstance();
    log("BEFORE${cartLocalData.getString('cart_data')}");
    await cartLocalData.remove('cart_data');
    log("AFTER ${cartLocalData.getString('cart_data')}");
    final MutationOptions options = MutationOptions(
      document: gql('''
  mutation UpdateItemQuantities(\$input: UpdateItemQuantitiesInput!) {
    updateItemQuantities(input: \$input) {
            cart {
                subtotal
                total
                shippingTotal
                contents {
                    itemCount
                    nodes {
                        product {
                            node {
                                name
                                sku
                                databaseId
                                productId
                                image{
                                    sourceUrl
                                }
                                ... on VariableProduct {
                                    databaseId
                                    name
                                    price
                                    type
                                    regularPrice
                                    salePrice
                                }
                                ... on SimpleProduct {
                                    databaseId
                                    name
                                    price
                                    type
                                    regularPrice
                                    salePrice
                                }
                                }
                                }
                                key
                                quantity
                                subtotal
                                subtotalTax
                                total
                                tax
                                variation {
                                node {
                                databaseId
                                name
                                price
                                regularPrice
                                salePrice
                                attributes{
                                    edges{
                                        node{
                                            value
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
      }
    }
  '''),
      variables: {
        "input": {
          "items": [
            {
              'key': cartKey,
              'quantity': int.parse(qty),
            }
          ]
        }
      },
    );

    // final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      final error = result.exception!.graphqlErrors.first.message;
      print("UPDATE CART ERROR::::: $error");
      final snackBar = CustomSnackbar.build(
        message: error,
        backgroundColor: AppThemeColor.primaryColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    log("REUSLT${result}");
    final Map<String, dynamic>? cart =
        result.data?['updateItemQuantities']['cart'];
    if (cart != null) {
      SharedPreferences cartLocalData = await SharedPreferences.getInstance();
      cartLocalData.setString('cart_data', jsonEncode(cart));

      var rawCartData = cart['contents']['nodes'];
      cartController.cartData.value = rawCartData;
      cartController.totalAmt.value = cart['total'];
      cartController.cartCount.value = cart['contents']['itemCount'].toString();
    } else {
      print('Delete cart error: Invalid response data');
    }
  }

  final fetchCartData = """
  query Cart {
    cart {
        subtotal
        total
        shippingTotal
        contents {
            itemCount
            nodes {
                product {
                    node {
                        name
                        sku
                        databaseId
                        productId
                        image{
                            sourceUrl
                        }
                            ... on VariableProduct {
                                databaseId
                                name
                                price
                                type
                                regularPrice
                                    salePrice
                            }
                            ... on SimpleProduct {
                                databaseId
                                name
                                price
                                type
                                regularPrice
                                    salePrice
                            }
                    }
                }
                key
                quantity
                subtotal
                subtotalTax
                total
                tax
                variation {
                    node {
                        databaseId
                        name
                        price
                        regularPrice
                        salePrice
                               attributes{
                                edges{
                                    node{
                                         value
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
}

   """;

  @override
  void initState() {
    super.initState();
    cartController.fetchCartData();
    cartController.getCartDataLocally();
    log("Access Token ${sessionIdController.sessionId.value.toString()}");
    initializeClient();
  }

  int selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return
    Obx((){
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            leadingWidth: 20,
            title: Text(
              "MY BASKET ",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Badge(
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
                    )
                  ],
                ),
              )
            ],
          ),
          body: Query(
              options: QueryOptions(document: gql(fetchCartData)),
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
                return
                  Obx(() {
                  return Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: cartController.cartData.isNotEmpty &&
                          cartController.cartData != []
                          ? Obx(() {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: cartController.cartData.length,
                                  itemBuilder: (context, index) {
                                    final productData = cartController
                                        .cartData[index]['product']['node'];

                                    final img =
                                    productData['image']['sourceUrl'];
                                    // final vPrice = cartData[index]['variation']?['nodes']?['attributes']?['edges']['node']['value'];
                                    final quantity = cartController
                                        .cartData[index]['quantity'];
                                    final key = cartController
                                        .cartData[index]['key'];
                                    final variation =
                                    cartController.cartData[index]
                                    ['variation']?['node'];
                                    final vPrice =
                                        variation?['price'] ?? '';
                                    final attributes =
                                    variation?['attributes']?['edges'];
                                    String regularPriceStr = productData['regularPrice'] ?? '0';
                                    String salePriceStr = productData['salePrice'] ?? '0';


                                    return
                                      Column(
                                      children: [
                                        Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                log("PRODUCT ID of category product ${productData['databaseId'].toString()}");
                                                // Get.to(()=> DetailsScreen(productId: productsData['id'],));

                                                pushScreen(context,
                                                    screen:  DetailsScreen(productId: productData['databaseId'].toString(), productStatus: "",), withNavBar: true);
                                                Get.back();
                                                Get.back();
                                                },
                                              child: Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 10,
                                                    vertical: 2),
                                                margin: const EdgeInsets
                                                    .symmetric(
                                                  vertical: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset: const Offset(
                                                            4, 4),
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        color: Colors.black
                                                            .withOpacity(
                                                            0.10))
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .center,
                                                  children: [
                                                    SizedBox(
                                                      width: 88,
                                                      child: AspectRatio(
                                                        aspectRatio: 0.80,
                                                        child: Container(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(8),
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                15),
                                                          ),
                                                          child:
                                                          CachedNetworkImage(
                                                            imageUrl: img,
                                                            height: 65,
                                                            width: 65,
                                                            errorWidget: (_,
                                                                __,
                                                                ___) =>
                                                                Image.asset(
                                                                  "assets/images/Image Banner 3.png",
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  productData[
                                                                  'name'],
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                      14),
                                                                ),
                                                              ),
                                                              RoundedIconBtn(
                                                                icon: Icons
                                                                    .remove,
                                                                press: () {
                                                                  // log("CART IDDDDD ${key,}");
                                                                  if (quantity ==
                                                                      1) {
                                                                    deleteCartMutation(
                                                                        key);
                                                                  } else {
                                                                    updateCartMutation(
                                                                      key,
                                                                      ((int.parse(quantity.toString()) ?? 0) -
                                                                          1)
                                                                          .toString(),
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              Text(
                                                                  quantity
                                                                      .toString(),
                                                                  style: Theme.of(
                                                                      context)
                                                                      .textTheme
                                                                      .bodyMedium),
                                                              const SizedBox(
                                                                  width: 10),
                                                              RoundedIconBtn(
                                                                icon:
                                                                Icons.add,
                                                                showShadow:
                                                                true,
                                                                press:
                                                                    () async {
                                                                  // SharedPreferences cartLocalData = await SharedPreferences.getInstance();
                                                                  // int.parse((myCartController.model.value.data!.cartItems![index].cartItemQty ?? "").toString()) + 1,

                                                                  updateCartMutation(
                                                                    key,
                                                                    ((int.parse(quantity.toString()) ?? 0) +
                                                                        1)
                                                                        .toString(),
                                                                  );
                                                                },
                                                              )
                                                              // addWidth(20),
                                                              // GestureDetector(
                                                              //     onTap: () async {
                                                              //       log("KEY FOR DELETE CART DATA ${key}");
                                                              //       deleteCartMutation(key);
                                                              //       setState(() {});
                                                              //     },
                                                              //     child: Icon(
                                                              //       Icons.clear,
                                                              //       color: AppThemeColor
                                                              //           .primaryColor,
                                                              //     ))
                                                            ],
                                                          ),
                                                          // const SizedBox(height: 10),
                                                          // Row(
                                                          //   crossAxisAlignment:
                                                          //   CrossAxisAlignment.start,
                                                          //   children: [
                                                          //     if (productData['type'] ==
                                                          //         "VARIABLE" &&
                                                          //         attributes != null)
                                                          //       ...attributes.map<Widget>(
                                                          //               (attrEdge) {
                                                          //             final attrNode =
                                                          //             attrEdge['node'];
                                                          //             final value =
                                                          //             attrNode['value'];
                                                          //             return Container(
                                                          //               padding:
                                                          //               const EdgeInsets
                                                          //                   .symmetric(
                                                          //                   vertical: 2,
                                                          //                   horizontal: 5),
                                                          //               margin: const EdgeInsets
                                                          //                   .only(right: 5),
                                                          //               decoration:
                                                          //               const BoxDecoration(
                                                          //                   color: Colors
                                                          //                       .black12),
                                                          //               child: Text(
                                                          //                 value,
                                                          //                 style:
                                                          //                 const TextStyle(
                                                          //                     color: Colors
                                                          //                         .black,
                                                          //                     fontSize: 14),
                                                          //               ),
                                                          //             );
                                                          //           }).toList(),
                                                          //     addWidth(10),
                                                          //     Container(
                                                          //       padding: const EdgeInsets
                                                          //           .symmetric(
                                                          //           vertical: 2,
                                                          //           horizontal: 5),
                                                          //       decoration:
                                                          //       const BoxDecoration(
                                                          //           color:
                                                          //           Colors.black12),
                                                          //       child: Text(
                                                          //         "Qty $quantity",
                                                          //         style: const TextStyle(
                                                          //             color: Colors.black,
                                                          //             fontSize: 14),
                                                          //       ),
                                                          //     ),
                                                          //   ],
                                                          // ),
                                                          // const SizedBox(height: 15),
                                                          // Row(
                                                          //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          //   children: [
                                                          // productData['type'] ==
                                                          //         "VARIABLE"
                                                          //     ? Column(
                                                          //         crossAxisAlignment:
                                                          //             CrossAxisAlignment
                                                          //                 .start,
                                                          //         children: [
                                                          //           // addWidth(8),
                                                          //           (salePriceStr !=
                                                          //                   "0")
                                                          //               ? Row(
                                                          //                   children: [
                                                          //                     Text(
                                                          //                       regularPriceStr,
                                                          //                       style: TextStyle(
                                                          //                         fontSize: 13,
                                                          //                         fontFamily: "IBM Plex Sans",
                                                          //                         fontWeight: FontWeight.w700,
                                                          //                         decoration: TextDecoration.lineThrough,
                                                          //                         decorationStyle: TextDecorationStyle.solid,
                                                          //                         color: Colors.grey.shade400,
                                                          //                       ),
                                                          //                     ),
                                                          //                     addWidth(5),
                                                          //                     Expanded(
                                                          //                       child: Text(
                                                          //                         salePriceStr,
                                                          //                         style: TextStyle(
                                                          //                           fontSize: 15,
                                                          //                           fontFamily: "IBM Plex Sans",
                                                          //                           fontWeight: FontWeight.w700,
                                                          //                           color: AppThemeColor.primaryColor,
                                                          //                         ),
                                                          //                       ),
                                                          //                     ),
                                                          //                   ],
                                                          //                 )
                                                          //               : Text(
                                                          //                   vPrice,
                                                          //                   style: TextStyle(
                                                          //                     fontSize: 18,
                                                          //                     fontFamily: "IBM Plex Sans",
                                                          //                     fontWeight: FontWeight.w700,
                                                          //                     color: AppThemeColor.primaryColor,
                                                          //                   ),
                                                          //                 ),
                                                          //         ],
                                                          //       ):SizedBox(),
                                                          addHeight(5),
                                                          (salePriceStr!="0") ?
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              // addWidth(8),
                                                              Row(
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      regularPriceStr,
                                                                      style: TextStyle(
                                                                        fontSize: 12,
                                                                        fontFamily: "IBM Plex Sans",
                                                                        fontWeight: FontWeight.w700,
                                                                        decoration:
                                                                        TextDecoration.lineThrough,
                                                                        decorationStyle: TextDecorationStyle.solid,
                                                                        color: Colors.grey.shade400,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  addWidth(5),
                                                                  Flexible(
                                                                    child: Text(
                                                                      salePriceStr,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontFamily: "IBM Plex Sans",
                                                                        fontWeight: FontWeight.w700,
                                                                        color: AppThemeColor.primaryColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ):Text(
                                                            productData['price'],
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily: "IBM Plex Sans",
                                                              fontWeight: FontWeight.w700,
                                                              color: AppThemeColor.primaryColor,
                                                            ),
                                                          ),

                                                          // Text.rich(
                                                          //   TextSpan(
                                                          //     text: productData[
                                                          //     'type'] ==
                                                          //         "SIMPLE"
                                                          //         ? "${productData['price']}"
                                                          //         : vPrice,
                                                          //     style: TextStyle(
                                                          //         fontSize: 15,
                                                          //         fontWeight:
                                                          //         FontWeight.w600,
                                                          //         color: Colors.black
                                                          //             .withOpacity(
                                                          //             .70)),
                                                          //   ),
                                                          // ),
                                                          //     const Spacer(),
                                                          //     // addWidth(20),
                                                          //
                                                          //     RoundedIconBtn(
                                                          //       icon: Icons.remove,
                                                          //       press: () {
                                                          //         // log("CART IDDDDD ${key,}");
                                                          //         if (quantity== 1) {
                                                          //           deleteCartMutation(
                                                          //               key);
                                                          //
                                                          //         } else {
                                                          //           updateCartMutation(
                                                          //             key, ((int.parse(quantity.toString()) ?? 0) - 1).toString(),);
                                                          //
                                                          //         }
                                                          //       },
                                                          //     ),
                                                          //     const SizedBox(width: 15),
                                                          //     Text(quantity.toString(),
                                                          //         style: Theme.of(context)
                                                          //             .textTheme
                                                          //             .bodyMedium),
                                                          //     const SizedBox(width: 15),
                                                          //     RoundedIconBtn(
                                                          //       icon: Icons.add,
                                                          //       showShadow: true,
                                                          //       press: () async {
                                                          //         // SharedPreferences cartLocalData = await SharedPreferences.getInstance();
                                                          //         // int.parse((myCartController.model.value.data!.cartItems![index].cartItemQty ?? "").toString()) + 1,
                                                          //
                                                          //         updateCartMutation(
                                                          //           key, ((int.parse(quantity.toString()) ?? 0) + 1).toString(),);
                                                          //
                                                          //       },
                                                          //     )
                                                          //   ],
                                                          // )
                                                        ],
                                                      ),
                                                    ),
                                                    addHeight(7)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                                top: 47,
                                                left: 14,
                                                child: GestureDetector(
                                                    onTap: () async {
                                                      log("KEY FOR DELETE CART DATA ${key}");
                                                      deleteCartMutation(
                                                          key);
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      padding:
                                                      EdgeInsets.all(5),
                                                      decoration:
                                                      BoxDecoration(
                                                          color: Colors
                                                              .red,
                                                          shape: BoxShape
                                                              .circle),
                                                      child: Icon(
                                                        Icons.clear,
                                                        color: Colors.white,
                                                        size: 15,
                                                      ),
                                                    )))
                                          ],
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                            addHeight(7),
                           
                          ],
                        );
                      })
                          : Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            SizedBox(height: height*.20,),
                            Lottie.asset('assets/images/emptyCart.json'),
                            // Image.asset("assets/images/cart_empty.png"),
                            // Text(
                            //   "YOUR CART IS CURRENTLY EMPTY",
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.w700,
                            //       fontSize: 16,
                            //       color: AppThemeColor.primaryColor),
                            // ),
                          ],
                        ),
                      ));
                });
              }),
          bottomNavigationBar: cartController.cartData.isNotEmpty &&
              cartController.cartData != []
              ? Obx(() {
            return Padding(
              padding:
              const EdgeInsets.only(bottom: 60, left: 15, right: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                // height: 174,
                decoration: BoxDecoration(
                  border: const Border(
                      top: BorderSide(
                        color: Colors.black12,
                      )),
                  color: Colors.white,
                  // borderRadius: const BorderRadius.only(
                  //   topLeft: Radius.circular(30),
                  //   topRight: Radius.circular(30),
                  // ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, -15),
                      blurRadius: 20,
                      color: const Color(0xFFDADADA).withOpacity(0.15),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: "Total:\n",
                              children: [
                                TextSpan(
                                  text: cartController.totalAmt.value,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                TextSpan(
                                  text: allQty.toString(),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppThemeColor.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12))),
                            onPressed: () async {
                              SharedPreferences pref =
                              await SharedPreferences.getInstance();
                              if (pref.getString("auth_token") != null) {
                                // Get.offAll(()=>const InitScreen());
                                Get.to(() => const CheckoutPage());
                              } else {
                                Get.offAll(() => const LoginPage());
                              }
                            },
                            child: const Text("Check Out"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          })
              : SizedBox());
    });

  }

  showListOfCoupons() {
    var height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
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
                  // height: double.maxFinite,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        addHeight(40),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Your promo code",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Color(0xff222222)),
                            ),
                          ),
                        ),
                        addHeight(20),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis
                                .vertical, // This enables horizontal scrolling
                            children: List.generate(2, (index) {
                              return Column(
                                children: [
                                  //   Container(
                                  //   width: double.infinity,
                                  //   //margin: const EdgeInsets.all(20),
                                  //   // padding: const EdgeInsets.symmetric(
                                  //   //   horizontal: 12,
                                  //   //   vertical: 14,
                                  //   // ),
                                  //   decoration: BoxDecoration(
                                  //     color: const Color(0xFF4A3298),
                                  //     borderRadius: BorderRadius.circular(20),
                                  //   ),
                                  //   child:  Row(
                                  //     children: [
                                  //       Container(
                                  //         height: 70,
                                  //         width: 70,
                                  //         color: Colors.red,
                                  //         child: Image.asset( "assets/images/ps4_console_white_1.png",fit: BoxFit.contain,),
                                  //       ),
                                  //       // Image.asset("assets/images/Image Banner 2.png",fit: BoxFit.fitHeight,width: 50,),
                                  //       Column(
                                  //         children: [
                                  //           const Expanded(
                                  //             child: Text.rich(
                                  //               TextSpan(
                                  //                 style: TextStyle(color: Colors.white),
                                  //                 children: [
                                  //                   TextSpan(text: "A Summer Surpise\n"),
                                  //                   TextSpan(
                                  //                     text: "Cashback 20%",
                                  //                     style: TextStyle(
                                  //                       fontSize: 20,
                                  //                       fontWeight: FontWeight.bold,
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFFFFFFF),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 50,
                                              color: Color(0xFF000000)
                                                  .withOpacity(0.10),
                                              spreadRadius: 0)
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 85,
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10))),
                                          child: Center(
                                              child: Text(
                                            "OFF\n15%",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          )),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Summer Sale',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),
                                            ),
                                            addHeight(3),
                                            Text(
                                              'mypromocode2024 ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '6 days remaining',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10),
                                            ),
                                            addHeight(5),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 7,
                                                      horizontal: 12),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  color: Colors.red),
                                              child: const Center(
                                                  child: Text(
                                                "Apply",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              )),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                  addHeight(15)
                                ],
                              );
                            }),
                          ),
                        ),
                        addHeight(30),
                      ],
                    ),
                  ),
                )),
          );
        });
  }
}
