import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isit_busy/NRL_User/editScreen.dart';
import 'package:isit_busy/NRL_User/homeScreen.dart';
import 'package:isit_busy/screens/splashScreen.dart';
import 'package:isit_busy/NRL_User/userFavorite.dart';
import 'package:isit_busy/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'changePassScreen.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPAgeState createState() => _EditPAgeState();
}

final user = FirebaseAuth.instance.currentUser;

class _EditPAgeState extends State<EditPage> with Helpers {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 3), () async {
              setState(() {});
          },
          );
        },
        child: Container(
          color: const Color.fromRGBO(243, 244, 252, 1),
          child: ListView(
            children: [
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('NRL_Users')
                    .doc(user!.uid)
                    .get(),
                builder: (ctx, AsyncSnapshot snapShot) {
                  if (snapShot.connectionState != ConnectionState.done) {
                    return Container(
                      color: Theme.of(context).canvasColor,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 28,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 45,
                                backgroundImage: AssetImage('assets/images/noImage.png'),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.only(top: 18),
                              child: Text(
                                ' Unavailable Name',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.only(top: 7),
                              child: Text(
                                'Unavailable Locution',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                    fontSize: 14,
                                    color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container(
                    color: Theme.of(context).canvasColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 28,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 45,
                              backgroundImage:
                              snapShot.data["profileImageUrl"] != "null" && HomeScreen.isConnected == true
                                  ? NetworkImage(
                                snapShot.data["profileImageUrl"],
                              )
                                  : AssetImage('assets/images/noImage.png')
                              as ImageProvider<Object>,
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(top: 18),
                            child: Text(
                              snapShot.data['name'] ?? 'Unvalidated Name',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(top: 7),
                            child: Text(
                              snapShot.data['email'] ?? 'Unvalidated Locution',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  fontSize: 14,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                margin:  EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).orientation == Orientation.landscape
                    ?  MediaQuery.of(context).size.width / 3 : 110 ),
                child: RawMaterialButton(
                  splashColor: Colors.red,
                  fillColor: Theme.of(context).primaryColor,
                  highlightColor: Colors.red[200],
                  padding: const EdgeInsets.all(15),
                  focusColor: const Color.fromRGBO(241, 76, 76, 1),
                  autofocus: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 5.5,
                      ),
                      const Text(
                        'Edit Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: RawMaterialButton(
                  splashColor: Colors.black38,
                  fillColor: Colors.white,
                  highlightColor: Colors.black38,
                  padding: const EdgeInsets.all(15),
                  focusColor: Colors.white,
                  autofocus: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'My Favorite',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromRGBO(155, 153, 151, 1),
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return UserFavorite(
                          placeId: '',
                        );
                      }),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: RawMaterialButton(
                  splashColor: Colors.black38,
                  fillColor: Colors.white,
                  highlightColor: Colors.black38,
                  padding: const EdgeInsets.all(15),
                  focusColor: Colors.white,
                  autofocus: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromRGBO(155, 153, 151, 1),
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) {
                      return ChangePassScreen();
                    }));
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.4,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: RawMaterialButton(
                  splashColor: Colors.red[200],
                  fillColor: const Color.fromRGBO(243, 244, 252, 1),
                  highlightColor: Colors.red[200],
                  focusElevation: 0,
                  hoverElevation: 0,
                  disabledElevation: 0,
                  elevation: 0,
                  padding: const EdgeInsets.all(15),
                  focusColor: const Color.fromRGBO(243, 244, 252, 1),
                  autofocus: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.logout,
                        color: Color.fromRGBO(241, 76, 76, 1),
                      ),
                      Text(
                        'Log out',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(241, 76, 76, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    setState(() {
                      pref.setBool('isSignUp', false);
                      pref.setBool('isBussines', false);
                    });
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (_) {
                      return Splash_screen();
                    }), ModalRoute.withName('/'));
                    await FirebaseAuth.instance.signOut();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
