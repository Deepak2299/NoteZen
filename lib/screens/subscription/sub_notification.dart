import 'package:flutter/material.dart';
import 'package:note_app/utils/constants.dart';

class SubscriptionNotification extends StatefulWidget {
  @override
  _SubscriptionNotificationState createState() =>
      _SubscriptionNotificationState();
}

class _SubscriptionNotificationState extends State<SubscriptionNotification> {
  TextEditingController everyController = TextEditingController();
  TextEditingController timeController =
      TextEditingController(text: "14:05 PM");
//  TextEditingController expiryController = TextEditingController();
  bool tab = true;
  String repeatTime = "Day";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text("Notification"),
      ),
      body: Container(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: [
            RadioListTile(
              value: true,
              groupValue: tab,
              onChanged: (value) {
                setState(() {
                  tab = value;
                });
              },
              title: Text("On the Same day"),
            ),
            RadioListTile(
              value: false,
              groupValue: tab,
              onChanged: (value) {
                setState(() {
                  tab = value;
                });
              },
              title: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: TextFormField(
//                                autovalidate: true,
                      controller: everyController,

                      keyboardType: TextInputType.number,
                      enableSuggestions: false,
                      decoration: inputTextDecoration("1"),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      items: ["Day"]
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      value: repeatTime,
                      onChanged: (String val) {
                        repeatTime = val;
                        setState(() {});
                      },
                      decoration: inputTextDecoration(""),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Time',
                style: labelStyle,
              ),
            ),
//          SizedBox(
//            width: 50,
//            child: TextFormField(
//              controller: timeController,
//              keyboardType: TextInputType.text,
//              enableSuggestions: false,
//              decoration: inputTextDecoration("e.g. 14:05 PM"),
//            ),
//          ),
            SizedBox(
              width: 100,
              child: Container(
                width: 200,
//              height: 20,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12),
                child: Text(
                  "15:30 PM",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.maxFinite,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.black,
                onPressed: () {
                  FocusScope.of(context).unfocus();
//                if (_key.currentState.validate()) {}
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
