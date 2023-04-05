
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_apk/Athentification/Client.dart';
import 'package:test_apk/Models/Character.dart';
import 'package:url_launcher/url_launcher.dart';

Color primaryColor = const Color.fromARGB(217, 0, 0, 0);
Color secondColor = const Color.fromARGB(255, 231, 22, 7);

Widget backbutton(BuildContext context, Color color) {
  return RawMaterialButton(
      shape: const CircleBorder(),
      splashColor: Colors.white,
      //fillColor: Colors.yellow.shade300,
      onPressed: () {
        Navigator.of(context).pop();
      },
      // ignore: prefer_const_constructors
      child: Icon(
        FontAwesomeIcons.circleChevronLeft,
        size: 30,
        color: color,
      ));
}

List<ResultsCharacter> listFavorite = [];
Client? client;

 Future<void> launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
extension EmptyPadding on num {
  SizedBox get h => SizedBox(
        height: toDouble(),
      );
  SizedBox get w => SizedBox(
        width: toDouble(),
      );
}

alert(
  BuildContext context,
  String myTitle,
  String myContent,
) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text(myTitle),
          content: Text(myContent),
          actions: <Widget>[
            RawMaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Exit'))
          ],
        );
      });
}
 Future<bool?> onbackPress(BuildContext context) async {
    return showDialog<bool?>(
        context: context,
        builder: (contex) => AlertDialog(
              title:const Text("Do you want to Exit?"),
              actions: <Widget>[
                RawMaterialButton(
                    onPressed: () {
                      if (Platform.isIOS) {
                        exit(0);
                      } else {
                        SystemNavigator.pop();
                      }
                      // exit(0)
                      // SystemNavigator.pop();
                      //   Navigator.pop(context, true);
                    },
                    child:const Text("Yes")),
                RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child:const Text("No")),
              ],
            ));
  }