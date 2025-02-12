import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../helper/apptheme_color.dart';
import '../../helper/heigh_width.dart';
import '../product_details/details_screen.dart';

class CommonProductFormat extends StatefulWidget {
  final String itemName;
  final String stockStatus;
  final String itemPrice;
  final String salePrice;
  final String regPrice;
  final String productType;
  final String productID;
  final String avrRating;
  final String reviewCount;
  final String disCountPercent;
  final String itemImg;
  final VoidCallback onPress;
  const CommonProductFormat({
    Key? key,
    required this.onPress,
    required this.itemName,
    required this.stockStatus,
    required this.itemPrice,
    required this.salePrice,
    required this.regPrice,
    required this.itemImg,
    required this.disCountPercent, required this.productType, required this.productID, required this.avrRating, required this.reviewCount,
  }) : super(key: key);



  @override
  State<CommonProductFormat> createState() => _CommonProductFormatState();
}

class _CommonProductFormatState extends State<CommonProductFormat> {
  final wishListController = Get.put(WishListController());
  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return
      GestureDetector(
        onTap: (){
          pushScreen(context,
              screen: DetailsScreen(
                productId: widget.productID,
                productStatus: widget.stockStatus,
              ),
              withNavBar: true,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                    height: 250,
                    padding: const EdgeInsets.symmetric(horizontal: 10,),
                    margin: const EdgeInsets.symmetric(horizontal: 6,),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.black12),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(4, 4),
                            spreadRadius: 2,
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.10)
                        )
                      ],
                    ),
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: CachedNetworkImage(
                            imageUrl: widget.itemImg,
                            height: height *.16,
                            width: width *.40,
                            fit: BoxFit.contain,
                            errorWidget: (_, __, ___) => Image.asset(
                              "assets/images/Image Popular Product 2.png",
                              fit: BoxFit.cover,
                              height: 50,
                              width: 50,
                            ),
                            placeholder: (_, __) =>  Container(
                              color: Colors.grey.shade200,
                            ),

                          ),
                        ),
                         const SizedBox(height: 3),
                        Flexible(
                          child: Text(
                              widget.itemName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                              Theme.of(context).textTheme.bodySmall
                          ),
                        ),
                        addHeight(3),
                        Text(
                            widget.stockStatus,
                            maxLines: 1,
                            style:  TextStyle(
                                fontWeight: FontWeight.w500,
                                color: widget.stockStatus == "IN_STOCK" ? Colors.green:Colors.red,fontSize: 10)
                        ),
                        addHeight(3),
                        widget.avrRating != "" && int.tryParse(widget.avrRating) != null ?
                        Row(
                            children: [
                              ...List.generate(int.parse(widget.avrRating), (index){
                                return  SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Row(
                                    children: [
                                      Icon(Icons.star,color: Colors.yellow.shade600,size: 17,),
                                    ],
                                  ),
                                );
                              }),
                              addWidth(3),
                               widget.reviewCount != "0" ?
                              Text(
                              widget.reviewCount,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "IBM Plex Sans",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black38,
                                ),
                              ):SizedBox()
                            ]
                        ):addHeight(16),
                        addHeight(2),
                        (widget.salePrice!="0") ?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.regPrice,
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
                                    widget.salePrice,
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
                          widget.itemPrice,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "IBM Plex Sans",
                            fontWeight: FontWeight.w700,
                            color: AppThemeColor.primaryColor,
                          ),
                        ),
                        addHeight(5),
                        widget.productType =="SIMPLE" ?
                        Container(
                          height: 25,
                          alignment: Alignment.centerRight,
                          width: width * .5,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(

                              shape: RoundedRectangleBorder(),
                              backgroundColor: AppThemeColor.primaryColor,
                            ),
                            onPressed: () async {
                              wishListController.addToCart(
                                  int.parse(widget.productID.toString()),
                                  0,
                                  1,
                                  context);

                              cartController.getCartDataLocally();
                            },
                            child: const Text("ADD TO CART",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
                          ),
                        ):
                        Container(
                          height: 25,
                          alignment: Alignment.centerRight,
                          width: width * .5,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(

                              shape: RoundedRectangleBorder(),
                              backgroundColor: AppThemeColor.primaryColor,
                            ),
                            onPressed: () async {
                              pushScreen(context,
                                  screen:  DetailsScreen(productId: widget.productID.toString(),  productStatus: widget.stockStatus,), withNavBar: true);
                            },
                            child: const Text("VIEW OPTION",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 10),),
                          ),
                        ),
                      ],
                    )
                  //
                  // Image.asset("assets/images/glap.png",),
                ),
                (widget.disCountPercent != '') ?
                Positioned(
                    top: height*0.015,
                    left: 15,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppThemeColor.primaryColor
                      ),
                      child: Text(
                          '${widget.disCountPercent}%',
                          maxLines: 1,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,color: CupertinoColors.white,fontSize: 12)
                      ),)) :SizedBox()
              ],
            ),
          ],
        ),
      );
  }
}

String calDis(String regPrice, String salePrice) {
  bool isVar = regPrice.contains(' - ');
  double disCount = 0;

  if (isVar) {
    List<String> regPrices = regPrice.split(' - ');
    List<String> salePrices = salePrice.split(' - ');

    // Parsing the string prices to double
    double regPriceMin = double.parse(regPrices[0].replaceAll(RegExp(r'[^\d.]'), ''));
    double salePriceMin = double.parse(salePrices[0].replaceAll(RegExp(r'[^\d.]'), ''));

    disCount = ((regPriceMin - salePriceMin) / regPriceMin) * 100;
  } else {
    // Parsing the string prices to double
    double regPriceValue = double.parse(regPrice.replaceAll(RegExp(r'[^\d.]'), ''));
    double salePriceValue = double.parse(salePrice.replaceAll(RegExp(r'[^\d.]'), ''));

    disCount = ((regPriceValue - salePriceValue) / regPriceValue) * 100;
  }

  return (disCount.toInt()).toString();
}