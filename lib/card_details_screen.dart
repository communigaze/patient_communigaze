import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'camera_app_bar.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_gradients_reborn/flutter_gradients_reborn.dart';
import 'glassmorphism_card.dart';
import 'right_glassmorphism_card.dart';
import 'main_screen.dart';
import 'push_notification.dart';
import 'send_message.dart';

//TODO: emergency button and the message to be sent to the guardian
GlassmorphismCard MessageCard = GlassmorphismCard(
    key: ValueKey("Message"),
    title: "Message",
    content: "Send this message to the guardian",
    imageUrl: "assets/images/message.png",
    gradientColour: FlutterGradients.highFlight(type: GradientType.linear));

GlassmorphismCard SpeakCard = GlassmorphismCard(
    key: ValueKey("Speak"),
    title: "Speak",
    content: "Speak out this message loud",
    imageUrl: "assets/images/speak.png",
    gradientColour: FlutterGradients.phoenixStart(type: GradientType.linear));

class CardDetailsScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final GlassmorphismCard mycard;

  const CardDetailsScreen(
      {super.key, required this.cameras, required this.mycard});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  late CameraAppBar _appBar;
  ValueNotifier<String> _eyeStatusNotifier = ValueNotifier<String>("");
  String _eyeStatus = "";
  FlutterTts flutterTts = FlutterTts();
  late PushNotificationSystem pushNotification;
  @override
  void initState() {
    super.initState();
    _appBar = CameraAppBar(cameras: widget.cameras);
    pushNotification = PushNotificationSystem(card: widget.mycard);
    _eyeStatusNotifier = _appBar.eyeStatusNotifier;
    flutterTts = FlutterTts();
    _eyeStatusNotifier.addListener(_onEyeStatusChanged);
  }

  @override
  void dispose() {
    _eyeStatusNotifier.removeListener(_onEyeStatusChanged);
    super.dispose();
    flutterTts.stop();
  }

  void _onEyeStatusChanged() {
    setState(() {
      _eyeStatus = _eyeStatusNotifier.value;
    });
    if (_eyeStatus == "Both Eyes Closed") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(cameras: widget.cameras)));
    }
  }

  void speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(0.8);
    await flutterTts.setVolume(1.0); // 0.5 to 1.5
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            RightGlassmorphismCard(
              key: widget.mycard.key,
              title: widget.mycard.title,
              content: widget.mycard.content,
              imageUrl: widget.mycard.imageUrl,
              gradientColour: widget.mycard.gradientColour,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //left card
                Expanded(
                  child: MessageCard,
                ),
                //right card
                Expanded(
                  child: SpeakCard,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder(
                valueListenable: _eyeStatusNotifier,
                builder: (context, eyeStatus, child) {
                  return _buildActions(eyeStatus);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(String eyeStatus) {
    if (eyeStatus == 'Left Eye Closed') {
      pushNotification.getGuardianToken();
      SendMessage sendNow = SendMessage(content: widget.mycard.content);
      sendNow.sendTextMessage();
      Fluttertoast.showToast(
        msg: "sent the message",
        gravity: ToastGravity.CENTER,
      );
      return _buildSendMessageButton();
    } else if (eyeStatus == 'Right Eye Closed') {
      speak(widget.mycard.content);
      Fluttertoast.showToast(
        msg: "Spoke the message",
        gravity: ToastGravity.CENTER,
      );
      return Container();
    } else {
      return Container();
    }
  }

  Widget _buildSendMessageButton() {
    return Container();
  }
}
