import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'editBussPage.dart';


class EditBussScreen extends StatefulWidget {
  static  String profileBussImage = '';
  @override
  EditBussScreenState createState() => EditBussScreenState();
}




class EditBussScreenState extends State<EditBussScreen> {
  static XFile? profilFile;
  TextEditingController newLoctionCoon = TextEditingController();
  TextEditingController newEmailCoon = TextEditingController();
  TextEditingController newUserNameCoon = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();
  bool? isAddProfileImage;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {



    ImagePicker _picker = ImagePicker();
    void _pickImage() async {
      final pickedImageFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImageFile != null) {
        setState(() {
          profilFile = XFile(pickedImageFile.path);
        });
      } else {
        print('No Image Selcted');
      }
    }

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
                return EditBussPage();
              }),
            ),
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w300, color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: const Color.fromRGBO(243, 244, 252, 1),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 35),
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor:
                              const Color.fromRGBO(243, 244, 252, 1),
                          backgroundImage: profilFile != null
                              ? FileImage(File(profilFile!.path))
                                  as ImageProvider<Object>?
                              : const AssetImage(
                                  'assets/images/noImage.png',
                                ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 25, left: 77),
                      child: Icon(
                        profilFile == null ? Icons.add_circle : Icons.done,
                        size: 22,
                        color: const Color.fromRGBO(241, 76, 76, 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          key: const ValueKey('name'),
                          controller: newUserNameCoon,
                          autocorrect: false,
                          obscureText: false,
                          enableSuggestions: true,
                          textCapitalization: TextCapitalization.words,
                          validator: (val) {
                            if (val!.isEmpty || val.length < 4) {
                              return "Please enter at least 4 characters for your business name";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            setState(() {
                              newUserNameCoon.text = val!;
                            });
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                  width: 0.0, color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.redAccent),
                            ),
                            label: const Text(
                              'Name',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color.fromRGBO(241, 76, 76, 1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          key: const ValueKey('email'),
                          controller: newEmailCoon,
                          autocorrect: true,
                          obscureText: false,
                          enableSuggestions: true,
                          textCapitalization: TextCapitalization.none,
                          validator: (val) {
                            if (val!.isEmpty || val.length < 4) {
                              return "Please enter a new email address";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            setState(() {
                              newEmailCoon.text = val!;
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                  width: 0.0, color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.redAccent),
                            ),
                            label: const Text(
                              'Email',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color.fromRGBO(241, 76, 76, 1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          key: const ValueKey('location'),
                          controller: newLoctionCoon,
                          autocorrect: true,
                          obscureText: false,
                          enableSuggestions: true,
                          textCapitalization: TextCapitalization.words,
                          validator: (val) {
                            if (val!.isEmpty || val.length < 4) {
                              return "Please enter a new business location";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            setState(() {
                              newLoctionCoon.text = val!;
                            });
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                  width: 0.0, color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                  width: 3, color: Colors.redAccent),
                            ),
                            label: const Text(
                              'Location',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.location_on_outlined,
                              color: Color.fromRGBO(241, 76, 76, 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.red.withOpacity(0.6),
                            spreadRadius: 0,
                            blurRadius: 30,
                            offset: const Offset(0, 15)),
                      ],
                    ),
                    child: RawMaterialButton(
                      splashColor: Colors.red,
                      fillColor: const Color.fromRGBO(241, 76, 76, 1),
                      highlightColor: Colors.red[200],
                      focusColor: const Color.fromRGBO(241, 76, 76, 1),
                      autofocus: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Save',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        final isValid = formKey.currentState?.validate();
                        if (isValid!) {
                          formKey.currentState!.save();
                          final storage = FirebaseStorage.instance
                              .ref()
                              .child('UserData')
                              .child(user!.uid + 'profilePicture');
                          await storage
                              .putFile(File(profilFile!.path))
                              .then((_) async {
                            isAddProfileImage = true;
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool(
                                'isAddProfileImage', isAddProfileImage!);
                          });
                          String url = await storage.getDownloadURL();
                          setState(() {
                            EditBussScreen.profileBussImage = url ;
                          });
                          FocusScope.of(context).unfocus();
                          await FirebaseFirestore.instance
                              .collection('Buss_User')
                              .doc(user!.uid)
                              .update({
                            'name': newUserNameCoon.text,
                            'email': newEmailCoon.text,
                            'location': newLoctionCoon.text,
                            'profileImageUrl': url,
                          }).then(
                            (_) async {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text('your information are updated'),
                                backgroundColor: Colors.green,
                              ));
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
                MediaQuery.of(context).orientation == Orientation.landscape ? SizedBox(
                  height: 40,
                ) : const SizedBox(),
              ],
            ),
          ),
        ));
  }
}
