import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shop_app/screens/splash/splash_new_screen.dart';
import 'components/graphql_client.dart';
import 'controllers/session_controller.dart';
import 'routes.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeClient();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final sessionController = Get.put(SessionController());
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      'https://ecom.bitlogiq.co.za/graphql',
      defaultHeaders: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${sessionController.sessionId.value}'
      },
    );
    final AuthLink authLink = AuthLink(
      getToken: () async {
        final token = sessionController.sessionId.value;
        log("TESTING JWT TOKEN $token");
        if (token.isEmpty) {
          return null;
        }
        return 'Bearer $token';
      },
      headerKey: 'Authorization'
    );

    final Link link = authLink.concat(httpLink,);
      final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );
    return GraphQLProvider(
      client: GraphQlConfig.client,
      child: CacheProvider(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SuperMarket',
          theme: AppTheme.lightTheme(context),
          initialRoute: FoodSplash.routeName,
          routes: routes,
        ),
      ),
    );
  }
}