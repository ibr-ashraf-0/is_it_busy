import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isit_busy/NRL_User/homeScreen.dart';
import 'package:isit_busy/screens/splashScreen.dart';
import 'package:isit_busy/utils/helpers.dart';
import 'package:isit_busy/business/placeState.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ChangeBusineesPassScreen.dart';
import 'editBusScreen.dart';
import 'homeBussScreen.dart';
class EditBussPage extends StatefulWidget {
  @override
  _EditBussPageState createState() => _EditBussPageState();
}

class _EditBussPageState extends State<EditBussPage> with Helpers {
  final user = FirebaseAuth.instance.currentUser;
  bool? isAddProfileImage;

  @override
  void initState() {
    HomeScreen.checkInternetConnectivity();
    buildBussInfo();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    void getData() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      isAddProfileImage = prefs.getBool('isAddProfileImage');
    }
    getData();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return HomeBussScreen();
            }),
          ),
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
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 3), (){
              setState(() {
                HomeScreen.checkInternetConnectivity();
                getData();
                buildBussInfo();
                EditBussScreenState();
              });
            },
          );
        },
        child: Container(
          color: const Color.fromRGBO(243, 244, 252, 1),
          height: MediaQuery.of(context).size.height,
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              buildBussInfo(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
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
                        'Edit Profile',
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
                      MaterialPageRoute(
                          builder: (_) {
                            return EditBussScreen();
                          }),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
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
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) {
                          return ChangeBusineesPassScreen();
                        }));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).orientation == Orientation.landscape ? 150:255, right: 120,left: 120),
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
                        size: 22,
                        color: Color.fromRGBO(241, 76, 76, 1),
                      ),
                      Text(
                        'Log out',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(241, 76, 76, 1),
                          fontSize: 17,
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
                    FirebaseAuth.instance.currentUser!.uid.trim();
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Splash_screen();
                          }),
                        ModalRoute.withName('/')
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> buildBussInfo() {
    return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('Buss_User')
                .doc(user!.uid)
                .get(),
            builder: (ctx, AsyncSnapshot snapShot) {
              return snapShot.connectionState != ConnectionState.done || snapShot.hasError?
              Container(
                color: const Color.fromRGBO(243, 244, 252, 1),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 28,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: const CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey,
                          backgroundImage: null,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 18),
                        child: const Text(
                           'Unvalidated Name' ,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 7),
                        child: const Text(
                       'Unvalidated Locution',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              fontSize: 14,
                              color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 55, vertical: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 55, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PlaceState(placeColor: "1",),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ) :
              Container(
                color: const Color.fromRGBO(243, 244, 252, 1),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 28,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Theme.of(context).canvasColor,
                          backgroundImage: (snapShot.data['profileImageUrl'] != "null" && HomeScreen.isConnected == true && snapShot.connectionState == ConnectionState.done)
                              ?  NetworkImage(
                            snapShot.data['profileImageUrl'],
                            ) : AssetImage('assets/images/noImage.png') as ImageProvider,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 18),
                        child: Text(
                          snapShot.data['name'] ?? 'Unvalidated Name' ,
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
                          snapShot.data['location'] ?? 'Unvalidated Locution',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              fontSize: 14,
                              color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 55, vertical: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 55, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: PlaceState(placeColor: snapShot.data['colorIndex'],),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
