import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_learning_project/Screens/Signup/signup_screen.dart';
import 'package:firebase_learning_project/Screens/Welcome/welcome_screen.dart';
import 'package:firebase_learning_project/Screens/customCamera/openCamera.dart';
import 'package:firebase_learning_project/constants.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<CameraDescription> cameras = [];
  cameras = await availableCameras();

  await Firebase.initializeApp();
  runApp(MyApp(camera: cameras,));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription>? camera;

  const MyApp({Key? key, this.camera}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Learninf',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
    );
  }
}
