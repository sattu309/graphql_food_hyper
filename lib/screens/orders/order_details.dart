import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import '../../helper/dimentions.dart';
import '../../helper/heigh_width.dart';

class OrderDetailsOfMart extends StatefulWidget {
  final orderId;
  final date;
  final status;
  final payMentType;
   final subTotal;
  final total;
  const OrderDetailsOfMart(
      {Key? key,
      required this.orderId,
      this.date,
      this.status,
      this.payMentType,
      this.subTotal,
      this.total})
      : super(key: key);
  static var orderDetailsOfMart = "/orderDetailsOfMart";

  @override
  State<OrderDetailsOfMart> createState() => _OrderDetailsOfMartState();
}

class _OrderDetailsOfMartState extends State<OrderDetailsOfMart>
    with TickerProviderStateMixin {
  late TabController tabController;
  late String fetchMyOrdersDetails;
   var subTotal = "";

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    fetchMyOrdersDetails = """
 query Order {
    order(id: "${widget.orderId}", idType: DATABASE_ID) {
        shipping {
            firstName
            lastName
            address1
            address2
            email
            phone
            state
            city
            postcode
        }
        databaseId
        date
        id
        orderNumber
        paymentMethod
        status
        subtotal
        total
        lineItems {
            edges {
                node {
                    databaseId
                    id
                    orderId
                    productId
                    quantity
                    subtotal
                    total
                    product {
                        node {
                            id
                            databaseId
                            name
                            slug
                            sku
                            featuredImage {
                                node {
                                    sourceUrl
                                }
                            }
                        }
                    }
                    variation {
                        node {
                            id
                            databaseId
                            name
                            slug
                            sku
                            price
                            salePrice
                            regularPrice
                            featuredImage {
                                node {
                                    sourceUrl
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
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 30,
        title: Text(
          "Order Details",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: false,
      ),
      body: Query(
          options: QueryOptions(document: gql(fetchMyOrdersDetails)),
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
            final myOrderData = result.data?['order']['lineItems']['edges'];
            print(myOrderData);
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AddSize.padding16,
                ),
                child: Column(children: [
                  addHeight(10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(
                                2, 1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            color: Colors.black
                                .withOpacity(
                                0.10))
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order ID: ${widget.orderId.toString()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: AppThemeColor.primaryColor),
                              ),
                              addHeight(5),
                              Text(
                                widget.date,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                    color: Color(0xFF303C5E)),
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: AppThemeColor.primaryColor),
                            child: Center(
                              child: Text(
                                widget.status,
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  addHeight(10),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: myOrderData.length,
                      itemBuilder: (context, index) {
                        final item = myOrderData[index]['node'];
                        final product = item['product']['node'];
                        log("ORDER DATA ${item}");
                        final img =
                            product['featuredImage']['node']['sourceUrl'];
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(
                                          2, 1),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      color: Colors.black
                                          .withOpacity(
                                          0.10))
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 88,
                                    child: AspectRatio(
                                      aspectRatio: 0.80,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: img,
                                          height: 65,
                                          width: 65,
                                          errorWidget: (_, __, ___) =>
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
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                product['name'],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        addHeight(5),
                                        Row(
                                          children: [
                                            Text(
                                              "Quantity: ${item['quantity']}",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(0xFF486769)
                                                      .withOpacity(.50)),
                                            ),
                                            addWidth(10),
                                            Text(
                                              "R${item['total']}",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppThemeColor
                                                      .primaryColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                        // Column(
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () {
                        //       },
                        //       child: Container(
                        //           margin: EdgeInsets.symmetric(vertical: 7),
                        //           width: width,
                        //           padding: const EdgeInsets.all(14),
                        //           decoration: BoxDecoration(
                        //               color: Colors.white,
                        //               borderRadius: BorderRadius.circular(10),
                        //               boxShadow: [
                        //                 BoxShadow(
                        //                   color: const Color(0xFF37C666)
                        //                       .withOpacity(0.10),
                        //                   offset: const Offset(
                        //                     1,
                        //                     1,
                        //                   ),
                        //                   blurRadius: 20.0,
                        //                   spreadRadius: 1.0,
                        //                 ),
                        //               ]),
                        //           child:
                        //           Column(
                        //             crossAxisAlignment: CrossAxisAlignment
                        //                 .end,
                        //             children: [
                        //
                        //               Row(
                        //                   mainAxisAlignment: MainAxisAlignment
                        //                       .start,
                        //                   crossAxisAlignment: CrossAxisAlignment
                        //                       .start,
                        //                   children: [
                        //                     Container(
                        //                       padding: EdgeInsets.all(12),
                        //                       width: width * .25,
                        //                       // height:  height * .15,
                        //                       decoration: BoxDecoration(
                        //                           color: Color(0xffF6F6F6),
                        //                           borderRadius: BorderRadius
                        //                               .circular(15)
                        //
                        //                       ),
                        //                       child: CachedNetworkImage(
                        //                         imageUrl: img,
                        //                         fit: BoxFit.cover,
                        //                         width: 65,
                        //                         height: 75,
                        //                         errorWidget: (_, __, ___) =>
                        //                             Image.asset(
                        //                               'assets/images/Ellipse 67.png',
                        //                               width: 74,
                        //                               height: 82,
                        //                             ),
                        //                         placeholder: (_, __) =>
                        //                         const Center(
                        //                             child: CircularProgressIndicator()),
                        //                       ),
                        //                     ),
                        //                     Expanded(
                        //                       child: Padding(
                        //                         padding: const EdgeInsets
                        //                             .only(left: 15),
                        //                         child: Column(
                        //                             mainAxisAlignment: MainAxisAlignment
                        //                                 .start,
                        //                             crossAxisAlignment: CrossAxisAlignment
                        //                                 .start,
                        //                             children: [
                        //                               Text(
                        //                                 product['name'],
                        //                                 style: const TextStyle(
                        //                                     fontSize: 15,
                        //                                     fontWeight: FontWeight
                        //                                         .w500,
                        //                                     color: Color(
                        //                                         0xFF191723)),
                        //                               ),
                        //                               SizedBox(
                        //                                 height: 7,
                        //                               ),
                        //
                        //                               Text(
                        //                                 "Quantity: ${item['quantity']}",
                        //                                 style: TextStyle(
                        //                                     fontSize: 13,
                        //                                     fontWeight: FontWeight
                        //                                         .w500,
                        //                                     color: const Color(
                        //                                         0xFF486769)
                        //                                         .withOpacity(
                        //                                         .50)),
                        //                               ),
                        //                               SizedBox(
                        //                                 height: 7,
                        //                               ),
                        //
                        //                               Row(
                        //                                 mainAxisAlignment: MainAxisAlignment
                        //                                     .start,
                        //
                        //                                 children: [
                        //                                   Text(
                        //                                     item['total'],
                        //                                     style: TextStyle(
                        //                                         fontSize: 17,
                        //                                         fontWeight: FontWeight
                        //                                             .w700,
                        //                                         color: AppThemeColor
                        //                                             .primaryColor),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                               addHeight(7),
                        //                             ]),
                        //                       ),
                        //                     )
                        //                   ]),
                        //             ],
                        //           )
                        //
                        //
                        //       ),
                        //     )
                        //   ]);
                      }),
                  addHeight(5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      // boxShadow: [
                      //   BoxShadow(
                      //       offset: const Offset(
                      //           1, 2),
                      //       spreadRadius: 2,
                      //       blurRadius: 5,
                      //       color: Colors.black
                      //           .withOpacity(
                      //           0.10))
                      // ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff1A2E33)),
                              ),
                              Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppThemeColor.primaryColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.payMentType == "cod"
                                        ? "COD"
                                        : "ONLINE",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              )
                            ],
                          ),
                          addHeight(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Subtotal:',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff1A2E33)),
                              ),
                              Spacer(),
                              Text(
                                "R${widget.subTotal}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff486769)),
                              ),
                            ],
                          ),
                          addHeight(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Total:',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppThemeColor.primaryColor),
                              ),
                              Spacer(),
                              Text(
                                "${widget.total}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppThemeColor.primaryColor),
                              ),
                            ],
                          ),
                          addHeight(20)
                        ],
                      ),
                    ),
                  ),
                  addHeight(40),
                ]),
              ),
            );
          }),
    );
  }
}
