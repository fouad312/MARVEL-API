import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:http/http.dart' as http;
import 'package:test_apk/FirebaseNotification/ToastMessage.dart';


class NotificationFirebase {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
////
  static requestPermision() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  /// when apk open
  static getNotification() {
    int i = 0;
    FirebaseMessaging.onMessage.listen((event) {
      i++;
      Toast.showToast(
          "${event.notification!.title!} : ${event.notification!.body!}");

    });
  }

///////////////

  static sendNotify(String title, String body, String id, String name,
      String tokenSendTo) async {
    String serverToken =
    "AAAAvwEYCYY:APA91bEdfr3e1NkVOrpzENaqw9-KA37CW9hyAVI1N8j8eCKnLQ3EyiBuNmub1TfgX8Ahk_LAFVbvaTBsMCSWpvwgcoAoV8Gu6hrllafOFi55X6jdV1AU6s-Iwiw5RjeWvl1dQAENuQSc";

    await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": "key=$serverToken"
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{
            "body": body.toString(),
            "title": title.toString(),
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': id.toString(),
            'name': name.toString(),
          },
          'to': tokenSendTo
        }));
  }

/////////////////////////
///// not terminated
  static onMessage() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      getNotification();
    });
  }

////////////////////////////
  // on backGround
  static Future backgroundMessage(RemoteMessage message) async {
    getNotification();
  }

  static onBackGround() {
    FirebaseMessaging.onBackgroundMessage(backgroundMessage);
  }
}
