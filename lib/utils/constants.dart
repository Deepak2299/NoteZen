import 'package:flutter/material.dart';

inputTextDecoration(String hintText) {
  return InputDecoration(
      fillColor: Colors.grey[500],
      filled: true,
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white30, fontSize: 15),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      border: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none),
      errorBorder: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none),
      focusedErrorBorder: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          gapPadding: 0,
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none));
}

inputTextDecorationWithLabel(String label, BuildContext context) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
        color: Theme.of(context).appBarTheme.iconTheme.color, fontSize: 20),
    border: OutlineInputBorder(
      borderSide: BorderSide(
          color: Theme.of(context).appBarTheme.iconTheme.color.withOpacity(0.8),
          width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: Theme.of(context).appBarTheme.iconTheme.color.withOpacity(0.8),
          width: 1),
    ),
  );
}

//inputTextDecorationWithLabelPassword(String label,BuildContext context){
//  return InputDecoration(
//      labelText: 'Password',
//      labelStyle: TextStyle(
//          color: Theme.of(context).appBarTheme.iconTheme.color,
//          fontSize: 20),
//      border: OutlineInputBorder(
//        borderSide: BorderSide(
//            color: Theme.of(context)
//                .appBarTheme
//                .iconTheme
//                .color
//                .withOpacity(0.8),
//            width: 1),
//      ),
//      errorBorder: OutlineInputBorder(
//        borderSide: BorderSide(color: Colors.red, width: 1),
//      ),
//      focusedBorder: OutlineInputBorder(
//        borderSide: BorderSide(
//            color: Theme.of(context)
//                .appBarTheme
//                .iconTheme
//                .color
//                .withOpacity(0.8),
//            width: 1),
//      ),
//      focusColor: Theme.of(context)
//          .appBarTheme
//          .iconTheme
//          .color
//          .withOpacity(0.8),
//      fillColor: Theme.of(context)
//          .appBarTheme
//          .iconTheme
//          .color
//          .withOpacity(0.8),
//      suffixIcon: IconButton(
//          icon: Icon(
//            isObscure
//                ? Icons.visibility_off
//                : Icons.remove_red_eye,
//            color: Theme.of(context)
//                .appBarTheme
//                .iconTheme
//                .color
//                .withOpacity(0.8),
//          ),
//          onPressed: () {
//            setState(() {
//              isObscure = !isObscure;
//            });
//          }));
//}

TextStyle labelStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w500);

const String applicationName = "NoteZen";
