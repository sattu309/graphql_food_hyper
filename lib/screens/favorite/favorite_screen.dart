import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/controllers/wishlist_controller.dart';
import '../../helper/heigh_width.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final favController = Get.put(WishListController());
  String imgLInk = "https://ctshop.ssspl.net/products/medium/";
//   final String fetchFavProducts = """
//  query Wishlist {
//     wishlist {
//         id
//         users_id
//         product_id
//         productname
//         slug
//         image
//         minprice
//         maxprice
//     }
// }
//   """;

  RxInt refreshInt = 0.obs;
@override
  void initState() {
    super.initState();
    favController.fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return
    Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body:
      SafeArea(
          child:
          Padding(
            padding:  EdgeInsets.all(70),
            child: Center(child: Column(
              children: [
                addHeight(height*.2),
                Image.asset("assets/images/Favaorites.png"),
                addHeight(5),
                const Text(
                  "No item in Favorite",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff0F0300)),
                ),
              ],
            ),),
          )
              // Obx(() {
              //   return  Column(
              //     children: [
              //       addHeight(10),
              //       Text(
              //         "Favorites",
              //         style: Theme.of(context).textTheme.titleLarge,
              //       ),
              //       favController.wishlist.isNotEmpty ?
              //       Expanded(
              //         child: Padding(
              //           padding: const EdgeInsets.all(16),
              //           child: GridView.builder(
              //               itemCount: favController.wishlist.length,
              //               gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              //                 maxCrossAxisExtent: 200,
              //                 childAspectRatio: 0.6,
              //                 mainAxisSpacing: 1,
              //                 crossAxisSpacing: 7,
              //               ),
              //               itemBuilder: (context, index){
              //                 final favData = favController.wishlist[index];
              //                 final image = favData['image'];
              //                 return GestureDetector(
              //                   onTap: (){
              //                     // log("PRODUCT ID $favData['id']");
              //                     // Get.to(()=> DetailsScreen(productId: favData['product_id'],));
              //                     pushScreen(
              //                         context,
              //                         screen:  DetailsScreen(productId: favData['product_id'],),
              //                         withNavBar: true
              //                     );
              //                   },
              //                   child:
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Container(
              //                           decoration: BoxDecoration(
              //                             color: kSecondaryColor.withOpacity(0.1),
              //                             borderRadius: BorderRadius.circular(7),
              //                             boxShadow: [
              //                               BoxShadow(
              //                                 offset: const Offset(0, -16),
              //                                 blurRadius: 20,
              //                                 color: const Color(0xFFDADADA).withOpacity(0.15),
              //                               )
              //                             ],
              //                           ),
              //                           child:
              //
              //                           ClipRRect(
              //                             borderRadius: BorderRadius.circular(7),
              //                             child: CachedNetworkImage(
              //                               imageUrl: imgLInk+image,
              //                               height: height *.27,
              //                               width: width *.55,
              //                               errorWidget: (_, __, ___) => Image.asset(
              //                                 "assets/images/Image Popular Product 2.png",
              //                                 fit: BoxFit.cover,
              //                                 height: 50,
              //                                 width: 50,
              //                               ),
              //                               placeholder: (_, __) =>  Container(
              //                                 color: Colors.grey.shade200,
              //                               ),
              //                               fit: BoxFit.cover,
              //                             ),
              //                           )
              //                         //
              //                         // Image.asset("assets/images/glap.png",),
              //                       ),
              //                       const SizedBox(height: 8),
              //                       Text(
              //                         favData['productname'].toString(),
              //                         style: Theme.of(context).textTheme.bodyMedium,
              //                         maxLines: 2,
              //                       ),
              //                       Row(
              //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                         children: [
              //                           Text(
              //                             "\$${favData['minprice']} - \$${favData['maxprice']}",
              //                             style:  TextStyle(
              //                               fontSize: 14,
              //                               fontWeight: FontWeight.w600,
              //                               color: AppThemeColor.primaryColor,
              //                             ),
              //
              //                           ),
              //
              //                           InkWell(
              //                             borderRadius: BorderRadius.circular(50),
              //                             onTap: () {
              //                               log(favData['id'].toString());
              //                               favController.removeWishListData(favData['id'].toString(),context).then((value){
              //                                 favController.fetchWishlist();
              //                                 setState(() {});
              //                               });
              //                             },
              //                             child: Container(
              //                               padding: const EdgeInsets.all(6),
              //                               height: 25,
              //                               width: 25,
              //                               decoration: BoxDecoration(
              //                                 color:
              //                                 kSecondaryColor.withOpacity(0.1),
              //                                 shape: BoxShape.circle,
              //                               ),
              //                               child: SvgPicture.asset(
              //                                 "assets/icons/Heart Icon_2.svg",
              //                                 colorFilter: ColorFilter.mode(
              //                                     AppThemeColor.primaryColor,
              //                                     BlendMode.srcIn),
              //                               ),
              //                             ),
              //                           ),
              //                         ],
              //                       )
              //                     ],
              //                   ),
              //                 );
              //               }
              //             // => ProductCard(
              //             //     product: demoProducts[index],
              //             //     onPress: (){}
              //             //   //     () => Navigator.pushNamed(
              //             //   //   context,
              //             //   //   DetailsScreen.routeName,
              //             //   //   arguments:
              //             //   //       ProductDetailsArguments(product: demoProducts[index]),
              //             //   // ),
              //             // ),
              //           ),
              //         ),
              //       ):Padding(
              //         padding:  EdgeInsets.all(70),
              //         child: Center(child: Column(
              //           children: [
              //             addHeight(height*.2),
              //             Image.asset("assets/images/Favaorites.png"),
              //             addHeight(5),
              //             const Text(
              //               "No item in Favorite",
              //               style: TextStyle(
              //                   fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xff0F0300)),
              //             ),
              //           ],
              //         ),),
              //       )
              //     ],
              //   );
              // })


      )

    );

  }
}
