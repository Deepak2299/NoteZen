import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/subscription_model.dart';
import 'package:note_app/providers/notification_service.dart';
import 'package:note_app/providers/signinprovider.dart';
import 'package:note_app/screens/homescreen.dart';
import 'package:note_app/screens/subscription/sub_reminder.dart';
import 'package:note_app/utils/colors.dart';
import 'package:note_app/utils/constants.dart';
import 'package:provider/provider.dart';

class UpdateSubscription extends StatefulWidget {
  SubscriptionModel subscriptionModel;
  UpdateSubscription({@required this.subscriptionModel});
  @override
  _UpdateSubscriptionState createState() => _UpdateSubscriptionState();
}

class _UpdateSubscriptionState extends State<UpdateSubscription> {
  var _key = GlobalKey<FormState>();
  TextEditingController payController;
  TextEditingController nameController;
  TextEditingController descController;
  TextEditingController payMethodController;
  TextEditingController everyController;
  TextEditingController firstController;
  TextEditingController expiryController;
  DateTime firstDate, expiryDate;
  bool tab = true, loading = false;
  String repeatTime = "Day";
  int colorCode = Colors.white.value;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    payController = TextEditingController(text: widget.subscriptionModel.price);
    nameController = TextEditingController(text: widget.subscriptionModel.name);
    descController =
        TextEditingController(text: widget.subscriptionModel.desc ?? "");
    payMethodController = TextEditingController(
        text: widget.subscriptionModel.paymentMethod ?? "");
    everyController =
        TextEditingController(text: widget.subscriptionModel.repeatTime ?? "");
    firstDate = widget.subscriptionModel.firstPayment != null
        ? DateTime.parse(widget.subscriptionModel.firstPayment)
        : null;
    firstController = TextEditingController(
        text: firstDate == null
            ? null
            : DateFormat('yyyy-MM-dd').format(firstDate));
    expiryDate = widget.subscriptionModel.expiryDate != null
        ? DateTime.parse(widget.subscriptionModel.expiryDate)
        : null;
    expiryController = TextEditingController(
        text: expiryDate == null
            ? null
            : DateFormat('yyyy-MM-dd').format(expiryDate));
    tab = widget.subscriptionModel.isOneTime;
    repeatTime = widget.subscriptionModel.repeatType ?? "Day";
    colorCode = widget.subscriptionModel.color;
  }

  showColorFilterDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Color"),
          content: Container(
//            height: 200,
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
//                height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: colors.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              colorCode = colors[index].value;
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            height: 33,
                            width: 33,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors[index],
                                border: Border.all(
                                    color: Colors.black38, width: 0.5)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Subscription'),
        actions: [
          TextButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                final CollectionReference ref = Firestore.instance
                    .collection('subscription')
                    .document(
                        Provider.of<SignInProvider>(context, listen: false).uid)
                    .collection("subscriptions");
                var id = ref.document().documentID;
                NotificationService().cancelNotificationForSubscription(
                  widget.subscriptionModel,
                );
//                    Provider.of<NoteProvider>(context, listen: false).addNotes(
                await ref.document(widget.subscriptionModel.id).delete();
                setState(() {
                  loading = false;
                });
//                  Provider.of<NoteProvider>(context, listen: false)
//                      .deleteNotes(widget.index);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                    (route) => false);
              },
              child: Text(
                "Delete",
                style: labelStyle.copyWith(
                    color: Theme.of(context).appBarTheme.iconTheme.color),
              ))
        ],
      ),
      body: Form(
        key: _key,
        child: Container(
            width: double.maxFinite,
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.all(20),
                  shrinkWrap: true,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color(colorCode),
                          border:
                              Border.all(color: Colors.grey[800], width: 0.5),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: payController,
                              textAlign: TextAlign.center,
                              validator: (value) {
                                if (value.isEmpty)
                                  return "This field is required";
                                return null;
                              },
                              maxLength: 10,
                              style: TextStyle(
                                  fontSize: 50,
                                  letterSpacing: 2,
                                  color: Colors.black),
                              keyboardType: TextInputType.number,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                hintText: "0.00",
                                hintStyle: TextStyle(
                                    fontSize: 40,
                                    letterSpacing: 2,
                                    color: Colors.grey[600]),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                counterText: "",
                              ),
                            ),
                            Text(
                              'INR',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'Name',
                        style: labelStyle,
                      ),
                    ),
                    TextFormField(
//                autovalidate: true,
                      controller: nameController,
                      validator: (value) {
                        if (value.isEmpty) return "This field is required";
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      enableSuggestions: false,
                      decoration: inputTextDecoration("e.g. Netflix"),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Description',
                        style: labelStyle,
                      ),
                    ),
                    TextFormField(
                      controller: descController,
                      keyboardType: TextInputType.text,
                      enableSuggestions: false,
                      decoration: inputTextDecoration("e.g. Preminum plan"),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(color: Colors.grey[600]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  tab = true;
                                });
                              },
                              child: Text(
                                'Recurring',
                                style: TextStyle(
                                    color: tab
                                        ? Theme.of(context)
                                            .appBarTheme
                                            .iconTheme
                                            .color
                                        : Colors.grey[600],
                                    fontSize: 18),
                              )),
                        ),
//                  Spacer(),
                        Center(
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  tab = false;
                                });
                              },
                              child: Text(
                                'One Time',
                                style: TextStyle(
                                    color: !tab
                                        ? Theme.of(context)
                                            .appBarTheme
                                            .iconTheme
                                            .color
                                        : Colors.grey[600],
                                    fontSize: 18),
                              )),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: tab
                          ? [
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  'Billing Period',
                                  style: labelStyle,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Every',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: TextFormField(
//                                autovalidate: true,
                                      controller: everyController,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "This field is required";
                                        return null;
                                      },
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
                                      items: ["Day", "Week", "Month", "Year"]
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
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  'First payment',
                                  style: labelStyle,
                                ),
                              ),
                              TextFormField(
//                          autovalidate: true,
                                controller: firstController,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return "This field is required";
                                  return null;
                                },
                                keyboardType: TextInputType.datetime,
                                enableSuggestions: false,
                                decoration:
                                    inputTextDecoration("e.g. yyyy-mm-dd"),
                                onTap: () async {
                                  FocusScope.of(context).unfocus();

                                  firstDate = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          DateTime.now().add(Duration(days: 1)),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2100));
                                  firstController.text = firstDate == null
                                      ? null
                                      : DateFormat('yyyy-MM-dd')
                                          .format(firstDate);
                                  setState(() {});
                                },
                              ),
                            ]
                          : [
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  'Expiry Date',
                                  style: labelStyle,
                                ),
                              ),
                              TextFormField(
                                  controller: expiryController,
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return "This field is required";
                                    return null;
                                  },
                                  keyboardType: TextInputType.datetime,
                                  enableSuggestions: false,
                                  decoration:
                                      inputTextDecoration("e.g. yyyy-mm-dd"),
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();

                                    expiryDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now()
                                            .add(Duration(days: 1)),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100));
                                    expiryController.text = expiryDate == null
                                        ? null
                                        : DateFormat('yyyy-MM-dd')
                                            .format(expiryDate);
                                    setState(() {});
                                  }),
                            ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: Colors.grey[600],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Payment Method',
                        style: labelStyle,
                      ),
                    ),
                    TextFormField(
//                autovalidate: true,
                      controller: payMethodController,
                      keyboardType: TextInputType.text,
                      enableSuggestions: false,
                      decoration: inputTextDecoration("e.g. Credit Card"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        color: Color(colorCode),
                        onPressed: () {
                          showColorFilterDialog();
                        },
                        child: Text(
                          'Select Color',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
//                        fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.black,
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (_key.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            final CollectionReference ref = Firestore.instance
                                .collection('subscription')
                                .document(Provider.of<SignInProvider>(context,
                                        listen: false)
                                    .uid)
                                .collection("subscriptions");
                            var id = ref.document().documentID;
//                    Provider.of<NoteProvider>(context, listen: false).addNotes(
                            SubscriptionModel subscriptionModel =
                                SubscriptionModel(
                              id: widget.subscriptionModel.id,
                              name: nameController.text,
                              desc: descController.text,
                              color: colorCode,
                              price: payController.text,
                              isOneTime: tab,
                              repeatTime: everyController.text,
                              repeatType: repeatTime,
                              paymentMethod: payMethodController.text,
                              firstPayment: firstDate?.toIso8601String(),
                              expiryDate: expiryDate?.toIso8601String(),
                              createdAt: widget.subscriptionModel.createdAt,
                            );
                            NotificationService()
                                .cancelNotificationForSubscription(
                              subscriptionModel,
                            );
                            NotificationService()
                                .scheduleNotificationForBirthday(
                              subscriptionModel,
                            );
                            await ref
                                .document(widget.subscriptionModel.id)
                                .updateData(subscriptionModel.toMap());
//                    );
                            setState(() {
                              loading = false;
                            });
//                  Provider.of<NoteProvider>(context, listen: false)
//                      .deleteNotes(widget.index);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                                (route) => false);
                          }
                        },
                        child: Text(
                          'Update',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
                loading
                    ? Container(
                        color: Colors.black54,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellowAccent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
//                      backgroundColor: Colors.yellowAccent,
//                        strokeWidth: 10,

                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.teal),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            )),
      ),
    );
  }
}
