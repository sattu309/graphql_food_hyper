import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/helper/heigh_width.dart';
import '../../controllers/session_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../product_details/details_screen.dart';
import '../products/all_products_screen.dart';
import 'components/home_header.dart';
import 'components/section_title.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final wishListController = Get.put(WishListController());
  final sessionController = Get.put(SessionController());
  bool isFav = false;
  RxDouble sliderIndex = (0.0).obs;
  String imgLInk = "https://shopdemo.bitlogiq.co.za/products/medium/";
  final getHomeData = '''
  query HomeData {
    homeData {
        brands {
            id
            brand
            brandlogo
        }
        sliders {
            id
            slidertitle
            sliderimage
            sliderimagemobile
        }
        banners {
            id
            imagetitle
            imagepath
            imagemobile
        }
        categories {
            id
            category      
        }
    latestProducts(limit: 10) {
      id
      productname
      price
      minprice
      maxprice
      slug
      productvariations {
        id
        inventory
      }
      productimages {
        imagepath
        product_id
        order_by
      }
      productattributes {
        id
        is_variation
        product_id
        attribute {
          attributename
        }
        attributeterm {
          termname
        }
      }
    }
    featuredProducts(limit: 10) {
      id
      productname
      price
      minprice
      maxprice
      slug
      productvariations {
        id
        inventory
      }
      productimages {
        imagepath
        product_id
        order_by
      }
      productattributes {
        id
        is_variation
        product_id
        attribute {
          attributename
        }
        attributeterm {
          termname
        }
      }
    }
    }
}
  ''';
  String imagePath = "https://shopdemo.bitlogiq.co.za/sliders/";

  @override
  void initState() {
    super.initState();
    wishListController.fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Query(
          options: QueryOptions(document: gql(getHomeData)),
          builder: (QueryResult result,
              {Refetch? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.hasException.toString());
            }
            if (result.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppThemeColor.primaryColor,
                ),
              );
            }
            final homeData = result.data?['homeData'];
            final latestProduct = homeData['latestProducts'];
            final featuredProduct = homeData['featuredProducts'];
            final List<dynamic> bannerList = homeData['banners'];
            final List<dynamic> sliderList = homeData['sliders'];
            log("HOME PAGE BANNER DATA  $bannerList");
            log("HOME PAGE DATA $homeData");
            log("HOME PAGE featuredProduct   $featuredProduct");
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      width: width,
                      decoration: BoxDecoration(
                        color: AppThemeColor.primaryColor
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.asset("assets/images/food_logo.png"),
                      ),
                    ),
                    addHeight(10),
                    const HomeHeader(),
                    addHeight(15),
                    CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 1,
                        autoPlay: false,
                        onPageChanged: (value, _) {
                          sliderIndex.value = value.toDouble();
                        },
                        autoPlayCurve: Curves.decelerate,
                        height: height * .20,
                      ),
                      items: bannerList.map((banner) {
                        return Container(
                          width: width,
                          margin: EdgeInsets.symmetric(horizontal: width * .02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: AppThemeColor.backgroundcolor,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: CachedNetworkImage(
                              imageUrl: "$imagePath${banner['imagepath']}",
                              fit: BoxFit.fill,
                              placeholder: (_, __) => const Center(
                                  child: CircularProgressIndicator()),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    // DiscountBanner(),
                    // addHeight(10),
                    // SizedBox(
                    //   height: 120,
                    //   child: ListView.builder(
                    //       shrinkWrap: true,
                    //       scrollDirection: Axis.horizontal,
                    //       itemCount: categories.length,
                    //       itemBuilder: (BuildContext, index) {
                    //         final categoryData = categories[index];
                    //         return GestureDetector(
                    //           onTap: () {
                    //             log(categoryData['id'].toString());
                    //             Get.to(() => CategoryProductsScreen(categoryId: categoryData['id'].toString(),));
                    //           },
                    //           child: Container(
                    //             width: width * .3,
                    //             padding: const EdgeInsets.symmetric(
                    //               horizontal: 5,
                    //             ),
                    //             margin: EdgeInsets.symmetric(
                    //                 horizontal: width * .015),
                    //             decoration: BoxDecoration(
                    //               color: const Color(0xFFFFECDF),
                    //               borderRadius: BorderRadius.circular(6),
                    //             ),
                    //             child: Column(
                    //               children: [
                    //                 Container(
                    //                   padding: const EdgeInsets.all(16),
                    //                   height: 60,
                    //                   width: 56,
                    //                   decoration: BoxDecoration(
                    //                     color: const Color(0xFFFFECDF),
                    //                     borderRadius: BorderRadius.circular(50),
                    //                     image: DecorationImage(
                    //                       image: AssetImage("assets/images/Image Popular Product 2.png",),
                    //                     )
                    //                   ),
                    //                 ),
                    //                 const SizedBox(height: 4),
                    //                 SizedBox(
                    //                   width: 70,
                    //                   child: Text(
                    //                     categoryData['category'].toString(),
                    //                     maxLines: 2,
                    //                     textAlign: TextAlign.center,
                    //                     overflow: TextOverflow.ellipsis,
                    //                   ),
                    //                 )
                    //               ],
                    //             ),
                    //           ),
                    //         );
                    //       }),
                    // ),
                    // addHeight(5),
                    // CarouselSlider(
                    //   options: CarouselOptions(
                    //     viewportFraction: 1,
                    //     autoPlay: true,
                    //     onPageChanged: (value, _) {
                    //       sliderIndex.value = value.toDouble();
                    //     },
                    //     autoPlayCurve: Curves.decelerate,
                    //     height: height * .25,
                    //   ),
                    //   items: sliderList.map((slider) {
                    //     return Stack(
                    //       children: [
                    //         Container(
                    //           width: width,
                    //           margin:
                    //               EdgeInsets.symmetric(horizontal: width * .02),
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(0),
                    //             color: AppThemeColor.backgroundcolor,
                    //           ),
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(0),
                    //             child: CachedNetworkImage(
                    //               imageUrl:
                    //                   "$imagePath${slider['sliderimagemobile']}",
                    //               fit: BoxFit.cover,
                    //               placeholder: (_, __) => const Center(
                    //                   child: CircularProgressIndicator()),
                    //             ),
                    //           ),
                    //         ),
                    //         Positioned(
                    //             top: 10,
                    //             left: 20,
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                  Text(
                    //                   slider['slidertitle'].toString(),
                    //                   textAlign: TextAlign.center,
                    //                   style: const TextStyle(
                    //                     fontWeight: FontWeight.w700,
                    //                     fontSize: 19,
                    //                   ),
                    //                 ),
                    //                 addHeight(3),
                    //                 const Text(
                    //                   "UPTO 60% OFF",
                    //                   textAlign: TextAlign.center,
                    //                   style: TextStyle(
                    //                     fontWeight: FontWeight.w600,
                    //                     fontSize: 16,
                    //                   ),
                    //                 ),
                    //                 addHeight(10),
                    //                 Container(
                    //                   padding: const EdgeInsets.symmetric(horizontal: 5),
                    //                   decoration: BoxDecoration(
                    //                     color: const Color(0xff953fa7),
                    //                     borderRadius: BorderRadius.circular(3)
                    //                   ),
                    //                   child: const Padding(
                    //                     padding: EdgeInsets.all(5.0),
                    //                     child: Text(
                    //                       "SHOP NOW",
                    //                       textAlign: TextAlign.center,
                    //                       style: TextStyle(
                    //                         color: Colors.white,
                    //                         fontWeight: FontWeight.w500,
                    //                         fontSize: 10,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ))
                    //       ],
                    //     );
                    //   }).toList(),
                    // ),
                    // SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SectionTitle(
                          title: "Latest Products",
                          press: () {
                            pushScreen(context,
                                screen: const AllProductsScreen(), withNavBar: true);
                          },
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(
                                latestProduct.length,
                                    (index) {
                                    final latestData = latestProduct[index];
                                    final allImage = latestData['productimages'] as List<dynamic>;
                                    final firstImage = allImage.isNotEmpty ? allImage[0]['imagepath'] : '';



                                  return SizedBox(
                                    width: width*.47,
                                    child: GestureDetector(
                                      onTap: (){
                                        // Get.to(()=> DetailsScreen(productId: latestData['id'],));
                                        pushScreen(context,
                                            screen:  DetailsScreen(productId: latestData['id'], productStatus: '',), withNavBar: true);
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 5),
                                            margin: const EdgeInsets.symmetric(horizontal: 4),

                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(7),
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: const Offset(0, -15),
                                                  blurRadius: 20,
                                                  color: const Color(0xFFDADADA).withOpacity(0.15),
                                                )
                                              ],
                                            ),
                                            child:
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(7),
                                                    child: CachedNetworkImage(
                                                      imageUrl: imgLInk+firstImage,
                                                      fit: BoxFit.contain,
                                                      width: width,
                                                      height: height*.20,
                                                      errorWidget: (_, __, ___) =>SizedBox(),
                                                          // Image.asset(
                                                        // "assets/images/Image Banner 3.png",
                                                      // ),
                                                      placeholder: (_, __) => const Center(
                                                          child: CircularProgressIndicator()),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  latestData['productname'].toString(),
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                  maxLines: 1,
                                                ),
                                                const SizedBox(height: 3),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "R${latestData['price'].toString()}",
                                                      style:  TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: "IBM Plex Sans",
                                                        fontWeight: FontWeight.w700,
                                                        color: AppThemeColor.primaryColor,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      borderRadius: BorderRadius.circular(50),
                                                      onTap: () {
                                                        log("product id ${latestData['id'].toString()}");
                                                        log("favortie match  id ${wishListController.getFavIds.toString()}");
                                                        wishListController.addWishList(latestData['id'].toString(),
                                                            "",context);
                                                        wishListController.fetchWishlist();
                                                        if(wishListController.getFavIds.contains(latestData[index]['id'])){
                                                          isFav = true;
                                                          setState(() {});
                                                        }else{
                                                          isFav = false;
                                                          setState(() {});
                                                        }
                                                      },
                                                      child:
                                                      isFav ?
                                                      Container(
                                                        padding: const EdgeInsets.all(6),
                                                        height: 24,
                                                        width: 24,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.withOpacity(0.15),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: SvgPicture.asset(
                                                          "assets/icons/Heart Icon_2.svg",color: AppThemeColor.primaryColor,
                                                        ),
                                                      ):
                                                      Container(
                                                        padding: const EdgeInsets.all(6),
                                                        height: 24,
                                                        width: 24,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey.withOpacity(0.15),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: SvgPicture.asset(
                                                          "assets/icons/Heart Icon_2.svg",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                addHeight(4)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ); // here by default width and height is 0
                                },
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SectionTitle(
                            title: "Featured Products",
                            press: () {
                              // Get.to(()=>const AllProductsScreen());
                              pushScreen(context,
                                  screen: const AllProductsScreen(), withNavBar: true);
                            },
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...List.generate(
                                  featuredProduct.length,
                                      (index) {
                                    final featuredData = featuredProduct[index];
                                    final allImage = featuredData['productimages'] as List<dynamic>;
                                    final firstImage = allImage.isNotEmpty ? allImage[0]['imagepath'] : '';
                                    return SizedBox(
                                      width: width*.47,
                                      child: GestureDetector(
                                        onTap: (){
                                          // Get.to(()=> DetailsScreen(productId: featuredData['id'],));
                                          pushScreen(context,
                                              screen:  DetailsScreen(productId: featuredData['id'], productStatus: '',), withNavBar: true);
                                        },

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 5),
                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(7),
                                              ),
                                              child:
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(7),
                                                      child: CachedNetworkImage(
                                                        imageUrl: imgLInk+firstImage,
                                                        fit: BoxFit.contain,
                                                        width: width,
                                                        height: height*.20,
                                                        errorWidget: (_, __, ___) =>SizedBox(),
                                                        // Image.asset(
                                                        // "assets/images/Image Banner 3.png",
                                                        // ),
                                                        placeholder: (_, __) => const Center(
                                                            child: CircularProgressIndicator()),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    featuredData['productname'].toString(),
                                                    style: Theme.of(context).textTheme.bodySmall,
                                                    maxLines: 1,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "R${featuredData['price'].toString()}",
                                                        style:  TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "IBM Plex Sans",
                                                          fontWeight: FontWeight.w600,
                                                          color: AppThemeColor.primaryColor,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        borderRadius: BorderRadius.circular(50),
                                                        onTap: () {
                                                          log("product id ${featuredData['id'].toString()}");
                                                          wishListController.addWishList(featuredData['id'].toString(), "", context);
                                                          wishListController.fetchWishlist();
                                                        },
                                                        child: Container(
                                                          padding: const EdgeInsets.all(6),
                                                          height: 24,
                                                          width: 24,
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey.withOpacity(0.15),
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: SvgPicture.asset(
                                                            "assets/icons/Heart Icon_2.svg",
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  addHeight(2)
                                                ],
                                              ),
                                            ),
                                            addHeight(6)

                                          ],
                                        ),
                                      ),
                                    ); // here by default width and height is 0
                                  },
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
