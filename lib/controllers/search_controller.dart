import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../components/graphql_client.dart';

class ProductSearchController extends GetxController{
  final TextEditingController keyWordText= TextEditingController();
  var getSearchData = [].obs;
  var itemData = [].obs;
  RxBool isLoading = false.obs;
  Future<void> searchMutation(String keyWord,context) async {
    final GraphQLClient client = initializeClient();
     isLoading.value = true;
    try{
      final MutationOptions options = MutationOptions(
        document: gql('''
  query Products(\$search: String!) {
        products(where: { search: \$search }) {
        edges {
            node {
                id
                databaseId
                name
                sku
                slug
                  image {
                        sourceUrl
                    }
                type
                ... on VariableProduct {
                    id
                    name
                    price
                    regularPrice
                    salePrice
                    sku
                   averageRating
                  reviewCount
                  sku
                  stockStatus
                }
                ... on SimpleProduct {
                    id
                    name
                    price
                    regularPrice
                    salePrice
                         averageRating
                        reviewCount
                        sku
                        stockStatus
                }
            }
        }
    }
}

  '''),
        variables: {
          'search': keyWord,
        },
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        List<String> errorMessages = [];

        if (result.exception!.graphqlErrors.isNotEmpty) {
          errorMessages =
              result.exception!.graphqlErrors.map((e) => e.message).toList();
        }

        if (result.exception!.linkException != null) {
          errorMessages.add(result.exception!.linkException.toString());
        }
        print("Search ERROR::::: $errorMessages");

      }
      else {
        final List<dynamic>? searchData = result.data?['products']['edges'];
        if (searchData != null) {
          getSearchData.value = searchData;
          isLoading.value = false;
          print("SEARCH RESPONSE $getSearchData}");

        } else {
          print('SEARCH RESPONSE: Invalid response data');
        }
      }
    }catch(e){
      print("Exception during search: $e");
    }finally {
      isLoading.value = false; // Set loading to false when search ends
    }
  }
  Timer? debounce;
  void onSearchChanged(String query, BuildContext context) {
    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }
    getSearchData.clear();
    debounce = Timer(const Duration(microseconds: 200), () {
      searchMutation(query, context);
    });
  }

}
