import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/subscription_model.dart';
import 'package:note_app/providers/signinprovider.dart';
import 'package:note_app/screens/subscription/add_subscription.dart';
import 'package:note_app/screens/subscription/sub_details.dart';
import 'package:provider/provider.dart';

class SubscriptionReminder extends StatefulWidget {
  @override
  _SubscriptionReminderState createState() => _SubscriptionReminderState();
}

class _SubscriptionReminderState extends State<SubscriptionReminder> {
  buildView(List<dynamic> documentList) {
    List<dynamic> subsList = [];
    for (int i = 0; i < documentList.length; i++) {
      subsList.add(SubscriptionModel.fromMap(
          new Map<dynamic, dynamic>.from(documentList[i].data)));
    }
    return ListView.builder(
//      padding: EdgeInsets.all(12),
      shrinkWrap: true,
      itemCount: subsList.length,
      itemBuilder: (context, index) {
        bool isExpiry = false;
        if (!subsList[index].isOneTime) {
          DateTime notificationDate =
              DateTime.parse(subsList[index].expiryDate);
          final date2 = DateTime.now();
          final difference = date2.difference(notificationDate);
          if (!difference.isNegative) {
            isExpiry = true;
          }
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriptionDetail(
                    subscriptionModel: subsList[index],
                  ),
                ));
          },
          child: Container(
            height: 80,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.black38, width: 0.7)),
              color: Color(subsList[index].color),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              subsList[index].name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                            Text("₹ " + subsList[index].price,
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black))
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          subsList[index].desc,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  isExpiry
                      ? Container(
//                              height: double.infinity,
                          height: 75,
                          decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            heightFactor: 1,
                            child: Text(
                              "Expiry",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color(subsList[index].color)),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.white,
      appBar: AppBar(
//        backgroundColor: Colors.white,
        elevation: 2,
        title: Text('Subsciption Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('subscription')
              .document(Provider.of<SignInProvider>(context, listen: false).uid)
              .collection("subscriptions")
              .snapshots(),
          builder: (context, snapshots) {
            if (snapshots.data == null)
              return Center(
                child: CircularProgressIndicator(),
              );

            return snapshots.data.documents.length > 0
                ? buildView(snapshots.data.documents)
                : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/no_data.png",
                          scale: 5,
                        ),
                        Text("No Data")
                      ],
                    ),
                  );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddSubscription(),
              ));
        },
      ),
    );
  }
}
