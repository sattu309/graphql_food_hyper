import 'package:flutter/material.dart';

import '../helper/apptheme_color.dart';
import '../helper/heigh_width.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title:  Text("Notification",style: Theme.of(context).textTheme.titleMedium,),
        ),
        body:
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * .005),
            child: Column(
              children: [
                ListView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return notificationList(
                        "Date - 08-05-2024",
                        "Order Placed",
                        "Your order has been placed.");

                          // controller.model.value.data!.notificationData![index].time.toString(),
                          // controller.model.value.data!.notificationData![index].title.toString(),
                          // controller.model.value.data!.notificationData![index].body.toString());
                    }),


              ],
            ),
          ),
        )
    );
  }

  Widget notificationList(date, title, description) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(left: 5,right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      // margin: const EdgeInsets.only(left: 5, right: 5),
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Card(
        elevation: 0,
        child: Row(
          children: [
            SizedBox(
              width: width * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * .005,
              ),
              child: Container(
                width: width * .010,
                height: height * .08,
                decoration:  BoxDecoration(
                  color: AppThemeColor.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
            ),
            SizedBox(
              width: width * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                height: height * .05,
                width: width * .10,
                decoration:  ShapeDecoration(
                    color: AppThemeColor.primaryColor, shape: CircleBorder()),
                child: Center(
                    child: Text(
                      "F",style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    addHeight(6),
                    Text(
                      date,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color:  Color(0xffC33D18),
                        fontSize: 12,
                      ),
                    ),
                    addHeight(6),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(0xff000000),
                        fontSize: 13,
                      ),
                    ),
                    //textBold(snapshot.data!.data.notifications[index].title),
                    addHeight(6),
                    Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppThemeColor.subText,
                        fontSize: 12,
                      ),
                    ),
                    addHeight(6),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
// return loader(context);
}
//);
// }
//}