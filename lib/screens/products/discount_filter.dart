import 'package:flutter/material.dart';

import '../../helper/apptheme_color.dart';

class DiscountFilter extends StatefulWidget {
  const DiscountFilter({Key? key}) : super(key: key);

  @override
  State<DiscountFilter> createState() => _DiscountFilterState();
}

class _DiscountFilterState extends State<DiscountFilter> {
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      dataList.add({
        'title': "30% or more",
        "isChecked": false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent
      ),
      child: Column(
        children: [
          ExpansionTile(
            title: Text('DISCOUNT'),
            children: dataList.map((data) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      data["title"],
                      style: const TextStyle(color: Colors.black87),
                    ),
                    Checkbox(
                      activeColor: AppThemeColor.primaryColor,
                      value: data["isChecked"],
                      onChanged: (value) {
                        setState(() {
                          data["isChecked"] = value!;
                        });
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
