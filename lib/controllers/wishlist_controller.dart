import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/components/graphql_client.dart';
import 'package:shop_app/helper/snackbar_popup.dart';

import '../helper/apptheme_color.dart';
import '../helper/common_button.dart';
import '../helper/custom_snackbar.dart';
import '../models/login_token_model.dart';
import 'cart_controller.dart';

class WishListController extends GetxController{

  var wishlist = [].obs;
  List<String> getFavIds = [];
  Future<void> addWishList(String productId, String token, context) async {
    final MutationOptions options = MutationOptions(
      document: gql('''
   mutation AddWishlist(\$productId: ID!,){
    addWishlist(product_id: \$productId,) {
        message
        }
     }
  '''),
          variables: {
             'productId': productId,
           },
    );

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      List<String> errorMessages = [];

      if (result.exception!.graphqlErrors.isNotEmpty) {
        errorMessages =
            result.exception!.graphqlErrors.map((e) => e.message).toList();
      }

      if (result.exception!.linkException != null) {
        errorMessages.add(result.exception!.linkException.toString());
      }
      print("ADD WISHLIST ERROR::::: $errorMessages");
      final snackBar = CustomSnackbar.build(
        message: errorMessages.toString(),
        backgroundColor: AppThemeColor.primaryColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? wishListData = result.data?['addWishlist'];
      if (wishListData != null) {
        final snackBar = CustomSnackbar.build(
          message: wishListData['message'].toString(),
          backgroundColor: AppThemeColor.primaryColor,
          onPressed: () {},

        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('wishlist graphql: Invalid response data');
      }
    }
  }

  Future<void> removeWishListData(String id,context) async {
    final MutationOptions options = MutationOptions(
      document: gql('''
   mutation RemoveList(\$id: ID!){
    removeList(id: \$id) {
        message
        }
     }
  '''),
      variables: {
        'id': id,
      },
    );

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      List<String> errorMessages = [];

      if (result.exception!.graphqlErrors.isNotEmpty) {
        errorMessages =
            result.exception!.graphqlErrors.map((e) => e.message).toList();
      }

      if (result.exception!.linkException != null) {
        errorMessages.add(result.exception!.linkException.toString());
      }
      print("REMOVE  WISHLIST ERROR::::: $errorMessages");
      final snackBar = CustomSnackbar.build(
        message: errorMessages.toString(),
        backgroundColor: AppThemeColor.primaryColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? wishListData = result.data?['removeList'];
      if (wishListData != null) {
        fetchWishlist();
        log(wishListData.toString());
        final snackBar = CustomSnackbar.build(
          message: wishListData['message'].toString(),
          backgroundColor: AppThemeColor.primaryColor,
          onPressed: () {},
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('wishlist graphql: Invalid response data');
      }
    }
  }

  // late GraphQLClient client;

   Future<void> fetchWishlist() async {
    final GraphQLClient client = initializeClient();
     const String fetchFavProducts = """
    query Wishlist {
      getwishlist {
        id
        users_id
        product_id
        productname
        slug
        image
        minprice
        maxprice
      }
    }
  """;
   QueryOptions options = QueryOptions(
      document: gql(fetchFavProducts),
    );

    final result = await client.query(options);

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      if(result.data?['getwishlist'] != null && result.data?['getwishlist'].isNotEmpty) {
        wishlist.value = result.data?['getwishlist'];
        for (var item in wishlist) {
          getFavIds.add(item['product_id']);
        }
        // log("favorite IDs: $getFavIds");
      }

      // log("wish list data ${wishlist.toString()}");
    }

  }


  // add to cart mutation
  Future<void> addToCart( int pId,  int pVId, int cValue,context ) async {
    final cartController = Get.put(CartController());
    final MutationOptions options = MutationOptions(
      document: gql('''
      mutation AddToCart(\$input: AddToCartInput!) {
        addToCart(
        input:\$input ) {
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
        'input': {
          'productId': pId,
          'quantity': cValue,
          'variationId': pVId,

          // 'pVId': pVId,
        },
      },
    );

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      List<String> errorMessages = [];

      if (result.exception!.graphqlErrors.isNotEmpty) {
        errorMessages =
            result.exception!.graphqlErrors.map((e) => e.message).toList();
      }

      if (result.exception!.linkException != null) {
        errorMessages.add(result.exception!.linkException.toString());
      }
      print("ADD TO CART ERROR::::: $errorMessages");
      // final snackBar = CustomSnackbar.build(
      //   message: errorMessages.toString(),
      //   backgroundColor: AppThemeColor.primaryColor,
      // );
      //
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? addToCartData = result.data?['addToCart'];
      log("RESULT ADD TO CART${result}");
      if (addToCartData != null) {
        SharedPreferences cartLocalData =
        await SharedPreferences.getInstance();
        cartLocalData.setString('cart_data', jsonEncode(addToCartData['cart']));
        cartController.getCartDataLocally();
        // showAddToCartPopup(context, "Item added to cart!");
         showSnackBarView(context, "Product added to cart successfully", Colors.black);
        // }
      } else {
        print('Add to cart error: Invalid response data');
      }
    }
  }


  @override
  void onInit() {
    super.onInit();
    // initializeClient();
    // fetchWishlist();
  }
}

