import 'package:flutter/material.dart';
import 'dart:async';
import 'main_screen.dart';
import 'package:camera/camera.dart';

class MySplashScreen extends StatefulWidget {
  MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      //send user to home screen
      final cameras = await availableCameras();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(cameras: cameras)));
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset("assets/images/eyes.png"),
            const SizedBox(height: 10),
            //title
            const Text('Communigaze',
                style: TextStyle(
                    color: Color.fromARGB(255, 20, 20, 98),
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold)),
            const Text('Communicate through your eyes',
                style: TextStyle(
                    color: Color.fromARGB(255, 20, 20, 98),
                    fontSize: 17,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold)),
          ]),
        ),
      ),
    );
  }
}
