import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/screens/search/search_screen.dart';

import '../../../constants.dart';
import '../../../controllers/search_controller.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final searchController = Get.put(ProductSearchController());

  @override
  void dispose() {
    super.dispose();
    searchController.keyWordText.clear();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return
      Form(
        child: Container(
          height: 40,
          width: width * .72,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade100),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child:

          TextFormField(
            controller: searchController.keyWordText,
            onFieldSubmitted: (value) {
              if (searchController.keyWordText.text.isNotEmpty) {
                searchController.onSearchChanged(value, context);
                searchController.searchMutation(
                    searchController.keyWordText.text.toString(), context);
                pushScreen(context, screen: const SearchPage(), withNavBar: true,replaceCurrent: true);
                setState(() {});
              }
            },

            onChanged: (value) {
              searchController.onSearchChanged(value, context);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              border: searchOutlineInputBorder,
              focusedBorder: searchOutlineInputBorder,
              enabledBorder: searchOutlineInputBorder,
              hintText: "Search by products, brand & more...",
              hintStyle: TextStyle(fontSize: 12),
              prefixIcon:
              IconButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus!.unfocus();
                  if (searchController.keyWordText.text.isNotEmpty) {
                    pushScreen(context, screen: const SearchPage(), withNavBar: true,);
                    searchController.searchMutation(
                        searchController.keyWordText.text.toString(), context);
                    setState(() {});
                  }
                },
                icon: Icon(
                  Icons.search,
                  color: AppThemeColor.primaryColor,
                ),
              ),
            ),
          )

        ),
      );

  }
}

class SearchField1 extends StatelessWidget {
  const SearchField1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Form(
      child: Container(
        height: 40,
        width: width * .60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade100),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextFormField(
          onChanged: (value) {},
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            border: searchOutlineInputBorder,
            focusedBorder: searchOutlineInputBorder,
            enabledBorder: searchOutlineInputBorder,
            hintText: "Coupon code",
          ),
        ),
      ),
    );
  }
}

OutlineInputBorder searchOutlineInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: Colors.transparent,
    ));
