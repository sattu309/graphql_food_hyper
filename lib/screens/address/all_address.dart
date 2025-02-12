import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shop_app/screens/address/update_address.dart';
import '../../helper/apptheme_color.dart';
import '../../helper/custom_snackbar.dart';
import '../../helper/heigh_width.dart';
import 'add_address.dart';

class AllAddressPage extends StatefulWidget {
  const AllAddressPage({super.key});

  @override
  State<AllAddressPage> createState() => _AllAddressPageState();
}

class _AllAddressPageState extends State<AllAddressPage> {

  bool isChecked = false;
  late final getAllAddress;
  @override
  void initState() {
    super.initState();
    getAllAddress = '''
    query Addresses {
    addresses(users_id: "0") {
        id
        users_id
        address1
        city
        postcode
        fname
        lname
    }
}
    ''';
  }
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leadingWidth:30,
        title: const Text(
          "All Address",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xff222222)),
        ),
      ),
      body: Query(
        options: QueryOptions(document: gql(getAllAddress)),
        builder: (QueryResult? result,{Refetch? refetch, FetchMore? fetchMore}){
          if(result!.hasException){
            return Text(result.hasException.toString());
          }
          if(result.isLoading){
            return  Center(
              child: CircularProgressIndicator(
                color: AppThemeColor.primaryColor,
              ),
            );
          }
          final  allAddressData = result.data?['addresses'];
          log(allAddressData.toString());

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allAddressData.length,
                      itemBuilder: (BuildContext, index){
                        final addressList= allAddressData[index];
                        return
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  //  color:  Colors.white,
                                  offset: Offset(.0, .0,
                                  ),
                                 // blurRadius: 0,
                                  // spreadRadius: 2.0,
                                ),
                              ],

                            ),
                            child:
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${addressList['fname'].toString()} ${addressList['lname'].toString()}",
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            Get.to(()=> UpdateAddressScreen(id: addressList['id'].toString(),));
                                          },
                                          child:  Text(
                                            "Edit",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: AppThemeColor.primaryColor),
                                          ),
                                        ),
                                        const VerticalDivider(
                                          color: Colors.black26,
                                          thickness: 2,
                                          width: 20,
                                        ),
                                        addWidth(10),

                                        GestureDetector(
                                          onTap: (){
                                           deleteAddressMutation(addressList['id'].toString());
                                           refetch!();
                                           },
                                          child:  Text(
                                            "Remove",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: AppThemeColor.primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  addHeight(3),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        addressList['address1'].toString(),
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      addHeight(2),
                                      Text(
                                        "${addressList['postcode'].toString()} ${addressList['city'].toString()}",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        activeColor: AppThemeColor.primaryColor,
                                        value: selectedIndex == index,
                                        onChanged: (value) {

                                          setState(() {
                                            if (value!) {
                                              selectedIndex = index;
                                              log(selectedIndex.toString());
                                            } else {
                                              selectedIndex = null;
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        "Use as shipping address",
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                      }),
                ),
                addHeight(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.to(()=>const AddressScreen());
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              //  color:  Colors.white,
                              offset: Offset(.1, .1,
                              ),
                              blurRadius: 0.5,
                              spreadRadius: 2.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset("assets/images/p.png",color: Colors.white,height: 30,width: 30,),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        }

      ),
    );
  }
  Future<void> deleteAddressMutation(String addressId) async {
    final MutationOptions options = MutationOptions(
      document: gql('''
    mutation DeleteAddress(\$addressId: ID!) {
      deleteAddress(id: \$addressId) {
        message
      }
    }
  '''),
      variables: {
        'addressId': addressId,
      },
    );

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      final error = result.exception!.graphqlErrors.first.message;
      print("DELETE ADDRESS ERROR::::: $error");
      final snackBar = CustomSnackbar.build(
        message: error,
        backgroundColor: AppThemeColor.primaryColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? deleteAddress = result.data?['deleteAddress'];
      if (deleteAddress != null) {
        final snackBar = CustomSnackbar.build(
          message: deleteAddress['message'].toString(),
          backgroundColor: AppThemeColor.primaryColor,
          onPressed: () {},
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('Delete cart error: Invalid response data');
      }
    }
  }
}
