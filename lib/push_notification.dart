//send notification to another flutter user
import 'dart:convert';
import 'glassmorphism_card.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//generate new token and save into the user
//hardcode
class PushNotificationSystem {
  //constructor
  PushNotificationSystem({required this.card});
  GlassmorphismCard card;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> sendNotification(String guardianToken) async {
    // Get the Firebase Cloud Messaging (FCM) server key
    String serverKey =
        "AAAAypHSMjw:APA91bH4MJqNL8RVpru6zLA0aiRlnfQt7oTAi22TVf0QpYGjhaUVxsQBlI1OfQ20I_Vx1pbWrj9nwwtbqsCbXaPm-IsSJar55Z4ThKL5q6OoTz06P2KkvZVuYOnwRVuklfgevVVB5rZO";

    // Create a HTTP client
    var client = http.Client();

    // Define the FCM notification message
    Map<String, dynamic> message = {
      "to": guardianToken,
      "notification": {
        "title": "New Message from Patient",
        "body": card.content,
      }
    };

    // Encode the message as a JSON string
    String jsonMessage = json.encode(message);

    // Send the FCM notification to the Guardian's device
    http.Response response = await client.post(
        Uri.parse("https://fcm.googleapis.com/Qfcm/send"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$serverKey"
        },
        body: jsonMessage);

    // Check if the FCM notification was sent successfully
    if (response.statusCode == 200) {
      print("FCM notification sent successfully.");
    } else {
      print(
          "FCM notification failed to send. Error code: ${response.statusCode}");
    }

    // Close the HTTP client
    client.close();
  }

  Future<void> getGuardianToken() async {
    // Get the Guardian's document from the Firestore database
    //Shaun_2
    DocumentSnapshot snapshot = await firestore
        .collection("Users")
        .doc("pIE5T64AOPgSDTQQLGgW4rXG0ah1")
        .get();

    // Get the Guardian's device token
    String guardianToken = snapshot.get("token");

    // Send the notification to the Guardian's device
    sendNotification(guardianToken);
  }
}
