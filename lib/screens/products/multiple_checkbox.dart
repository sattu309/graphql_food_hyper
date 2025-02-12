
import 'package:flutter/material.dart';
import 'package:shop_app/helper/apptheme_color.dart';

class MultipleCheckboxScreen extends StatefulWidget {
  const MultipleCheckboxScreen({super.key, required this.title});

  final String title;

  @override
  State<MultipleCheckboxScreen> createState() => _MultipleCheckboxScreenState();
}

class _MultipleCheckboxScreenState extends State<MultipleCheckboxScreen> {

  List<Map<String,dynamic>> dataList=[];

  @override
  void initState() {
    super.initState();

    for(int i=0;i<5;i++){
      dataList.add({
        "title":"PUMA",
        "isChecked":false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          ExpansionTile(
            title: Text('BRAND'),
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
        ]
        );

  }
}