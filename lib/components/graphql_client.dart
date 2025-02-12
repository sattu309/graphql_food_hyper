import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../controllers/session_controller.dart';


late GraphQLClient client;
GraphQLClient initializeClient() {
  final sessionController = Get.put(SessionController());

  final HttpLink httpLink = HttpLink('https://ecom.bitlogiq.co.za/graphql',
    defaultHeaders: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sessionController.sessionId.value}'
    },
  );
  return client = GraphQLClient(
    cache: GraphQLCache(store: InMemoryStore()),
    link: httpLink,
    alwaysRebroadcast: true,

  );

}
final sessionController = Get.put(SessionController());
class GraphQlConfig{

  static final HttpLink httpLink = HttpLink('https://ecom.bitlogiq.co.za/graphql');

  // define authentication handler here
  static final AuthLink authLink = AuthLink(
      getToken: () async {
        return 'Bearer ${sessionController.sessionId.value}';
      }
  );

  // add the httpLiknk to auth link
  // we create the final link to use
  static final Link link = authLink.concat(httpLink);

  // create a valueNotifier of type GraphqlClient
  static final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ));


}

