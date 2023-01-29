import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'camera_app_bar.dart';
import 'package:flutter_gradients_reborn/flutter_gradients_reborn.dart';
import 'glassmorphism_card.dart';
import 'card_details_screen.dart';
import 'package:audioplayers/audioplayers.dart';

// Declare the global variables
String? previousEyeValue;
bool toggleEyeCard = false;

//declare the glassmorphism card
GlassmorphismCard BathCard = GlassmorphismCard(
    key: ValueKey("Bath"),
    title: "Bath",
    content: "It's time to bath",
    imageUrl: "assets/images/bath.png",
    gradientColour: FlutterGradients.starWine(type: GradientType.linear));

GlassmorphismCard ToiletCard = GlassmorphismCard(
    key: ValueKey("Toilet"),
    title: "Toilet",
    content: "It's time to go to toilet",
    imageUrl: "assets/images/toilet.png",
    gradientColour: FlutterGradients.highFlight(type: GradientType.linear));

GlassmorphismCard EatCard = GlassmorphismCard(
    key: ValueKey("Eat"),
    title: "Eat",
    content: "It's time to eat",
    imageUrl: "assets/images/eat.png",
    gradientColour: FlutterGradients.deepBlue2(type: GradientType.linear));

GlassmorphismCard MedicineCard = GlassmorphismCard(
    key: ValueKey("Medicine"),
    title: "Medicine",
    content: "It's time for medicine",
    imageUrl: "assets/images/medicine.png",
    gradientColour: FlutterGradients.strongBliss(type: GradientType.linear));

GlassmorphismCard SelectedCard = GlassmorphismCard(
    key: ValueKey("Medicine"),
    title: "Medicine",
    content: "It's time for medicine",
    imageUrl: "assets/images/medicine.png",
    gradientColour: FlutterGradients.strongBliss(type: GradientType.linear));

class MainScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  MainScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //ValueNotifier for eyes status
  late CameraAppBar _appBar;
  int countBothEyesClosed = 0;
  @override
  void initState() {
    super.initState();
    _appBar = CameraAppBar(cameras: widget.cameras);
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: _appBar,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //left card
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: _appBar.eyeStatusNotifier,
                      builder: (context, value, child) {
                        if (previousEyeValue == 'Eyes Opened') {
                          if (value == "Both Eyes Closed") {
                            countBothEyesClosed++;
                          }
                        }
                        if (previousEyeValue != value) {
                          previousEyeValue = value;
                          if (value == "Both Eyes Closed") {
                            toggleEyeCard = !toggleEyeCard;
                          }
                        }
                        //if the countBothEyesClosed is equals to 2
                        //make the device ring
                        if (countBothEyesClosed == 2) {
                          final player = AudioCache();
                          player.play('emergency_siren.wav');
                          Fluttertoast.showToast(
                            msg: "Emergency is triggered",
                            gravity: ToastGravity.CENTER,
                          );
                          countBothEyesClosed = 0;
                        }
                        //navigate to card details screen
                        if (value == "Left Eye Closed") {
                          SelectedCard = toggleEyeCard ? ToiletCard : EatCard;
                          Future.delayed(Duration.zero, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CardDetailsScreen(
                                  mycard: SelectedCard,
                                  cameras: widget.cameras,
                                ),
                              ),
                            );
                          });
                        } else if (value == "Right Eye Closed") {
                          SelectedCard =
                              toggleEyeCard ? BathCard : MedicineCard;
                          Future.delayed(Duration.zero, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CardDetailsScreen(
                                  mycard: SelectedCard,
                                  cameras: widget.cameras,
                                ),
                              ),
                            );
                          });
                        } else if (value == "Both Eyes Closed") {
                          // Do something
                        } else {
                          // Do something
                        }

                        return AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                child: child, scale: animation);
                          },
                          child: toggleEyeCard ? ToiletCard : EatCard,
                        );
                      },
                    ),
                  ),
                  //right card
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: _appBar.eyeStatusNotifier,
                      builder: (context, value, child) {
                        return AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                child: child, scale: animation);
                          },
                          child: toggleEyeCard ? BathCard : MedicineCard,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
