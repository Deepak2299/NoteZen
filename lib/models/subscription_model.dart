// To parse this JSON data, do
//
//     final subscriptionModel = subscriptionModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class SubscriptionModel {
  SubscriptionModel({
    @required this.id,
    @required this.name,
    @required this.desc,
    @required this.price,
    @required this.color,
    @required this.paymentMethod,
    @required this.isOneTime,
    @required this.expiryDate,
    @required this.repeatTime,
    @required this.repeatType,
    @required this.firstPayment,
    @required this.notification,
    @required this.createdAt,
  });

  String id;
  String name;
  String desc;
  String price;
  int color;
  String paymentMethod;
  bool isOneTime;
  String expiryDate;
  String repeatTime;
  String repeatType;
  String firstPayment;
  String notification;
  String createdAt;

  factory SubscriptionModel.fromJson(String str) =>
      SubscriptionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubscriptionModel.fromMap(Map<dynamic, dynamic> json) =>
      SubscriptionModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        desc: json["desc"] == null ? null : json["desc"],
        price: json["price"] == null ? null : json["price"],
        color: json["color"] == null ? null : json["color"],
        paymentMethod:
            json["paymentMethod"] == null ? null : json["paymentMethod"],
        isOneTime: json["isOneTime"] == null ? null : json["isOneTime"],
        expiryDate: json["expiryDate"] == null ? null : json["expiryDate"],
        repeatTime: json["repeatTime"] == null ? null : json["repeatTime"],
        repeatType: json["repeatType"] == null ? null : json["repeatType"],
        firstPayment:
            json["firstPayment"] == null ? null : json["firstPayment"],
        notification:
            json["notification"] == null ? null : json["notification"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "desc": desc == null ? null : desc,
        "price": price == null ? null : price,
        "color": color == null ? null : color,
        "paymentMethod": paymentMethod == null ? null : paymentMethod,
        "isOneTime": isOneTime == null ? null : isOneTime,
        "expiryDate": expiryDate == null ? null : expiryDate,
        "repeatTime": repeatTime == null ? null : repeatTime,
        "repeatType": repeatType == null ? null : repeatType,
        "firstPayment": firstPayment == null ? null : firstPayment,
        "notification": notification == null ? null : notification,
        "createdAt": createdAt == null ? null : createdAt,
      };
}
