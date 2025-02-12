import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shop_app/helper/common_button.dart';
import 'package:shop_app/helper/heigh_width.dart';

import '../../helper/apptheme_color.dart';
import '../../helper/common_textfiled.dart';
import '../../helper/custom_snackbar.dart';

class UpdateAddressScreen extends StatefulWidget {
  final String id;
  const UpdateAddressScreen({super.key, required this.id});


  @override
  State<UpdateAddressScreen> createState() => _UpdateAddressScreenState();
}

class _UpdateAddressScreenState extends State<UpdateAddressScreen> {
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();








  updateAddressMutation(
      {
        required String id,
        required String fname,
        required String lname,
        required String address1,
        required String city,
        required String zipCode}) async {

    final MutationOptions options = MutationOptions(
      document: gql('''
      mutation UpdateAddress(\$input: UpdateAddressInput!) {
        updateAddress(
       input:\$input
            ) {
         id
        users_id
        address1
        city
        postcode
        fname
        lname
        }
      }
    '''),
      variables: {
        'input':{
          'id':id,
          'fname': fname,
          'lname': lname,
          'address1': address1,
          'city': city,
          'postcode': zipCode,
        }
      },
    );

    final GraphQLClient client = GraphQLProvider.of(context).value;

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      final error = result.exception!.graphqlErrors.first.message;
      print("ADD ADDRESS ERROR::::: $error");
      final snackBar = CustomSnackbar.build(
        message: error,
        backgroundColor: AppThemeColor.primaryColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final Map<String, dynamic>? createAddress = result.data?['addAddress'];
      if (createAddress != null) {
        final snackBar = CustomSnackbar.build(
          message: "Address added successfully!",
          backgroundColor: AppThemeColor.primaryColor,
          onPressed: () {
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Get.back();
      } else {
        print('Adding address error: Invalid response data');
      }
    }
  }

  late String fetchAddressData;
  @override
  void initState() {
    super.initState();
    log("ADDRESS ID ${widget.id.toString()}");
    fetchAddressData = '''
      query Address {
        address(id: "${widget.id.toString()}") {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Update Shipping Address",
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xff222222)),
        ),
      ),
      body:
      Query(
        options: QueryOptions(document: gql(fetchAddressData)) ,
        builder: (QueryResult result, {Refetch? refetch, FetchMore? fetchMore} ){
          if(result.hasException){
            return Text(result.hasException.toString());
          }
          if(result.isLoading){
            return  Center(
              child: CircularProgressIndicator(
                color: AppThemeColor.primaryColor,
              ),
            );
          }
          final addressData = result.data?['address'];
          if(addressData != null){
            fNameController.text = addressData['fname'].toString();
            lNameController.text = addressData['lname'].toString();
            address1Controller.text = addressData['address1'].toString();
            cityController.text = addressData['city'].toString();
            zipCodeController.text = addressData['postcode'].toString();
          }
          return  Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  addHeight(20),
                  CommonTextFieldWidget(
                    controller: fNameController,
                    hint: "First Name",
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'Please Enter Your AddressType'),
                    ]),
                  ),
                  addHeight(15),
                  CommonTextFieldWidget(
                    controller: lNameController,
                    hint: "Last Name",
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'Please Enter Your Name'),
                    ]),
                  ),
                  addHeight(15),
                  CommonTextFieldWidget(
                    controller: address1Controller,
                    hint: "Address",
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'Please Enter Your Address 1'),
                    ]),
                  ),
                  addHeight(15),
                  CommonTextFieldWidget(
                    controller: cityController,
                    hint: "City",
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'Please Enter Your City'),
                    ]),
                  ),
                  addHeight(15),
                  CommonTextFieldWidget(
                    controller: zipCodeController,
                    hint: "ZipCode",
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'Please Enter Your ZipCode'),
                    ]),
                  ),
                  addHeight(30),

                  CommonButtonGreen(title: "UPDATE ADDRESS", onPressed: () {
                    updateAddressMutation(
                        id: widget.id.toString(),
                        fname: fNameController.text,
                        lname: lNameController.text,
                        address1: address1Controller.text,
                        city: cityController.text,
                        zipCode: zipCodeController.text);

                  },)
                ],
              ),
            ),
          );
        }

      ),
    );
  }
}
