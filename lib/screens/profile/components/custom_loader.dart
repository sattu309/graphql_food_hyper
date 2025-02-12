import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final Color loaderColor;
  final double loaderSize;

  const CustomLoader({
    Key? key,
    this.loaderColor = Colors.deepOrangeAccent,
    this.loaderSize = 30.0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: loaderSize,
        height: loaderSize,
        child:
        // Center(
        //   child: Lottie.asset('assets/images/animation.json'),
        // ),
        CircularProgressIndicator(
          strokeWidth: 4.0,
          valueColor: AlwaysStoppedAnimation(loaderColor),
        ),
      ),
    );
  }
}
