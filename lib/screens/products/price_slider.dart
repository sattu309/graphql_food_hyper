import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_app/helper/apptheme_color.dart';

import '../../helper/dimentions.dart';

class PriceRangeSlider extends StatefulWidget {
  @override
  _PriceRangeSliderState createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  RangeValues _currentRangeValues = const RangeValues(0, 1000);
  double value =1000;
  int value1 = 1;

  @override
  Widget build(BuildContext context) {
    return
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 1.0,
            activeTrackColor: AppThemeColor.primaryColor,
            inactiveTrackColor: Colors.grey,
            thumbColor: AppThemeColor.primaryColor,
            overlayColor: AppThemeColor.primaryColor.withAlpha(32),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0,elevation: 2),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
          ),
          child: RangeSlider(
            values: _currentRangeValues,
            min: 0,
            max: 1000,

            labels: RangeLabels(value.toString(),value.toString()),
            // RangeLabels(
            //   _currentRangeValues.start.round().toString(),
            //   _currentRangeValues.end.round().toString(),
            // ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
                log(values.toString());
              });
            },
          ),
        ),

        // SizedBox(
        //   height: 40,
        //   width: AddSize.screenWidth,
        //   child: Row(
        //     children: [
        //       SliderTheme(
        //         data: SliderTheme.of(context).copyWith(
        //           showValueIndicator: ShowValueIndicator.onlyForDiscrete,
        //           trackHeight: 8.0,
        //           trackShape: const RoundedRectSliderTrackShape(),
        //           activeTrackColor: const Color(0xff6CD241),
        //           inactiveTrackColor: const Color(0xFF7ED957).withOpacity(0.12),
        //           thumbShape: const RoundSliderThumbShape(
        //             enabledThumbRadius: 7.0,
        //             pressedElevation: 8.0,
        //           ),
        //           thumbColor: Colors.white,
        //           overlayColor: const Color(0xFF7ED957).withOpacity(0.12),
        //           overlayShape: const RoundSliderOverlayShape(overlayRadius: 2.0),
        //           tickMarkShape: const RoundSliderTickMarkShape(),
        //           activeTickMarkColor: const Color(0xff6CD241),
        //           inactiveTickMarkColor: Colors.transparent,
        //           valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        //           valueIndicatorColor: const Color(0xff6CD241),
        //           valueIndicatorTextStyle: const TextStyle(
        //             color: Colors.white,
        //             fontSize: 20.0,
        //           ),
        //         ),
        //         child: Expanded(
        //           child: Slider(
        //             min: 1.0,
        //             max: 1000,
        //             autofocus: true,
        //             value: value,
        //             divisions: 14,
        //             label: '${value.round()} Km',
        //             onChanged: (value) {
        //               setState(() {
        //                 value = value;
        //                 value1 = value.toInt();
        //                 print("Delivery Rang iss $value1");
        //               });
        //             },
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(left: 12,right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('\$${_currentRangeValues.start.round()}'),
              Text('\$${_currentRangeValues.end.round()}'),
            ],
          ),
        ),
      ],
    );
  }
}

