import 'package:flutter/material.dart';
import 'package:note_app/models/subscription_model.dart';
import 'package:note_app/screens/subscription/sub_notification.dart';
import 'package:note_app/screens/subscription/update_subscription.dart';

class SubscriptionDetail extends StatefulWidget {
  SubscriptionModel subscriptionModel;
  SubscriptionDetail({@required this.subscriptionModel});
  @override
  _SubscriptionDetailState createState() => _SubscriptionDetailState();
}

class _SubscriptionDetailState extends State<SubscriptionDetail> {
  int colorCode = Colors.green.value;
  String nextDate = "";
  getNextDate() {
    DateTime notificationDate =
        DateTime.parse(widget.subscriptionModel.firstPayment);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);
    final time = int.parse(widget.subscriptionModel.repeatTime);
    String res;
    if (widget.subscriptionModel.repeatType.contains("Day")) {
      int day = difference.inDays;
      int nextday = ((day / time).ceil() + 1) * time;
      nextDate = date2
          .add(Duration(days: nextday == 1 ? 2 : nextday))
          .toIso8601String()
          .substring(0, 10);
      print(day);
      print(nextday);
      setState(() {});
    } else if (widget.subscriptionModel.repeatType.contains("Week")) {
      int week = (difference.inDays / 7).floor();
      int nextweek = ((week / time).ceil() + 1) * time;

      nextDate = date2
          .add(Duration(days: nextweek * 7))
          .toIso8601String()
          .substring(0, 10);
      setState(() {});
    } else if (widget.subscriptionModel.repeatType.contains("Month")) {
      int month = (difference.inDays / 30).floor();
      int nextmonth = ((month / time).ceil() + 1) * time;
      nextDate = date2
          .add(Duration(days: nextmonth * 30))
          .toIso8601String()
          .substring(0, 10);
      setState(() {});
    } else if (widget.subscriptionModel.repeatType.contains("Year")) {
      int year = (difference.inDays / 356).floor();
      int nextyear = ((year / time).ceil() + 1) * time;
      nextDate = date2
          .add(Duration(days: nextyear * 365))
          .toIso8601String()
          .substring(0, 10);
      setState(() {});
    }
    print(nextDate);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.subscriptionModel.isOneTime) getNextDate();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("Subscription Detail"),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(widget.subscriptionModel.color),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    PopupMenuButton(
//                      color: Colors.white,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: TextButton.icon(
                                onPressed: null,
                                icon: Icon(
                                  Icons.edit,
//                                  color: Colors.black,
                                ),
                                label: Text(
                                  "Edit",
//                                  style: TextStyle(color: Colors.black),
                                )),
                            value: 0,
                          ),
                          PopupMenuItem(
                            child: TextButton.icon(
                                onPressed: null,
                                icon: Icon(
                                  Icons.notifications_active_outlined,
//                                  color: Colors.black,
                                ),
                                label: Text(
                                  "Notification",
//                                  style: TextStyle(color: Colors.black),
                                )),
                            value: 1,
                          ),
                        ];
                      },
                      icon: Icon(Icons.more_vert, color: Colors.black),
                      onSelected: (value) {
                        if (value == 0)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateSubscription(
                                  subscriptionModel: widget.subscriptionModel,
                                ),
                              ));
                        else
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SubscriptionNotification(),
                              ));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  widget.subscriptionModel.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                widget.subscriptionModel.desc.isNotEmpty
                    ? Text(
                        widget.subscriptionModel.desc,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "₹ " + widget.subscriptionModel.price,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          widget.subscriptionModel.isOneTime
              ? Column(
                  children: [
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 7, bottom: 3),
                        child: Text(
                          "Billing Period",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(0),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 2),
                        child: Text(
                          "every " +
                              widget.subscriptionModel.repeatTime +
                              " " +
                              widget.subscriptionModel.repeatType,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      visualDensity: VisualDensity(vertical: -4),
                    ),
                    Divider(color: Colors.grey[600]),
//          SizedBox(
//            height: 10,
//          ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 3),
                        child: Text(
                          "Next Payment",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(0),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 2),
                        child: Text(
                          nextDate,
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                      visualDensity: VisualDensity(vertical: -4),
                    ),
                    Divider(color: Colors.grey[600]),
//          SizedBox(
//            height: 10,
//          ),
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 3),
                        child: Text(
                          "First Payment",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(0),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 2),
                        child: Text(
                          widget.subscriptionModel.firstPayment
                              .substring(0, 10),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      visualDensity: VisualDensity(vertical: -4),
                    ),
                    Divider(color: Colors.grey[600]),
                  ],
                )
              : Column(
                  children: [
                    ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 3),
                        child: Text(
                          "Expiry Date",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      contentPadding: EdgeInsets.all(0),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 2),
                        child: Text(
                          widget.subscriptionModel.expiryDate.substring(0, 10),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      visualDensity: VisualDensity(vertical: -4),
                    ),
                    Divider(color: Colors.grey[600]),
                  ],
                ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 3),
              child: Text(
                "Payment method",
                style: TextStyle(fontSize: 18),
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 2),
              child: Text(
                widget.subscriptionModel.paymentMethod.isNotEmpty
                    ? widget.subscriptionModel.paymentMethod
                    : "No payment menthod",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            visualDensity: VisualDensity(vertical: -4),
          ),
          Divider(color: Colors.grey[600]),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 3),
              child: Text(
                "Notifications",
                style: TextStyle(fontSize: 18),
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "No Notificaion",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
//                  Text(
//                    "₹ 100",
//                    style: TextStyle(color: Colors.black38),
//                  )
                ],
              ),
            ),
            visualDensity: VisualDensity(vertical: -4),
          )
        ],
      ),
    );
  }
}
