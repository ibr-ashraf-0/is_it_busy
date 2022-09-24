import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isit_busy/NRL_User/editPage.dart';
import 'package:isit_busy/NRL_User/placeDetails.dart';
import '../utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  static bool isConnected = false;

  static Future<bool> checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    } catch (_) {
      isConnected = false;
    }
    return isConnected;
  }

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

bool isFavorite = false;

void selcetPlace(String placeId, BuildContext ctx, totleRait) {
  Navigator.push(
      ctx,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              PlaceDetails(placeId: placeId, totleRait: totleRait)));
}

class _HomeScreenState extends State<HomeScreen> with Helpers {
  @override
  void initState() {
    HomeScreen.checkInternetConnectivity();
    super.initState();
  }

  late String _searchFor;
  bool isFavorite = false;
  bool? oldvalue;

  final user = FirebaseAuth.instance.currentUser;
  String hitDwnButton = 'San Fransisco';
  String dWNButtonTexts1 = 'San Francisco';
  String dWNButtonTexts2 = 'Texas';
  IconData unfavirotIcon = Icons.favorite_border;

  void selctFaverite({
    required BuildContext ctx,
    required String uid,
    required bool? oldISFav,
    required String imagUrl,
    required String name,
    required String loction,
    required String colorIndex,
  }) {
    setState(() {
      FirebaseFirestore.instance
          .collection('Buss_User')
          .doc(uid)
          .update({'isFav': !oldvalue!});
    });
    if (oldISFav != true) {
      FirebaseFirestore.instance
          .collection('FavoritePLC')
          .doc(user!.uid)
          .collection('placeData')
          .doc(uid)
          .set({
        'name': name,
        'location': loction,
        'profileImageUrl': imagUrl,
        'uid': uid,
        "isFav": true,
        'colorIndex': colorIndex,
      }).then((value) {
        showSnackBar(
          context: context,
          message: 'Place Added to Favorite',
          width: 350,
          time: 2,
          textAlign: TextAlign.center,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        );
      });
    } else if (oldISFav != false) {
      FirebaseFirestore.instance
          .collection('FavoritePLC')
          .doc(user!.uid)
          .collection('placeData')
          .doc(uid)
          .delete()
          .then((value) {
        showSnackBar(
          context: context,
          message: 'Place removed from Favorite',
          width: 350,
          time: 2,
          textAlign: TextAlign.center,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double divesWidth = MediaQuery.of(context).size.width;
    double divesHight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 80,
          leadingWidth: 80,
          backgroundColor: Theme.of(context).canvasColor,
          leading: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('NRL_Users')
                .doc(user!.uid)
                .get(),
            builder: (coontext, AsyncSnapshot snapShot) {
              if(snapShot.connectionState != ConnectionState.done){
                return Container(child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) {
                              return EditPage();
                            }),
                      );
                    },
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey,
                      child: Text('loading...',textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black),),
                    ),
                  ),
                    ),

                  ],
                ),
                );
              }
              return Padding(
                      padding: const EdgeInsets.only(top: 11.0, left: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return EditPage();
                                  }),
                                );
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 30,
                                backgroundImage: snapShot.data["profileImageUrl"] != "null" && HomeScreen.isConnected == true
                                    ? NetworkImage(
                                        snapShot.data["profileImageUrl"],
                                      )
                                    : AssetImage('assets/images/noImage.png')
                                        as ImageProvider<Object>,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 2.4),
              child: Container(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: const Icon(
                              Icons.location_on,
                              size: 25.0,
                              color: Color.fromRGBO(241, 76, 76, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.zero,
                                  child: const Text(
                                    'Location',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Container(
                                  width: 120,
                                  height: 45,
                                  child: DropdownButton(
                                      hint: Text(
                                        hitDwnButton,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                      itemHeight: 48,
                                      isExpanded: true,
                                      autofocus: true,
                                      elevation: 0,
                                      dropdownColor: Colors.white,
                                      focusColor: Colors.white,
                                      underline: Container(),
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.black),
                                      items: [
                                        DropdownMenuItem(
                                          child: Column(
                                            children: [
                                              Text(
                                                dWNButtonTexts1,
                                                style: const TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          value: 0,
                                        ),
                                        DropdownMenuItem(
                                          child: Column(
                                            children: [
                                              Text(
                                                dWNButtonTexts2,
                                                style: const TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          value: 1,
                                        ),
                                      ],
                                      onChanged: (itemIdentifier) {
                                        setState(() {
                                          if (itemIdentifier == 0) {
                                            hitDwnButton = dWNButtonTexts1;
                                          } else {
                                            hitDwnButton = dWNButtonTexts2;
                                          }
                                        });
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () async {
            return await Future.delayed(
              const Duration(seconds: 3),
              () async {
                HomeScreen.checkInternetConnectivity();
                setState(() {});
              },
            );
          },
          child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                child: TextFormField(
                  key: const ValueKey('search'),
                  autocorrect: true,
                  enableSuggestions: true,
                  textCapitalization: TextCapitalization.words,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter words to search for it";
                    }
                    return null;
                  },
                  onSaved: (val) => _searchFor = val!,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                          width: 0.0, color: Color.fromRGBO(243, 244, 252, 1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                          width: 0.0, color: Color.fromRGBO(243, 244, 252, 1)),
                    ),
                    label: const Text(
                      'Search heres …',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                future:
                    FirebaseFirestore.instance.collection('Buss_User').get(),
                builder: (ctx, AsyncSnapshot snapShot) {
                  return snapShot.connectionState == ConnectionState.done
                      ? SizedBox(
                          height: isLandscape
                              ? MediaQuery.of(context).size.height * 1.8
                              : double.parse(
                                  (snapShot.data.docs.length * 170).toString()),
                          width: MediaQuery.of(context).size.width,
                          child: GridView.builder(
                            addAutomaticKeepAlives: true,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapShot.data.docs.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: isLandscape
                                  ? divesWidth / 2.8
                                  : divesWidth / 1.5,
                              childAspectRatio: isLandscape
                                  ? 0.9 / 1
                                  : divesHight / (divesHight * 1.65),
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                            ),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              Color placeColor;
                              if (snapShot.data.docs[index]['colorIndex'] ==
                                  "1") {
                                placeColor =
                                    const Color.fromRGBO(224, 32, 32, 1);
                              } else if (snapShot.data.docs[index]
                                      ['colorIndex'] ==
                                  "2") {
                                placeColor =
                                    const Color.fromRGBO(250, 100, 0, 1);
                              } else if (snapShot.data.docs[index]
                                      ['colorIndex'] ==
                                  "3") {
                                placeColor =
                                    const Color.fromRGBO(0, 221, 181, 1);
                              } else {
                                placeColor =
                                    const Color.fromRGBO(224, 32, 32, 1);
                              }
                              return Container(
                                height: isLandscape
                                    ? divesHight * 1.5
                                    : divesHight / (divesHight * 1.65),
                                margin: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: isLandscape
                                          ? divesWidth / 4.2
                                          : divesHight / 4,
                                      width: isLandscape
                                          ? divesWidth / 2.8
                                          : divesWidth / 1.5,
                                      child: InkWell(
                                        onTap: () {
                                          selcetPlace(
                                              snapShot.data.docs[index]
                                                  ['userId'],
                                              ctx,
                                              snapShot.data.docs[index]
                                                  ['totleRait']);
                                        },
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                        child: Stack(
                                          children: [
                                            Container(
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                                child: (HomeScreen
                                                                .isConnected ==
                                                            true &&
                                                        snapShot.data
                                                                    .docs[index]
                                                                [
                                                                'profileImageUrl'] !=
                                                            "null")
                                                    ? FadeInImage(
                                                        image: NetworkImage(snapShot
                                                                .data
                                                                .docs[index][
                                                            'profileImageUrl']),
                                                        placeholder: AssetImage(
                                                            'assets/images/noImageAvailable.jpg'),
                                                        fit: BoxFit.cover,
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                      )
                                                    : snapShot.data.docs[index][
                                                                'profileImageUrl'] ==
                                                            "null"
                                                        ? Image.asset(
                                                            'assets/images/noImageAvailable.jpg',
                                                            fit: BoxFit.fill,
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,
                                                          )
                                                        : Image.asset(
                                                            'assets/images/noConnection.png',
                                                            fit: BoxFit.fill,
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,
                                                          ),
                                              ),
                                              height: double.infinity,
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(),
                                            ),
                                            Container(
                                              alignment: Alignment.topRight,
                                              margin: const EdgeInsets.only(
                                                  right: 10, top: 8),
                                              child: Container(
                                                height: 28,
                                                width: 28,
                                                decoration: BoxDecoration(
                                                    color: placeColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.bottomLeft,
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                margin: const EdgeInsets.only(
                                                    bottom: 5, left: 5),
                                                child: Stack(
                                                  children: [
                                                    InkWell(
                                                      child: Icon(
                                                        snapShot.data.docs[
                                                                        index]
                                                                    ['isFav'] ==
                                                                true
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        size: 25,
                                                        color: Colors.white,
                                                      ),
                                                      onTap: () {
                                                        oldvalue = snapShot.data
                                                                .docs[index]
                                                            ['isFav'];
                                                        selctFaverite(
                                                          ctx: context,
                                                          uid: snapShot.data
                                                                  .docs[index]
                                                              ['userId'],
                                                          oldISFav: oldvalue,
                                                          imagUrl: snapShot.data
                                                                  .docs[index][
                                                              'profileImageUrl'],
                                                          name: snapShot.data
                                                                  .docs[index]
                                                              ['name'],
                                                          loction: snapShot.data
                                                                  .docs[index]
                                                              ['location'],
                                                          colorIndex: snapShot
                                                                  .data
                                                                  .docs[index]
                                                              ['colorIndex'],
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 14, top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 18,
                                          ),
                                          Text(
                                            '(${0.4})',
                                            style: TextStyle(fontSize: 10),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(
                                            left: 18, top: 5, right: 20),
                                        width: 180,
                                        child: Text(
                                          snapShot.data.docs[index]['name'],
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        )),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 14, top: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.grey,
                                            size: 15,
                                          ),
                                          Container(
                                            width: isLandscape
                                                ? divesWidth / 5.7
                                                : divesWidth / 2.8,
                                            child: Text(
                                              snapShot.data.docs[index]
                                                  ['location'],
                                              softWrap: false,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 11.4),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          height: isLandscape
                              ? MediaQuery.of(context).size.height * 1.8
                              : MediaQuery.of(context).size.height / 2.4,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Check your internet connection',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 28, color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        );
                },
              ),
            ],
          ),
        ));
  }
}
