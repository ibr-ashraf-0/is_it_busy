import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:isit_busy/screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty){
    await Firebase.initializeApp(
      name: 'is it busy project',
      options: const FirebaseOptions(
        apiKey: " AIzaSyAHkZGnveS7tozBZCDKktBxF3PY2edosMQ",
        appId: "1:667573565650:android:a164bda1cbaf21c946550b",
        messagingSenderId: "667573565650",
        projectId: "is-it-busy-project",
      ),
    );
  }

  runApp(isItBusy_App());
}
class isItBusy_App extends StatelessWidget {
  static const primaryColor = Color.fromRGBO(241, 76, 76, 1);
  static const secondaryColor = Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: Color.fromRGBO(243, 244, 252, 1),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(secondary: secondaryColor),),
      home: Splash_screen(),
    );
  }
}
