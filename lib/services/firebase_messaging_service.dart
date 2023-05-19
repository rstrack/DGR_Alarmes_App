import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//id strackinado@gmail.com:
//eKl2sp_lQJCKqO7IsRm7Zw:APA91bH0aa3B3HUzUs8CuXos7KmbV97F5tPRrQhLbZ5Ib6Bz5L00Xg5fZgit_5QTVtHD7GMi0ZDkx4nA5fohHM93_3o1lXf2B4eoMJxaGIuiURkH_iR6cwMo3XKEJiJS3GInDE30bQ6n

class FirebaseMessagingService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // initInfo() {
  //   const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const initializationSettings = InitializationSettings(android: android);
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: _onSelectNotification);
  // }

  Future<void> initialize(BuildContext context) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: android);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);

    await requestPermission();

    //Ta sendo usado o aplicativo
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );
    //esse token tem que salvar no bd, cada cel tem um.
    getDeviceFirebaseToken();
    _onMessage();
  }

  //precisa ler os tokens.
  getDeviceFirebaseToken() async {
    final token = await FirebaseMessaging.instance
        .getToken(); //=> Esse dado tem q salvar no bd
    debugPrint("TOKEN: $token");
    return token;
  }

  //Captura a mensagme de notific enquanto o usuario ta usando OU background - tem 3 modos que o usuario pode receber notificacao.
  _onMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContent: true,
      );
      AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'dgr',
        'dgr',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['title']);
    });
  }

  _onSelectNotification(String? payload) async {
    if (payload != null && payload.isNotEmpty) {
      // Navigator.of(context)
    }
    return;
  }

  requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    return await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  // void sendPushMessage(String token, String body, String title) async {
  //   try {
  //     await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json',
  //           'Authorization':
  //               'key=AAAAsUg9Aqs:APA91bFn3OSDNm-0rm2v5Fr6vQwVYjNOdRVy0E6zKzeeOUwWkw-qyQgpsTCM_ZlomKmsa549twhZmw2vGCEYNT9dtoEbWjX8UZYJwlS0vVfjs0uAsv5GovWo9A1Pji0G2y2uAF5EKQMA'
  //         },
  //         body: jsonEncode(
  //           <String, dynamic>{
  //             'priority': 'high',
  //             'data': <String, dynamic>{
  //               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //               'status': 'done',
  //               'body': body,
  //               'title': title,
  //             },
  //             'notification': <String, dynamic>{
  //               'title': title,
  //               'body': body,
  //               'android_channel_id': 'dgr'
  //             },
  //             'to': token,
  //           },
  //         ));
  //   } catch (e) {
  //     print("erro notificaiton");
  //   }
  // }
}
