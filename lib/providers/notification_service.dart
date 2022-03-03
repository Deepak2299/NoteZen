import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:note_app/models/subscription_model.dart';
import 'package:note_app/utils/constants.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channel_id = "123";

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    tz.initializeTimeZones();
  }

  Future selectNotification(String payload) async {
    SubscriptionModel subscriptionModel = getSubscriptionFromPayload(payload);
    cancelNotificationForSubscription(subscriptionModel);
    if (subscriptionModel.isOneTime)
      scheduleNotificationForBirthday(
        subscriptionModel,
      );
  }

  void showNotification(SubscriptionModel subscriptionModel) async {
    await flutterLocalNotificationsPlugin.show(
        subscriptionModel.hashCode,
        applicationName,
        "₹ " + subscriptionModel.price,
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, applicationName,
                'To remind you about upcoming birthdays')),
        payload: subscriptionModel.toJson());
  }

  void scheduleNotificationForBirthday(
    SubscriptionModel subscriptionModel,
  ) async {
    DateTime nextDate;
    if (subscriptionModel.isOneTime) {
      DateTime notificationDate =
          DateTime.parse(subscriptionModel.firstPayment);
      final date2 = DateTime.now();
      final difference = date2.difference(notificationDate);
      final time = int.parse(subscriptionModel.repeatTime);

      if (subscriptionModel.repeatType.contains("Day")) {
        int day = difference.inDays;
        int nextday = ((day / time).ceil() + 1) * time;
        nextDate = date2.add(Duration(days: nextday == 1 ? 2 : nextday));
      } else if (subscriptionModel.repeatType.contains("Week")) {
        int week = (difference.inDays / 7).floor();
        int nextweek = ((week / time).ceil() + 1) * time;

        nextDate = date2.add(Duration(days: nextweek * 7));
      } else if (subscriptionModel.repeatType.contains("Month")) {
        int month = (difference.inDays / 30).floor();
        int nextmonth = ((month / time).ceil() + 1) * time;
        nextDate = date2.add(Duration(days: nextmonth * 30));
      } else if (subscriptionModel.repeatType.contains("Year")) {
        int year = (difference.inDays / 356).floor();
        int nextyear = ((year / time).ceil() + 1) * time;
        nextDate = date2.add(Duration(days: nextyear * 365));
      }
    } else {
      nextDate = DateTime.parse(subscriptionModel.expiryDate);
    }

    DateTime now = DateTime.now();

    Duration differences = now.isAfter(nextDate)
        ? now.difference(nextDate)
        : nextDate.difference(now);

    _wasApplicationLaunchedFromNotification()
        .then((bool didApplicationLaunchFromNotification) => {
              if (didApplicationLaunchFromNotification &&
                  differences.inDays == 0)
                {
//                  scheduleNotificationForNextYear(
//                      userBirthday, notificationMessage)
                }
              else if (!didApplicationLaunchFromNotification &&
                  differences.inDays == 0)
                {showNotification(subscriptionModel)}
            });

    await flutterLocalNotificationsPlugin.zonedSchedule(
        subscriptionModel.hashCode,
        applicationName,
        "₹ " + subscriptionModel.price,
        tz.TZDateTime.now(tz.local).add(differences),
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, applicationName,
                'To remind you about upcoming birthdays')),
        payload: subscriptionModel.toJson(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

//  void scheduleNotificationForNextYear(
//      UserBirthday userBirthday, String notificationMessage) async {
//    await flutterLocalNotificationsPlugin.zonedSchedule(
//        userBirthday.hashCode,
//        applicationName,
//        notificationMessage,
//        tz.TZDateTime.now(tz.local).add(new Duration(days: 365)),
//        const NotificationDetails(
//            android: AndroidNotificationDetails(channel_id, applicationName,
//                'To remind you about upcoming birthdays')),
//        payload: jsonEncode(userBirthday),
//        androidAllowWhileIdle: true,
//        uiLocalNotificationDateInterpretation:
//            UILocalNotificationDateInterpretation.absoluteTime);
//  }

  void cancelNotificationForSubscription(
      SubscriptionModel subscriptionModel) async {
    await flutterLocalNotificationsPlugin.cancel(subscriptionModel.hashCode);
  }

  void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  void handleApplicationWasLaunchedFromNotification() async {
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails.didNotificationLaunchApp) {
      SubscriptionModel subscriptionModel =
          getSubscriptionFromPayload(notificationAppLaunchDetails.payload);
      cancelNotificationForSubscription(subscriptionModel);
      if (subscriptionModel.isOneTime)
        scheduleNotificationForBirthday(subscriptionModel);
    }
  }

  SubscriptionModel getSubscriptionFromPayload(String payload) {
//    Map<String, dynamic> json = jsonDecode(payload);
    SubscriptionModel subscriptionModel = SubscriptionModel.fromJson(payload);
    return subscriptionModel;
  }

  Future<bool> _wasApplicationLaunchedFromNotification() async {
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    return notificationAppLaunchDetails.didNotificationLaunchApp;
  }
}
