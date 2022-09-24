import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isit_busy/NRL_User/editPage.dart';

class UserFavorite extends StatefulWidget {
  final String placeId;
  UserFavorite({required this.placeId});
  @override
  State<UserFavorite> createState() => _UserFavoriteState();
}

class _UserFavoriteState extends State<UserFavorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(
            MaterialPageRoute(builder: (BuildContext context) {
              return EditPage();
            }),
          ),
        ),
        title: const Text(
          'My Favorite',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('FavoritePLC').doc(user!.uid).collection('placeData').get(),
        builder: (context ,AsyncSnapshot snapShot){

          return snapShot.connectionState == ConnectionState.done ?
          Container(
            height: 850,
            color: const Color.fromRGBO(243, 244, 252, 1),
            child: snapShot.data.docs.length != 0 ? ListView.builder(
              itemCount: snapShot.data!.docs.length,
              itemBuilder: (ctx , indx){
                Color placeColor;
                if( snapShot.data.docs[indx]['colorIndex'] == "1"){
                  placeColor = const Color.fromRGBO(224, 32, 32, 1);
                }else if(snapShot.data.docs[indx]['colorIndex'] == "2"){
                  placeColor = const Color.fromRGBO(250, 100, 0, 1);
                }else if (snapShot.data.docs[indx]['colorIndex'] == "3"){
                  placeColor = const Color.fromRGBO( 0, 221, 181, 1);
                }else {
                  placeColor =  const Color.fromRGBO(224, 32, 32, 1);
                }
                return  Container(
                  width: double.infinity,
                  height: 120,
                  margin: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
                              height: 68,
                              width: 60,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      filterQuality:
                                      FilterQuality.high,
                                      fit: BoxFit.fill,
                                      image:
                                      NetworkImage(snapShot.data.docs[indx]['profileImageUrl'] != "null"
                                          ? snapShot.data.docs[indx]['profileImageUrl']
                                          : 'http://www.ncenet.com/wp-content/uploads/2020/04/No-image-found.jpg'
                                      )
                                  ),
                                  borderRadius: BorderRadius.circular(16.0)),
                            ),
                            Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width - 105,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(top: 15, left:0),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children:  [
                                                Container(
                                                  margin: EdgeInsets.zero,
                                                  height: 13,
                                                  width: 13,
                                                  child: const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 13,
                                                  ),
                                                ),
                                                const Text(
                                                  '(${0.4})',
                                                  style:
                                                  TextStyle(fontSize: 9),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 11,),
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 3),
                                              decoration:  BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: placeColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      snapShot.data.docs[indx]['name'],
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,),
                                    ),
                                    const SizedBox(
                                      height: 2.0,
                                    ),
                                    Container(
                                      margin: EdgeInsets.zero,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children:  [
                                          Container(
                                            height: 13,
                                            width: 13,
                                            margin:  EdgeInsets.zero,
                                            child: const Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.grey,
                                              size: 13,
                                            ),
                                          ),
                                          Container(
                                            width: 250,
                                            height: 35,
                                            child: Text(
                                              snapShot.data.docs[indx]['location'],
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            ) : Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                  vertical: 310, horizontal: 15),
              color: const Color.fromRGBO(243, 244, 252, 1),
              child:  Container(
                child: const Text('You Have no favorites yet\nstart adding some !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                ),
                ),),),
          ) :
          Container(
            height: MediaQuery.of(context).size.height,
            width:  MediaQuery.of(context).size.width,
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
