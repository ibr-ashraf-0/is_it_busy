import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isit_busy/screens/welcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../business/homeBussScreen.dart';
import '../NRL_User/homeScreen.dart';

class Splash_screen extends StatefulWidget {
  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
  bool? isSignUp;

  bool? isBusiness;
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    getData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        isBusiness = prefs.getBool('isBussines');
        isSignUp = prefs.getBool('isSignUp');
      });
    }

    getData();
    return Scaffold(
      body: Center(
        child: EasySplashScreen(
          logoSize: 270,
          logo: Image.asset('assets/images/logo.png'),
          backgroundColor: const Color.fromRGBO(243, 244, 252, 1),
          showLoader: false,
          durationInSeconds: 3,
          navigator: user?.uid != null
              ? FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('tepyOfUsers')
                      .doc(user!.uid)
                      .get(),
                  builder: (ctx, AsyncSnapshot snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return Container(
                        color: Theme.of(context).canvasColor,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              const SizedBox(height: 35,),
                              Text('Loading...',textAlign: TextAlign.center,style: TextStyle(fontSize: 14,color: Colors.black,decorationColor: Theme.of(context).canvasColor,),)
                            ],
                          ),
                        ),
                      );
                    } else if (snapShot.hasData &&
                        snapShot.connectionState == ConnectionState.done) {
                      if (snapShot.data['isBussines'] == true) {
                        return HomeBussScreen();
                      } else if (snapShot.data['isBussines'] == false) {
                        return HomeScreen();
                      }
                    }
                    return WelcomeScreen();
                  },
                )
              : WelcomeScreen(),
        ),
      ),
    );
  }
}
