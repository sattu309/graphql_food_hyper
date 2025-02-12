import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shop_app/helper/apptheme_color.dart';
import 'package:shop_app/helper/heigh_width.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../new_common_tab.dart';

class PayFastPaymentScreen extends StatefulWidget {
  final String url;
  final String authToken;

  const PayFastPaymentScreen({Key? key, required this.url, required this.authToken}) : super(key: key);

  @override
  _PayFastPaymentScreenState createState() => _PayFastPaymentScreenState();
}

class _PayFastPaymentScreenState extends State<PayFastPaymentScreen> {
  WebViewController? controller;
  bool webLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(

          // onHttpAuthRequest: (HttpAuthRequest request) => request.onProceed(
          //   const WebViewCredential(
          //     user: 'dem  ',
          //     password: '12345',
          //   ),
          // ),
          onNavigationRequest: (NavigationRequest request){
            if(request.url.contains("https://admin.fitgate.live/success")){
              Get.to(() => const MinimalExample());
                return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            setState(() {});
          },
          onPageFinished: (String url) {
            print('Navigated to: $url'); // Log the URL
            if (url.contains('https://sandbox.payfast.co.za/eng/process/finish')) {
              Navigator.pop(context, 'success');
            } else if (url.contains('failure-url')) {
              Navigator.pop(context, 'failure');
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url),headers: {"headers": 'Bearer ${widget.authToken}'}).then((value){

        setState(() {
          webLoaded = true;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text('Payment',style: Theme.of(context).textTheme.titleMedium,),
      ),
      body:
      webLoaded ?
      WebViewWidget(
          controller: controller!
      ) :Center(child: Column(
        children: [
          addHeight(50),
          Text('Please wait while redirecting',textAlign:TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
          CircularProgressIndicator(color: AppThemeColor.primaryColor,),
        ],
      )),
    );
  }
}
