import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isit_busy/NRL_User/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaceSection extends StatefulWidget {
  @override
  State<PlaceSection> createState() => PlaceSectionState();
}

String _curantIndx = "0";
String sectionDocId = '';
final user = FirebaseAuth.instance.currentUser;
bool iconCheck = false;
Icon icon = const Icon(Icons.check_box_outline_blank);
bool? isAddSection;
bool isLandScape = false;

class PlaceSectionState extends State<PlaceSection> {
  @override
  void initState() {
    HomeScreen.checkInternetConnectivity();
    buildSections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    getData() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      isAddSection = pref.getBool('isAddSiction');
    }

    getData();
    if (isAddSection != "null") {
      return buildSections();
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 190, horizontal: 35),
        child: Column(
          children: [
            Container(
              width: 150,
              alignment: Alignment.center,
              child: const Text(
                ' No Items',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            Container(
              width: 250,
              alignment: Alignment.center,
              child: const Text(
                'Place Add Section',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  FutureBuilder<QuerySnapshot<Map<String, dynamic>>> buildSections() {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('sectionData')
            .doc(user!.uid)
            .collection('sections')
            .get(),
        builder: (context, AsyncSnapshot snapShot) {
          if (snapShot.hasData) {
            double height;
            if (snapShot.data.docs.length > 5 && !isLandScape) {
              height =
                  120 * (double.parse(snapShot.data.docs.length.toString()));
            } else if (isLandScape) {
              height =
                  140 * (double.parse(snapShot.data.docs.length.toString()));
            } else {
              height = MediaQuery.of(context).size.height - 200;
            }
            return SizedBox(
              height: height,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: snapShot.data.docs.length,
                itemBuilder: (context, index) {
                  if (snapShot.connectionState == ConnectionState.done) {
                    _curantIndx = snapShot.data.docs[index]['colorIndex'];
                  }
                  return Container(
                    height: 110,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 1.5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 90,
                          width: 86,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: (snapShot.connectionState ==
                                      ConnectionState.done &&
                                  HomeScreen.isConnected == true)
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(18),
                                  ),
                                  child: FadeInImage(
                                    fit: BoxFit.fill,
                                    fadeInDuration: Duration(seconds: 1),
                                    fadeInCurve: Curves.bounceInOut,
                                    placeholderFit: BoxFit.fill,
                                    image: NetworkImage(snapShot
                                        .data.docs[index]['sectionImageUrl']),
                                    placeholder: AssetImage(
                                        'assets/images/noImageAvailable.jpg'),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(18),
                                  ),
                                  child: Image.asset(
                                    'assets/images/noConnection.png',
                                    fit: BoxFit.fill,
                                  )),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1, vertical: 2.5),
                          margin: const EdgeInsets.all(5),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Text(
                                  snapShot.data.docs[index]['sectionName'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 28,
                                    height: 43,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: RawMaterialButton(
                                        focusElevation: 0,
                                        disabledElevation: 0,
                                        elevation: 0,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        onPressed: () async {
                                          setState(() {
                                            _curantIndx = snapShot
                                                .data.docs[index]['colorIndex'];
                                          });
                                          if (_curantIndx == "1") {
                                            FirebaseFirestore.instance
                                                .collection('sectionData')
                                                .doc(user!.uid)
                                                .collection('sections')
                                                .doc(snapShot
                                                    .data.docs[index].id)
                                                .update({'colorIndex': "0"});
                                          } else {
                                            FirebaseFirestore.instance
                                                .collection('sectionData')
                                                .doc(user!.uid)
                                                .collection('sections')
                                                .doc(snapShot
                                                    .data.docs[index].id)
                                                .update({'colorIndex': "1"});
                                          }
                                        },
                                        autofocus: false,
                                        fillColor: Colors.white,
                                        splashColor: const Color.fromRGBO(
                                            224, 32, 32, 0.6),
                                        child: Stack(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(1.5),
                                              margin: const EdgeInsets.all(0.2),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _curantIndx == "1"
                                                    ? const Color.fromRGBO(
                                                        224, 32, 32, 1)
                                                    : Colors.white,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(1.2),
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4.5),
                                                  child: null,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color.fromRGBO(
                                                        224, 32, 32, 1),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 28,
                                    height: 43,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: RawMaterialButton(
                                        focusElevation: 0,
                                        disabledElevation: 0,
                                        elevation: 0,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        onPressed: () async {
                                          setState(() {
                                            _curantIndx = snapShot
                                                .data.docs[index]['colorIndex'];
                                          });
                                          if (_curantIndx == "2") {
                                            FirebaseFirestore.instance
                                                .collection('sectionData')
                                                .doc(user!.uid)
                                                .collection('sections')
                                                .doc(snapShot
                                                    .data.docs[index].id)
                                                .update({'colorIndex': "0"});
                                          } else {
                                            FirebaseFirestore.instance
                                                .collection('sectionData')
                                                .doc(user!.uid)
                                                .collection('sections')
                                                .doc(snapShot
                                                    .data.docs[index].id)
                                                .update({'colorIndex': "2"});
                                          }
                                        },
                                        autofocus: false,
                                        fillColor: Colors.white,
                                        splashColor: const Color.fromRGBO(
                                            250, 100, 0, 0.6),
                                        child: Stack(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(1.5),
                                              margin: const EdgeInsets.all(0.2),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _curantIndx == "2"
                                                    ? const Color.fromRGBO(
                                                        250, 100, 0, 1)
                                                    : Colors.white,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(1.2),
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4.5),
                                                  child: null,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color.fromRGBO(
                                                        250, 100, 0, 1),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 28,
                                    height: 43,
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: RawMaterialButton(
                                        focusElevation: 0,
                                        disabledElevation: 0,
                                        elevation: 0,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        onPressed: () async {
                                          setState(() {
                                            _curantIndx = snapShot
                                                .data.docs[index]['colorIndex'];
                                          });
                                          if (_curantIndx == "3") {
                                            FirebaseFirestore.instance
                                                .collection('sectionData')
                                                .doc(user!.uid)
                                                .collection('sections')
                                                .doc(snapShot
                                                    .data.docs[index].id)
                                                .update({'colorIndex': "0"});
                                          } else {
                                            FirebaseFirestore.instance
                                                .collection('sectionData')
                                                .doc(user!.uid)
                                                .collection('sections')
                                                .doc(snapShot
                                                    .data.docs[index].id)
                                                .update({'colorIndex': "3"});
                                          }
                                        },
                                        autofocus: false,
                                        fillColor: Colors.white,
                                        splashColor: const Color.fromRGBO(
                                            0, 221, 181, 0.6),
                                        child: Stack(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(1.5),
                                              margin: const EdgeInsets.all(0.2),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _curantIndx == "3"
                                                    ? const Color.fromRGBO(
                                                        0, 221, 181, 1)
                                                    : Colors.white,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(1.2),
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4.5),
                                                  child: null,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color.fromRGBO(
                                                        0, 221, 181, 1),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                        IconButton(
                          splashRadius: 2.5,
                          padding: const EdgeInsets.all(1.2),
                          onPressed: () {
                            iconCheck = !iconCheck;
                            icon = const Icon(Icons.check_box);
                          },
                          icon: icon,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (snapShot.connectionState == ConnectionState.waiting) {
            return Container(
              height: MediaQuery.of(context).size.height - 300,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: const CircularProgressIndicator(),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
