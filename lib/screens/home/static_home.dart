import 'dart:developer';
import 'package:flutter/material.dart'hide Badge;
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shop_app/helper/heigh_width.dart';
import 'package:shop_app/screens/home/components/special_offers.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/search_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../helper/apptheme_color.dart';
import '../common_product/common_product_format.dart';
import '../products/all_products_screen.dart';
import '../search/search_screen.dart';
import 'components/discount_banner.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {

  final searchController = Get.put(ProductSearchController());
  final wishListController = Get.put(WishListController());
  final cartController = Get.put(CartController());
  final String fetchProducts = """
query GetProducts {
  products(first: 5, where: { featured: true }) {
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
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return
      Container(
      decoration:  const BoxDecoration(
      // color: Color(0xfff3f3f3),
      image: DecorationImage(
        image: AssetImage(
          'assets/images/bg.png',
        ),
        alignment: Alignment.topRight,
        fit: BoxFit.contain,
      ),
            ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),shape: BoxShape.circle
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset("assets/images/Profile Image.png",height: 30,width: 30,)),
                ),
                Text("HOME",style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white,fontWeight: FontWeight.w700),),
                const Icon(Icons.notifications,color: Colors.white,)
              ],
            ),
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

              final List<dynamic>? allProducts =
                  result.data!['products']['edges'];
              log("Featured PRODUCTS $allProducts");
              if (allProducts == null || allProducts.isEmpty) {
                return const Center(child: Text('No products available'));
              }
              return
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // addHeight(20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Lets You Find Top Products",style: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Colors.white,fontSize: 14,fontWeight: FontWeight.w500),),

                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15,),
                        height: height * .06,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          // color: Colors.white,
                          // borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: searchController.keyWordText,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 17),
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.search,
                          onFieldSubmitted: (value) {
                            if (searchController.keyWordText.text.isNotEmpty) {
                              searchController.onSearchChanged(value, context);
                              searchController.searchMutation(
                                  searchController.keyWordText.text.toString(), context);
                              pushScreen(context, screen: const SearchPage(), withNavBar: true);
                              setState(() {});
                            }
                          },
                          onChanged: (value) {
                            searchController.onSearchChanged(value, context);
                          },
                          decoration: InputDecoration(
                              filled: true,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  FocusManager.instance.primaryFocus!.unfocus();
                                  if (searchController.keyWordText.text.isNotEmpty) {
                                    pushScreen(context, screen: SearchPage(), withNavBar: true);
                                    searchController.searchMutation(
                                        searchController.keyWordText.text.toString(), context);
                                    setState(() {});
                                  }
                                },
                                icon: Icon(
                                  Icons.search_rounded,
                                  color: AppThemeColor.primaryColor,
                                  size: 30,
                                ),
                              ),

                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide:  const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder:  const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              border: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.transparent, width: 3.0),
                                  borderRadius: BorderRadius.circular(5.0)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * .04),
                              hintText: 'Search Your Products',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                      // const Padding(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: HomeHeader(),
                      // ),
                      const DiscountBanner(),
                      // Categories(),
                      const SpecialOffers(),
                      // PopularProducts(),
                      addHeight(10),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: SectionTitle(
                      //     title: "Popular Products",
                      //     press: () {
                      //       pushScreen(context,
                      //           screen: const AllProductsScreen(),
                      //           withNavBar: true);
                      //     },
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Popular Products",style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14,fontWeight: FontWeight.w500),),
                            GestureDetector(
                                  onTap: (){
                                    pushScreen(context,
                                                  screen: const AllProductsScreen(),
                                                  withNavBar: true);
                                  },
                                child: Text("See more",style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14,fontWeight: FontWeight.w500),)),

                          ],
                        ),
                      ),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.only(left: 8,bottom: 10),
                            shrinkWrap: true,
                            itemCount: allProducts.length,
                            scrollDirection: Axis.horizontal,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 1,
                                mainAxisExtent: 190,
                                mainAxisSpacing: 1
                            ),

                            itemBuilder: (BuildContext context, i) {
                              final productsData = allProducts[i]['node'];
                              String disPercentage = '';
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

                              return  Padding(
                                padding: const EdgeInsets.only(left: 0,),
                                child: CommonProductFormat(
                                  onPress: () {},
                                  itemName: productsData['name'],
                                  stockStatus: productsData['stockStatus'] == "IN_STOCK"
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
                                ),
                              );
                            }),
                      ),


                    ],
                                  ),
                  ),
                );
            }),
            ),
      );
  }
}
