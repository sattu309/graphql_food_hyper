import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/helper/heigh_width.dart';
import 'package:shop_app/screens/cart/cart_screen.dart';
import 'package:shop_app/screens/category/category_products_screen.dart';

import '../../controllers/cart_controller.dart';
import '../home/components/search_field.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final cartController = Get.put(CartController());
  final String fetchCategories = """
   query ProductCategories {
    productCategories(where: { parent: 0 }) {
        edges {
            node {
                id
                image {
                    sourceUrl
                }
                menuOrder
                name
                slug
                productCategoryId
    
            }
        }
    }
}
  """;

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
          title:   SearchField(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      pushScreen(context, screen:CartScreen(),withNavBar: true );
                      // Get.to(()=>CartScreen());
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
        body:
        Query(
          options: QueryOptions(document: gql(fetchCategories),fetchPolicy: FetchPolicy.noCache,),
          builder:  (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return Center(child:  CircularProgressIndicator(color: AppThemeColor.primaryColor,));
            }

            final allCategories = result.data!['productCategories']['edges'];
            if (allCategories == null || allCategories.isEmpty) {
              return Center(child: Text("No categories available"));
            }
            log("ALL CATEGORIES ${allCategories}");
            return
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 3),
                child: Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    addHeight(4),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text("SHOP BY CATEGORY", style: Theme.of(context).textTheme.titleSmall,),
                    ),
                    addHeight(4),
                    Expanded(
                      child: GridView.builder(
                          itemCount: allCategories.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            // maxCrossAxisExtent: 100,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 0.0,
                            mainAxisSpacing: 0.0,
                            crossAxisCount: 3,
                          ),

                          itemBuilder: (context, index){
                            final data = allCategories[index]['node'];
                            final img = data['image'];
                            String image = "";
                            if(img != null && img['sourceUrl']!= null){
                              image = img['sourceUrl'];
                            }

                            return
                              GestureDetector(
                              onTap: (){

                                log("CATEGORY ID ${data['productCategoryId'].toString()}");
                                // Get.to(()=> CategoryProductsScreen(
                                //   categoryId: data['id'], categoryName: data['category'],));
                                pushScreen(context, screen: CategoryProductsScreen(
                                  categoryId: data['productCategoryId'].toString()),withNavBar: true);
                              },
                              child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade100),
                                  borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(4, 4),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      color: Colors.black.withOpacity(0.10)
                                    )
                                  ],

                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      addHeight(18),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: CachedNetworkImage(
                                          imageUrl: image,
                                          height: 70,
                                          width: 70,
                                          fit: BoxFit.contain,
                                          errorWidget: (_, __, ___) => SizedBox(),
                                          placeholder: (_, __) =>  Container(
                                            color: Colors.grey.shade200,
                                          ),

                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Expanded(child:
                                      Text(
                                        data['name'], textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontSize: 13),)),

                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              );


          },

        ),
      ),
    );
  }

}

