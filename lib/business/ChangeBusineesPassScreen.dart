import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isit_busy/utils/helpers.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'editBussPage.dart';

class ChangeBusineesPassScreen extends StatefulWidget {
  @override
  _ChangeBusineesPassScreenState createState() =>
      _ChangeBusineesPassScreenState();
}

class _ChangeBusineesPassScreenState extends State<ChangeBusineesPassScreen>   {
  @override
  Widget build(BuildContext context) {
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
            'Change Password',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Container(
          color: const Color.fromRGBO(243, 244, 252, 1),
            child: buildChangePassWidger(),
          )
    );
   }

}

class buildChangePassWidger extends StatefulWidget {
  @override
  State<buildChangePassWidger> createState() => _buildChangePassWidgerState();
}

class _buildChangePassWidgerState extends State<buildChangePassWidger> with Helpers {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _ConnewPasswrod = TextEditingController();
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final GlobalKey<FormState> formsKey = GlobalKey();
  final bool _obscureText = true;
  String currentPassword = '';
  bool islodding =false;

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
    return  ModalProgressHUD(
      color: const Color.fromRGBO(243, 244, 252, 1),
      child:  Container(
        color: const Color.fromRGBO(243, 244, 252, 1),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('Buss_User').doc(user!.uid).get(),
          builder: (ctx, AsyncSnapshot snapShot) {
            if (snapShot.connectionState == ConnectionState.done) {
              currentPassword = snapShot.data['password'];
              return Form(
                key: formsKey,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        controller: _currentPassController,
                        key: const ValueKey('currentPassword'),
                        autocorrect: true,
                        obscureText: _obscureText,
                        enableSuggestions: true,
                        textCapitalization: TextCapitalization.words,
                        validator: (val) {
                          if (val!.isEmpty || val.length < 4) {
                            return "Please enter at least 4 characters";
                          }
                          return null;
                        },
                        onSaved: (val) => _currentPassController.text = val!,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          prefix: const Text(
                            '|',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                            const BorderSide(width: 0.0, color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                            const BorderSide(width: 3, color: Colors.redAccent),
                          ),
                          label: Container(
                            padding: const EdgeInsets.only(left: 7),
                            child: const Text(
                              'Current password',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
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
                        controller: _newPasswordController,
                        key: const ValueKey('newPassword'),
                        autocorrect: true,
                        obscureText: _obscureText,
                        enableSuggestions: true,
                        textCapitalization: TextCapitalization.words,
                        validator: (val) {
                          if (val!.isEmpty || val.length < 4) {
                            return "Please enter at least 4 characters";
                          }
                          return null;
                        },
                        onSaved: (val) => _newPasswordController.text = val!,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          prefix: const Text(
                            '|',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                            const BorderSide(width: 0.0, color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                            const BorderSide(width: 3, color: Colors.redAccent),
                          ),
                          label: Container(
                            padding: const EdgeInsets.only(left: 7),
                            child: const Text(
                              'New password',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
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
                        controller: _ConnewPasswrod,
                        key: const ValueKey('repeatPassword'),
                        autocorrect: true,
                        obscureText: _obscureText,
                        enableSuggestions: true,
                        textCapitalization: TextCapitalization.words,
                        onSaved: (val) => _ConnewPasswrod.text = val!,
                        validator: (val) {
                          if (val!.isEmpty || val.length < 4) {
                            return "Please enter at least 4 characters";

                          } else if( _newPasswordController.text != _ConnewPasswrod.text){
                            return "Password not same";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          prefix: const Text(
                            '|',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                            const BorderSide(width: 0.0, color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                            const BorderSide(width: 3, color: Colors.redAccent),
                          ),
                          label: Container(
                            padding: const EdgeInsets.only(left: 7),
                            child: const Text(
                              'Repeat password',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
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
                      height: 40,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.red.withOpacity(0.6),
                                spreadRadius: 0,
                                blurRadius: 30,
                                offset: const Offset(0,15)),
                          ],
                        ),
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            final isValid = formsKey.currentState?.validate();
                            if (isValid!) {
                              if(currentPassword == _newPasswordController.text){
                                showSnackBar(
                                    context: context,
                                    message: 'New password Can\'t be as Current one ',
                                    error: true,
                                    shape: ShapeBorder.lerp(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                25)),
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                25)),
                                        5),
                                    width: 350,
                                    textAlign: TextAlign.start);
                              }
                            else if(currentPassword == _currentPassController.text) {
                                changeIslodding();
                                FirebaseFirestore.instance.collection('Buss_User').doc(user!.uid).update({
                                  'password' : _newPasswordController.text,
                                }).then((_) {
                                  changeIslodding();
                                  showSnackBar(
                                    width: 300,
                                    context: context,
                                    message: 'Password Updated',
                                    error: false,
                                    textAlign: TextAlign.center,
                                    shape: ShapeBorder.lerp(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                25)),
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                25)),
                                        5),
                                  );
                                });
                              }
                              else{
                                showSnackBar(
                                  width: 300,
                                  context: context,
                                  message: 'Your Currents password not correct',
                                  error: true,
                                  textAlign: TextAlign.center,
                                  shape: ShapeBorder.lerp(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              25)),
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              25)),
                                      5),
                                );
                              }
                            }else if(!isValid){
                              return;
                            }
                            else if(snapShot.connectionState == ConnectionState.none){
                              showSnackBar(
                                  context: context,
                                  message: 'something\'s error please check your cognition and try again',
                                  error: true,
                                  shape: ShapeBorder.lerp(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              25)),
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              25)),
                                      5),
                                  width: 350,
                                  textAlign: TextAlign.start);
                            }
                          },
                        ),
                      ),
                    ),
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ?  const SizedBox(
                      height: 40,
                    ) : SizedBox(),
                  ],
                ),
              );
            }
            else {
              return Container(
                color: const Color.fromRGBO(243, 244, 252, 1),
                height: double.infinity,);
            }
          },
        ),
      ),
      inAsyncCall: islodding,
    );
  }
}
