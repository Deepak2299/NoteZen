import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void openSnacbar(_scaffoldKey, snacMessage) {
//  _scaffoldKey.currentState.showSnackBar(
//    SnackBar(
//      duration: Duration(milliseconds: 800),
//      content: Container(
//        alignment: Alignment.centerLeft,
//        height: 60,
//        child: Text(
//          snacMessage,
//          style: TextStyle(
//            fontSize: 14,
//          ),
//        ),
//      ),
//      action: SnackBarAction(
//        label: 'Ok',
//        textColor: Colors.blueAccent,
//        onPressed: () {},
//      ),
//    ),
//  );
  Fluttertoast.showToast(
    msg: snacMessage,
  );
}
