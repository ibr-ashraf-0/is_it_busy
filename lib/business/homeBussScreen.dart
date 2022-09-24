import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isit_busy/utils/helpers.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../NRL_User/homeScreen.dart';
import 'editBussPage.dart';
import 'placeSiction.dart';
import 'placeState.dart';
import 'sictionState.dart';

class HomeBussScreen extends StatefulWidget {
  @override
  State<HomeBussScreen> createState() => HomeBussScreenState();
}

class HomeBussScreenState extends State<HomeBussScreen> with Helpers {
  bool? isAddProfileImage;
  bool? isAddSiction;
  String? placeColor;
  @override
  void initState() {
    HomeScreen.checkInternetConnectivity();
    HomeBussScreenState();
    PlaceSectionState();
    super.initState();
  }

  @override
  Widget build(BuildContext contextt) {
    Future<void> getData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      isAddProfileImage = prefs.getBool('isAddProfileImage');
    }
    getData();
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 244, 252, 1),
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 80,
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        leading: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('Buss_User')
              .doc(user!.uid)
              .get(),
          builder: (coontext, AsyncSnapshot snapShot) {
            if(snapShot.connectionState != ConnectionState.done){
              return Container(
                  padding: const EdgeInsets.only(left: 15, top: 11, bottom: 11),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) {
                            return EditBussPage();
                          }),
                    );
                  },
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey,
                    child: Text('loading...',textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black),),
                  ),
                ),
              );
            }
            return Container(
              padding: const EdgeInsets.only(left: 15, top: 13, bottom: 13),
            alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) {
                          return EditBussPage();
                        }),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 30,
                  backgroundImage:(snapShot.connectionState == ConnectionState.done  && snapShot.data["profileImageUrl"] != "null" && HomeScreen.isConnected == true )
                      ? NetworkImage(
                    snapShot.data["profileImageUrl"],
                  )
                      : AssetImage('assets/images/noImage.png')
                  as ImageProvider<Object>,
                ),
              ),
            );
          },
        ),

        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Home',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 20),
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return await Future.delayed(
            const Duration(seconds: 3),
            () async {
              setState(() {
                HomeScreen.checkInternetConnectivity();
                PlaceSectionState();
              });
            },
          );
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8,),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                        child: Text(
                          'States',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(alignment : Alignment.centerLeft,        margin: EdgeInsets.only(right: 10),
                          child: PlaceState(placeColor : placeColor)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                PlaceSection(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(241, 76, 76, 1),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return BuildSheetContent(ctx: ctx);
              });
        },
      ),
    );
  }
}

class BuildSheetContent extends StatefulWidget {
  BuildContext ctx;

  BuildSheetContent({required this.ctx});

  @override
  State<BuildSheetContent> createState() => _BuildSheetContentState();
}

class _BuildSheetContentState extends State<BuildSheetContent> with Helpers {
  final user = FirebaseAuth.instance.currentUser;
  String sectionName = '';
  bool isAddSiction = true;
  bool islodding = false;
  XFile? _fileImage;
  TextEditingController sectionNameController = TextEditingController();
  ImagePicker _picker = ImagePicker();

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

  void _pickImage() async {
    final pickedImageFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      _fileImage = XFile(pickedImageFile.path);
    } else {
      print('No Image Selcted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.56),
        body: ModalProgressHUD(
          child: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: StatefulBuilder(builder: (coontext, StateSetter setState) {
              return ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30.0),
                    child: const Text(
                      'New Section',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color.fromRGBO(249, 249, 249, 1),
                        backgroundImage: _fileImage != null
                            ? FileImage(File(_fileImage!.path))
                                as ImageProvider<Object>?
                            : null,
                        child: _fileImage == null
                            ? const Icon(
                                Icons.camera_alt,
                                color: Color.fromRGBO(241, 76, 76, 1),
                                size: 30,
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: TextFormField(
                      key: const ValueKey('section'),
                      autocorrect: true,
                      controller: sectionNameController,
                      enableSuggestions: true,
                      textCapitalization: TextCapitalization.words,
                      validator: (String? vall) {
                        if (vall!.isEmpty) {
                          return "Please enter your section name";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          sectionNameController.text = val!;
                        });
                      },
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        fillColor: const Color.fromRGBO(243, 244, 252, 1),
                        filled: true,
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
                          'Section Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Container(
                      height: 57,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: const Color.fromRGBO(243, 244, 252, 1),
                              style: BorderStyle.solid)),
                      child: Container(
                        height: 56,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 18.0),
                              child: Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SictionState(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 52,
                    width: 250,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.red.withOpacity(0.6),
                            spreadRadius: 0,
                            blurRadius: 30,
                            offset: const Offset(0, 15)),
                      ],
                    ),
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: RawMaterialButton(
                        splashColor: Colors.red,
                        fillColor: const Color.fromRGBO(241, 76, 76, 1),
                        highlightColor: Colors.red[200],
                        padding: const EdgeInsets.all(15),
                        focusColor: const Color.fromRGBO(241, 76, 76, 1),
                        autofocus: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: 380,
                          child: const Text(
                            'Add',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_fileImage == null) {
                            Future.delayed(
                              const Duration(seconds: 0),
                              () {
                                showSnackBar(
                                  context: widget.ctx,
                                  message: 'place enter you\'re section image',
                                  error: true,
                                  textAlign: TextAlign.center,
                                  width: 300.0,
                                  shape: ShapeBorder.lerp(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      5),
                                );
                              },
                            );
                            return;
                          } else if (sectionNameController.text == '') {
                            Future.delayed(const Duration(seconds: 0), () {
                              showSnackBar(
                                context: widget.ctx,
                                message: 'pleace enter you\'re section name',
                                error: true,
                                textAlign: TextAlign.center,
                                width: 300.0,
                                shape: ShapeBorder.lerp(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    5),
                              );
                            });
                            return;
                          }
                          changeIslodding();
                          try {
                            final storage = FirebaseStorage.instance
                                .ref()
                                .child('UserData')
                                .child(user!.uid +
                                    'section' +
                                    sectionNameController.text);
                            storage
                                .putFile(File(_fileImage!.path))
                                .then((taskSnapshot) async {
                              if (taskSnapshot.state == TaskState.success) {
                                String url = await storage.getDownloadURL();
                                await FirebaseFirestore.instance
                                    .collection('sectionData')
                                    .doc(user!.uid)
                                    .collection('sections')
                                    .doc()
                                    .set({
                                  'colorIndex' : SictionStateState.curantIndx,
                                  'sectionName': sectionNameController.text,
                                  'sectionImageUrl': url,
                                  "colorIndex" : "0",
                                }).then((_) async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  pref.setBool('isAddSiction', isAddSiction);
                                });
                                changeIslodding();
                                sectionNameController.text = '';
                                _fileImage = null;
                                showSnackBar(
                                    context: widget.ctx,
                                    message: 'your section added',
                                    error: false,
                                    shape: ShapeBorder.lerp(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        5),
                                    width: 250,
                                    textAlign: TextAlign.center);
                              }
                            });
                          } catch (e) {
                            showSnackBar(
                                context: widget.ctx,
                                message:
                                    'something\'s error please check your cognition and try again',
                                error: true,
                                shape: ShapeBorder.lerp(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    5),
                                width: 250,
                                textAlign: TextAlign.start);
                          }
                        }),
                  ),
                  MediaQuery.of(coontext).orientation == Orientation.landscape ?  const SizedBox(
                    height: 45,
                  ):  const SizedBox(),
                ],
              );
            }),
          ),
          inAsyncCall: islodding,
        ));
  }
}
