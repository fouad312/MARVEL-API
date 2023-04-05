import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_apk/Athentification/Client.dart';
import 'package:test_apk/Athentification/Login.dart';
import 'package:test_apk/Componeents/animation/transitionAnimation.dart';
import 'package:test_apk/Controllers/storeData.dart';
import 'package:test_apk/FirebaseNotification/FirebaseNotification.dart';
import 'package:test_apk/Screans/FavorateList.dart';
import 'package:test_apk/Screans/allCharacters.dart';
import 'package:test_apk/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 @override
  void initState() {
   

    getToken();
    NotificationFirebase.getNotification();
    // TODO: implement initState
    super.initState();
 

    if (Platform.isIOS == true) {
      NotificationFirebase.requestPermision();
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
        final b = await onbackPress(context);
        return b ?? false;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        
        floatingActionButton: FloatingActionButton(
          onPressed: () {
             Navigator.push(context, SizeTransition3(const FavorateList()));
          },
          backgroundColor: secondColor,
          child: const Icon(
            Icons.favorite_border_outlined ,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,actions: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              LocalData.clearData();
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.push(context,SizeTransition5(Login(signIn: true,)));
              });
             
            },
            child: Padding(
              padding: const EdgeInsets.all( 16),
              child: Icon(FontAwesomeIcons.signOut,color: secondColor,),
            ),
          )
        ],),
        body:widgetScrean() ,
      ),
    );
  }

  SingleChildScrollView bodyHome() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: 
         [
        // getCharacters(),
        // getBestTvShow(),
         200.h],
      ),
    );
  }

  Widget widgetScrean() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("clients")
            .where("uID",
                isEqualTo: FirebaseAuth.instance.currentUser != null
                    ? FirebaseAuth.instance.currentUser!.uid
                    : "vide")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Quelque chose s'est mal passé"));
          }

          if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              var data = snapshot.data!.docs.first;
              LocalData.loadSharedPreferencesAndData();
              client = Client.fromMap(data);

              return const AllCharacters();
            }
            //

          }
          return Center(
            child: CircularProgressIndicator(
              color: secondColor,
            ),
          );
        });
  }
   getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    print("token******************************");
    print(token);
    print("token******************************");

    
  }

 }