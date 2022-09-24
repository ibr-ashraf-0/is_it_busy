import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
class EditScreen extends StatefulWidget {
  @override
  EditScreenState createState() => EditScreenState();
}

class EditScreenState extends State<EditScreen> {

  final GlobalKey<FormState> formKey = GlobalKey();
  static XFile? profilFile;
  String newLoctionCoon = '';
  String newEmailCoon = '';
  String newUserNameCoon = '';

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
            onPressed: () => Navigator.of(context).pop(),
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
                          backgroundColor: Colors.transparent,
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
                        margin: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                        child: TextFormField(
                          key: const ValueKey('name'),
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
                              newUserNameCoon = val!;
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
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                        child: TextFormField(
                          key: const ValueKey('email'),
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
                              newEmailCoon = val!;
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
                              Icons.email,
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
                 margin: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
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
                    fillColor: Theme.of(context).primaryColor,
                    highlightColor: Colors.red[200],
                    focusColor: const Color.fromRGBO(241, 76, 76, 1),
                    autofocus: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18,horizontal: 20),
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
                        FocusScope.of(context).unfocus();
                        await FirebaseFirestore.instance
                            .collection('NRL_Users')
                            .doc(user!.uid)
                            .update({
                          'name': newUserNameCoon,
                          'email': newEmailCoon,
                          'location': newLoctionCoon,
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
                MediaQuery.of(context).orientation == Orientation.landscape
                    ?  const SizedBox(
                  height: 40,
                ) : SizedBox(),
              ],
            ),
          ),
        ));
  }
}
