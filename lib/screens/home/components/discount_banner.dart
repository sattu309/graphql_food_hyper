import 'package:flutter/material.dart';
import 'package:shop_app/helper/apptheme_color.dart';


class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: (){
          // Navigator.push(context, MaterialPageRoute(builder: (context){
          //   return Testpage();
          // }));
        },
        child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: AppThemeColor.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text.rich(
          TextSpan(
            style: TextStyle(color: Colors.white),
            children: [
              TextSpan(text: "A Summer Surpise\n"),
              TextSpan(
                text: "Cashback 20%",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
            ),
      );
  }
}
