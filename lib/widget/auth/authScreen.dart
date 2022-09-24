import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isit_busy/utils/helpers.dart';
import 'package:isit_busy/widget/auth/authform.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../NRL_User/homeScreen.dart';
import '../../business/homeBussScreen.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => AuthScreenState();
}

bool islodding = false;

class AuthScreenState extends State<AuthScreen> with Helpers {
  static bool isSignUp = false;
  static bool isBusiness = false;
  bool? new_IsBusiness;
  static String bussLocation = '';
  static String email = '';
  static String password = '';
  static String userName = '';
  static final _auth = FirebaseAuth.instance;
  final CurrentUser = FirebaseAuth.instance.currentUser;

  void changeIslodding() {
    if (islodding) {
      setState(() {
        islodding = false;
      });
    } else {
      setState(() {
        islodding = true;
      });
    }
  }

  setTepyOfUsers(authResult) async {
    if (authResult != null) {
      await FirebaseFirestore.instance
          .collection('tepyOfUsers')
          .doc(authResult)
          .set({
        'userId': authResult,
        'isSignUp': AuthScreenState.isSignUp,
        'isBussines': new_IsBusiness,
      });
    } else {
      return;
    }
  }

  navigtorTypyOfUser(ctx, uid) async {
    if (CurrentUser?.uid != null || uid.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('tepyOfUsers')
          .doc(uid)
          .get()
          .then((value) {
        if (value.data()!['isBussines'] == false) {
          Navigator.of(ctx).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false);
        } else if (value.data()!['isBussines'] == true) {
          return Navigator.of(ctx).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeBussScreen()),
              (Route<dynamic> route) => false);
        }
      });
    }
    ;
  }

  _submitAuthForm(
      {required String name,
      required String email,
      required String password,
      required BuildContext ctx}) async {
    UserCredential? authResult;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    new_IsBusiness = prefs.getBool('isBussines');
    try {
      if (!isSignUp) {
        changeIslodding();
        authResult = await _auth
            .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((_) {
          navigtorTypyOfUser(context, _auth.currentUser!.uid);
        });
        changeIslodding();
      } else if (isSignUp && !isBusiness) {
        changeIslodding();
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('NRL_Users')
            .doc(authResult.user!.uid)
            .set({
          'name': name,
          'password': password,
          'email': email,
          'profileImageUrl': "null",
          'userId': authResult.user!.uid,
        }).then((_) {
          setTepyOfUsers(_auth.currentUser?.uid);
          prefs.setBool('isSignUp', AuthScreenState.isSignUp);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false);
        });
        changeIslodding();
      } else if (isSignUp && isBusiness) {
        changeIslodding();
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('Buss_User')
            .doc(authResult.user!.uid)
            .set({
          'name': name,
          'password': password,
          'email': email,
          'userId': authResult.user!.uid,
          'location': bussLocation,
          'profileImageUrl': "null",
          'colorIndex': "1",
          "totleRait": 0,
          "isFav": false,
        }).then((_) {
          setTepyOfUsers(_auth.currentUser?.uid);
          prefs.setBool('isSignUp', AuthScreenState.isSignUp);
          prefs.setBool('isBussines', AuthScreenState.isBusiness);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeBussScreen()),
              (Route<dynamic> route) => false);
        });
        changeIslodding();
      }
    } on FirebaseAuthException catch (e) {
      changeIslodding();
      String errorMsg =
          "somethings error check your internet connection and try again ";
      if (e.code == 'weak-password') {
        errorMsg = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMsg = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        errorMsg = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMsg = 'Wrong password provided for that user.';
      }
      showSnackBar(
        context: context,
        message: '$errorMsg',
        error: true,
        width: 420,
        textAlign: TextAlign.start,
        time: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 244, 252, 1),
      body: ModalProgressHUD(
        inAsyncCall: islodding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 38,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 170,
                width: 170,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'IS IT BUSY',
                      style: TextStyle(
                        wordSpacing: 2,
                        fontWeight: FontWeight.normal,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: const Text(
                        'Your window to the world',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Container(
                      child: const Text(
                        'make your trip enjoyable',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AuthForm(
                      submiFun: _submitAuthForm,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
