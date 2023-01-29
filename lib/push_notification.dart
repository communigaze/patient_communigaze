//send notification to another flutter user
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//generate new token and save into the user
//hardcode
class PushNotificationSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {
    //1. Terminated state
    //When the app is completely closed and opened directly from the push notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        //display the guards request information - the location and the crime details
        // readControlRoomEventRequestInformation(
        //     remoteMessage.data["eventRequestId"], context);
      }
    });
    //2. Foreground state
    //When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      //display the guards request information - the location and the crime details
    });

    //3. Background state
    //When the app is in the background and opened directly from the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      //display the guards request information - the location and the crime details
    });
  }

  //call firestore
  Future generateAndGetToken() async {
    String? registrationToken = await messaging.getToken();

    //add new token field to the users(Patient)
    FirebaseFirestore.instance
        .collection("Users")
        .doc("pIE5T64AOPgSDTQQLGgW4rXG0ah1")
        .update({"token": registrationToken});

    messaging.subscribeToTopic("message");
  }
}
