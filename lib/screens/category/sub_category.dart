import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/helper/heigh_width.dart';
import 'package:shop_app/screens/category/category_products_screen.dart';

class SubCategoryList extends StatefulWidget {
  const SubCategoryList({super.key});

  @override
  State<SubCategoryList> createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
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


  final List<String> choosedOption =
  ["1","2", "3", "4","6","12"];
  String? chooseUnit;


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppThemeColor.primaryColor,
        centerTitle: false,
        leadingWidth: 60,
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_outlined,color: Colors.white,)),
        title: const Text(
          "Sub Categories",
          style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.white),
        ),
      ),
      body:
      Query(
        options: QueryOptions(document: gql(fetchCategories)),
        builder:  (QueryResult result, {Refetch? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Center(child:  CircularProgressIndicator(color: AppThemeColor.primaryColor,));
          }

          final allCategories = result.data!['productCategories']['edges'];
          log("ALL CATEGORIES ${allCategories}");
          return
            Column(
              children: [
                // addHeight(7),
                Expanded(
                  child: GridView.builder(
                      itemCount: allCategories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        // maxCrossAxisExtent: 100,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 0.0,
                        mainAxisSpacing: 0.0,
                        crossAxisCount: 4,
                      ),

                      itemBuilder: (context, index){
                        final data = allCategories[index]['node'];
                        final img = data['image'];
                        String image = "";
                        if(img != null && img['sourceUrl']!= null){
                          image = img['sourceUrl'];
                        }

                        return  GestureDetector(
                          onTap: (){

                            log("CATEGORY ID $data['id']");
                            // Get.to(()=> CategoryProductsScreen(
                            //   categoryId: data['id'], categoryName: data['category'],));
                            // pushScreen(context, screen: CategoryProductsScreen(
                            //   categoryId: data['id'], categoryName: data['category'],),withNavBar: true);

                            },
                          child: Container(

                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade100)
                            ),
                            child: Column(
                              children: [
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
                        );
                      }
                  ),
                ),
              ],
            );


        },

      ),
    );
  }

}

