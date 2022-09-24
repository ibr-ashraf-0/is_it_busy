import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:isit_busy/NRL_User/homeScreen.dart';
import 'package:isit_busy/utils/helpers.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';

import 'homeScreen.dart';

class PlaceDetails extends StatefulWidget {
  final String placeId;
  final totleRait;

  PlaceDetails({required this.placeId, required this.totleRait});

  @override
  PlaceDetailsState createState() => PlaceDetailsState();
}

class PlaceDetailsState extends State<PlaceDetails> with Helpers {
  final Uri _url = Uri.parse('https://flutter.dev');

  Future<void> _launchURL() async {
    if (!await launchUrl(_url,mode:  LaunchMode.externalNonBrowserApplication)) {
      throw 'Could not launch $_url';
    }
  }
  @override
  void initState() {
    HomeScreen.checkInternetConnectivity();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return HomeScreen();
            }),
          ),
        ),
        title: const Text(
          'Place Details',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return await Future.delayed(
            const Duration(seconds: 3),
            () async {
              HomeScreen.checkInternetConnectivity();
              setState(() {});
            },
          );
        },
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('Buss_User')
              .doc(widget.placeId)
              .get(),
          builder: (context, AsyncSnapshot snapShot) {
            if (snapShot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  CircleAvatar(
                                    radius: 55,
                                    backgroundColor: Theme.of(context).canvasColor,
                                    backgroundImage: HomeScreen.isConnected && snapShot.data['profileImageUrl'] != "null" ? NetworkImage(
                                      snapShot.data['profileImageUrl'],
                                    ): AssetImage(
                                        'assets/images/noImage.png')
                                    as ImageProvider<Object>,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    snapShot.data['name'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.grey,
                                        size: 15.0,
                                      ),
                                      Text(
                                        snapShot.data['location'],
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            wordSpacing: 1.5,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3.2,
                                  ),
                                  Container(
                                    width: 220.0,
                                    height: 25,
                                    child: RawMaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          buildStarRaite(),
                                          SizedBox(width: 2,),
                                          Text('Reviews', style: TextStyle(color: Colors.grey,fontSize: 13),)
                                        ],
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            // isScrollControlled: true,
                                            context: context,
                                            backgroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30))),
                                            builder: (context) {
                                              return Container(
                                                  padding:
                                                      MediaQuery.of(context)
                                                          .viewInsets,
                                                  child: BuildButtomSheet(
                                                    context: context,
                                                    placeId: widget.placeId,
                                                    totleRait: widget.totleRait,
                                                  ));
                                            });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                  Container(
                                    height: 25,
                                    margin: const EdgeInsets.fromLTRB(
                                        100, 0, 100, 0),
                                    child: RawMaterialButton(
                                      padding: EdgeInsets.all(0),
                                        elevation: 0,
                                        onPressed: _launchURL,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          'www.${snapShot.data['name'].toString()}.com',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15,top: 20),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Sections',
                              style: TextStyle(
                                  fontSize: 15,),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                              color: Colors.white,
                              height: 500,
                              child: buildPlaceDetails()),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Check your internet connection',textAlign: TextAlign.center,style: TextStyle(fontSize: 28,color: Colors.black),),
                    const SizedBox(height: 25,),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            } else {
              return Container(
                color: Colors.white,
                height: double.infinity,
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildPlaceDetails() {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('sectionData')
          .doc(widget.placeId)
          .collection('sections')
          .get(),
      builder: (ctx, AsyncSnapshot snapShot) {
        if(snapShot.connectionState == ConnectionState.waiting){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Check your internet connection',textAlign: TextAlign.center,style: TextStyle(fontSize: 28,color: Colors.black),),
                // const SizedBox(height: 25,),
                CircularProgressIndicator(),
              ],
            ),
          );
        } else if (snapShot.connectionState == ConnectionState.done && snapShot.data.docs.length != 0) {
          double height;
          if (snapShot.data!.docs.length <= 3) {
            height = 250 * double.parse('${snapShot.data!.docs.length}');
          } else {
            height = 900;
          }
          return Container(
            height: height,
            child: GridView.builder(
              itemCount: snapShot.data!.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 250,
                childAspectRatio: 1.5,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (ctx, index) {
                Color placeColor;
                if (snapShot.data!.docs[index]['colorIndex'] == "1") {
                  placeColor = const Color.fromRGBO(224, 32, 32, 1);
                } else if (snapShot.data!.docs[index]['colorIndex'] == "2") {
                  placeColor = const Color.fromRGBO(250, 100, 0, 1);
                } else if (snapShot.data!.docs[index]['colorIndex'] == "3") {
                  placeColor = const Color.fromRGBO(0, 221, 181, 1);
                } else {
                  placeColor = const Color.fromRGBO(224, 32, 32, 1);
                }
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  height: 650,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius:
                              const BorderRadius.all(
                                Radius.circular(16),
                              ),
                              child: HomeScreen.isConnected == true ? FadeInImage(
                                image: NetworkImage(snapShot
                                    .data.docs[index]
                                ['sectionImageUrl']),
                                placeholder:
                                    AssetImage('assets/images/noImageAvailable.jpg'),
                                height: 200,
                                width: 125,
                                fit: BoxFit.fill,
                              ) : Image.asset(
                                'assets/images/noConnection.png',
                                height: 200,
                                width: 125,
                                fit: BoxFit.fill,
                              ) ,
                            ),
                            alignment: Alignment.center,
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 10, top: 13),
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 25,
                              height: 25,
                              //color: Colors.blue,
                              child: null,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: placeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: 100,
                          child: Text(
                            snapShot.data!.docs[index]['sectionName'],
                            style: const TextStyle(fontSize: 15),
                          ))
                    ],
                  ),
                );
              },
            ),
          );
        }
       else {
          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No Sections',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                  Container(
                   margin: EdgeInsets.all(8),
                    child: Text(
                      'waite until this business added some',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}



UsersRateBottomSheet(context, placeId) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.only(top: 15.0),
        alignment: Alignment.center,
        child: const Text(
          'Reviews',
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      const SizedBox(
        height: 2.0,
      ),
      buildStarRaite(),
      FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('usersReveos')
            .doc(placeId)
            .collection('rateInfo')
            .get(),
        builder: (ctx, AsyncSnapshot snapShot) {
          return snapShot.connectionState == ConnectionState.done
              ? SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: snapShot.data.docs.length,
                    itemBuilder: (ctn, index) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 8.0),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(snapShot
                                            .data
                                            .docs[index]['profileImageUrl']),
                                        radius: 25,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapShot.data.docs[index]['name'],
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 1.5,
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(1.9),
                                            child:buildStarRaite(),
                                          ),
                                          const SizedBox(
                                            height: 1.5,
                                          ),
                                          Container(
                                            width: 300,
                                            child: Text(
                                              snapShot.data.docs[index]['rate'],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2.0,
                                          ),
                                          const Text(
                                            '5 minute ago',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 2.0,
                          ),
                        ],
                      );
                    },
                  ),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 150, horizontal: 187),
                  child: const CircularProgressIndicator());
        },
      ),
    ],
  );
}

 Row buildStarRaite() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      RatingBar(
        initialRating: 4,
        direction: Axis.horizontal,
        glow: true,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: 18,
        minRating: 1.0,
        maxRating: 5,
        updateOnDrag: false,
        ignoreGestures: true,
        ratingWidget: RatingWidget(
          full: const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          half: const Icon(
            Icons.star_half,
            color: Colors.amber,
          ),
          empty: const Icon(
            Icons.star_border,
            color: Colors.amber,
          ),
        ),
        itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
        onRatingUpdate: (rating) {},
      ),
      Text('${4.5}',style: TextStyle(fontSize: 12, color: Colors.grey),)
    ],
  );
}

class BuildButtomSheet extends StatefulWidget {
  final BuildContext context;
  final String placeId;
  final totleRait;

  BuildButtomSheet(
      {required this.context, required this.placeId, required this.totleRait});

  @override
  State<BuildButtomSheet> createState() => _BuildButtomSheetState();
}

class _BuildButtomSheetState extends State<BuildButtomSheet> {
  final user = FirebaseAuth.instance.currentUser;
  double reviewVal = 0.4;
  final TextEditingController _userRevew = TextEditingController();
  bool isUserRated = false;
  bool islodding = false;
  double totleRait = 0.0;
  final GlobalKey<FormState> formsKey = GlobalKey();

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

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: islodding,
      child: !isUserRated
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('NRL_Users')
                  .doc(user!.uid)
                  .get(),
              builder: (ctx, AsyncSnapshot snapShot) {
                return SizedBox(
                  height: 350,
                  child: ListView(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 12),
                        child: const Text(
                          'Rating',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      buildReviewStarForRating(),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20),
                        child: Form(
                          key: formsKey,
                          child: TextFormField(
                            scrollPadding: const EdgeInsets.only(bottom: 35),
                            controller: _userRevew,
                            autofocus: true,
                            key: const ValueKey('userReview'),
                            keyboardType: TextInputType.text,
                            autocorrect: true,
                            enableSuggestions: true,
                            textCapitalization: TextCapitalization.words,
                            maxLines: 5,
                            validator: (val) {
                              if (val!.isEmpty || val.length < 10) {
                                return 'please enter at lest 4 words';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      width: 0.0,
                                      color: Color.fromRGBO(243, 244, 252, 1)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      width: 0.0,
                                      color: Color.fromRGBO(243, 244, 252, 1)),
                                ),
                                label: const Text(
                                  'Place leave a rate',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                fillColor:
                                    const Color.fromRGBO(243, 244, 252, 1),
                                filled: true,
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                alignLabelWithHint: true),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 25),
                        child: RawMaterialButton(
                          splashColor: Colors.red,
                          fillColor: const Color.fromRGBO(241, 76, 76, 1),
                          highlightColor: Colors.red[200],
                          padding: const EdgeInsets.all(12),
                          focusColor: const Color.fromRGBO(241, 76, 76, 1),
                          autofocus: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: const [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'ok',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            sumbitRate(
                                snapShot.data['name'],
                                snapShot.data['profileImageUrl'],
                                widget.totleRait);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : UsersRateBottomSheet(widget.context, widget.placeId),
    );
  }

  sumbitRate(name, profileImage, totleRait) async {
    final isValid = formsKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid!) {
      changeIslodding();
      // int lenght = 0;
      // var dd = FirebaseFirestore.instance.collection('usersReveos').doc(widget.placeId).collection('rateInfo').snapshots().length;
      //   int count = await dd;
      //   print(count);
      // totleRait ;
      FirebaseFirestore.instance
          .collection('Buss_User')
          .doc(widget.placeId)
          .update({
        'totleRait': totleRait,
      });
      FirebaseFirestore.instance
          .collection('usersReveos')
          .doc(widget.placeId)
          .collection('rateInfo')
          .doc()
          .set({
        'rate': _userRevew.text,
        'name': name,
        'profileImageUrl': profileImage,
        'time': DateTime.now(),
        'totleRait': totleRait,
      }).then((value) async {
        setState(() {
          isUserRated = true;
        });
        changeIslodding();
      });
    }
  }

  Widget buildReviewStarForRating() {
    return Center(
      child: RatingBar(
        initialRating: 3,
        direction: Axis.horizontal,
        glow: true,
        glowColor: const Color.fromRGBO(241, 76, 76, 0.4),
        allowHalfRating: true,
        itemCount: 5,
        itemSize: 30,
        minRating: 1.0,
        maxRating: 5,
        updateOnDrag: false,
        ratingWidget: RatingWidget(
          full: const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          half: const Icon(
            Icons.star_half,
            color: Colors.amber,
          ),
          empty: const Icon(
            Icons.star_border,
            color: Color.fromRGBO(241, 76, 76, 0.8),
          ),
        ),
        itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
        onRatingUpdate: (rating) {
          setState(() {
            totleRait += rating;
          });
        },
      ),
    );
  }
}
