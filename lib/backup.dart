// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// class CameraAppBar extends StatefulWidget with PreferredSizeWidget {
//   final List<CameraDescription> cameras;
//   String eyeCurrentStatus = '';
//   //value notifier for eye status
//   late ValueNotifier<String> eyeStatusNotifier =
//       ValueNotifier<String>(eyeCurrentStatus);
//   CameraAppBar({Key? key, required this.cameras, this.eyeCurrentStatus = ''})
//       : super(key: key);

//   @override
//   State<CameraAppBar> createState() => _CameraAppBarState();

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight + 200);
// }

// class _CameraAppBarState extends State<CameraAppBar> {
//   //getter function for cameras
//   List<CameraDescription> get cameras => widget.cameras;
//   //getter function for eyeCurrentStatus
//   String get eyeCurrentStatus => widget.eyeCurrentStatus;

//   // setter function for eye current status
//   set eyeCurrentStatus(String value) => widget.eyeCurrentStatus = value;

//   //getter function for eyeStatusNotifier
//   ValueNotifier<String> get eyeStatusNotifier => widget.eyeStatusNotifier;
//   //setter function for eyeStatusNotifier
//   set eyeStatusNotifier(ValueNotifier<String> value) =>
//       widget.eyeStatusNotifier = value;

//   dynamic controller;
//   bool isBusy = false;
//   dynamic faceDetector;
//   String eyeStatus = '';
//   late Size size;
//   late List<Face> faces;
//   late CameraDescription description = cameras[1];
//   CameraLensDirection camDirec = CameraLensDirection.front;

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//   }

// //initialize the camera feed
//   initializeCamera() async {
//     //initialize detector
//     final options = FaceDetectorOptions(
//         enableContours: true,
//         enableLandmarks: true,
//         enableClassification: true,
//         enableTracking: true,
//         performanceMode: FaceDetectorMode.accurate);
//     faceDetector = FaceDetector(options: options);
//     // Set the desired frame rate (in frames per second)
//     int frameRate = 1;
//     controller = CameraController(description, ResolutionPreset.high);
//     await controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       controller.startImageStream((image) async => {
//             if (!isBusy) {isBusy = true, img = image, doFaceDetectionOnFrame()}
//           });
//       // Create a periodic stream of image frames at the desired frame rate
//       Stream<CameraImage> periodicImageStream = Stream<CameraImage>.periodic(
//           Duration(milliseconds: (800 / frameRate).round()), (_) => img!);

//       // Listen to the periodic stream and process each frame
//       periodicImageStream.listen(doFaceDetectionOnFrame());
//     });
//   }

// //close all resources
//   @override
//   void dispose() {
//     controller?.dispose();
//     faceDetector.close();
//     super.dispose();
//   }

//   //face detection on a frame
//   dynamic _scanResults;
//   CameraImage? img;
//   doFaceDetectionOnFrame() async {
//     eyeStatusNotifier.value = eyeCurrentStatus;
//     var frameImg = getInputImage();
//     //slow down the frame rate
//     await Future.delayed(Duration(milliseconds: 800));
//     //detect faces
//     List<Face> faces = await faceDetector.processImage(frameImg);

//     for (Face f in faces) {
//       //The image is toggled so the coordinates are also toggled
//       //detect eyes open or closed
//       if (f.leftEyeOpenProbability! > 0.5 && f.rightEyeOpenProbability! < 0.5) {
//         eyeStatus += "Left Eye Closed";
//         eyeCurrentStatus = "Left Eye Closed";
//         eyeStatusNotifier.value = eyeCurrentStatus;
//       } else if (f.leftEyeOpenProbability! < 0.5 &&
//           f.rightEyeOpenProbability! > 0.5) {
//         eyeStatus += "Right Eye Closed";
//         eyeCurrentStatus = "Right Eye Closed";
//         eyeStatusNotifier.value = eyeCurrentStatus;
//       } else if (f.leftEyeOpenProbability! > 0.5 &&
//           f.rightEyeOpenProbability! > 0.5) {
//         eyeStatus += "Eyes Opened";
//         eyeCurrentStatus = "Eyes Opened";
//         eyeStatusNotifier.value = eyeCurrentStatus;
//       } else if (f.leftEyeOpenProbability! < 0.5 &&
//           f.rightEyeOpenProbability! < 0.5) {
//         eyeStatus += "Both Eyes Closed";
//         eyeCurrentStatus = "Both Eyes Closed";
//         eyeStatusNotifier.value = eyeCurrentStatus;
//       } else {
//         eyeStatus += "";
//         eyeCurrentStatus = "";
//         eyeStatusNotifier.value = eyeCurrentStatus;
//       }
//       //eyeCurrentStatus = "";
//     }
//     setState(() {
//       _scanResults = faces;
//       isBusy = false;
//     });
//   }

//   InputImage getInputImage() {
//     final WriteBuffer allBytes = WriteBuffer();
//     for (final Plane plane in img!.planes) {
//       allBytes.putUint8List(plane.bytes);
//     }
//     final bytes = allBytes.done().buffer.asUint8List();
//     final Size imageSize = Size(img!.width.toDouble(), img!.height.toDouble());
//     final camera = description;
//     final imageRotation =
//         InputImageRotationValue.fromRawValue(camera.sensorOrientation);

//     final inputImageFormat =
//         InputImageFormatValue.fromRawValue(img!.format.raw);

//     final planeData = img!.planes.map(
//       (Plane plane) {
//         return InputImagePlaneMetadata(
//           bytesPerRow: plane.bytesPerRow,
//           height: plane.height,
//           width: plane.width,
//         );
//       },
//     ).toList();

//     final inputImageData = InputImageData(
//       size: imageSize,
//       imageRotation: imageRotation!,
//       inputImageFormat: inputImageFormat!,
//       planeData: planeData,
//     );

//     final inputImage =
//         InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

//     return inputImage;
//   }

//   //Return the text when eyes detected
//   Widget buildResult() {
//     if (_scanResults == null ||
//         controller == null ||
//         !controller.value.isInitialized) {
//       return Text('');
//     } else {
//       return Text('');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     } else {
//       return AppBar(
//         title: Text(
//           widget.eyeCurrentStatus,
//           style: const TextStyle(
//             color: Colors.blue,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         flexibleSpace: SizedBox(
//           height: 300,
//           child: CameraPreview(controller),
//         ),
//       );
//     }
//   }
// }
