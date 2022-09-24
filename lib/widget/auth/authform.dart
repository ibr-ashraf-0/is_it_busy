import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isit_busy/NRL_User/homeScreen.dart';
import 'package:isit_busy/widget/auth/authScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../NRL_User/resetPassScreen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthForm extends StatefulWidget {
  final void Function(
      {required String name,
      required String email,
      required String password,
      required BuildContext ctx}) submiFun;

  AuthForm({required this.submiFun});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController confirmCont = TextEditingController();
  final GlobalKey<FormState> formsKey = GlobalKey();

  bool _obscureText = true;

  void GoToRest() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return ResetPassScreen();
      }),
    );
  }

  void goTo_signUp() {
    _passController.text = '';
    _emailController.text = '';
    setState(() {
      AuthScreenState.isSignUp = !AuthScreenState.isSignUp;
      AuthScreenState.isBusiness = false;
      AuthScreenState.userName = '';
    });
  }

  _submit() async {
    final isValid = formsKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid!) {
      formsKey.currentState!.save();
      widget.submiFun(
          name: AuthScreenState.userName,
          email: AuthScreenState.email,
          password: AuthScreenState.password,
          ctx: context);
    }if(!isValid){
      return;
    }
  }

  onToggle(int indx) {
    changeIslodding();
    if (indx == 0) {
      setState(() {
        AuthScreenState.isBusiness = false;
      });
    } else if(indx == 1){
      setState(() {
        AuthScreenState.isBusiness = true;
      });
    }

    changeIslodding();
  }

  bool button1Color = true;
  bool button2Color = false;
  bool islodding = false;

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

   signInWithFacebook() async {
    // try{
      final facebookLoginResult = await FacebookAuth.instance.login(
        // permissions: ['email', 'public_profile', 'user_birthday'],
        // loginBehavior:  LoginBehavior.dialogOnly,
      );
      print('facebookLoginResult = ${facebookLoginResult.accessToken?.token}');
      final facebookAuthCredential = FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
      final userData = await FacebookAuth.instance.getUserData();
      debugPrint('user email == ${userData['email']}');
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    // }catch(error){
    // print('error = $error');
    // }
    // return null;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: islodding,
      color: const Color.fromRGBO(243, 244, 252, 1),
      child: SingleChildScrollView(
        child: Form(
          key: formsKey,
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              if (!AuthScreenState.isSignUp)
                Container(
                  margin: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        height: 60,
                        child: TextButton.icon(
                          onPressed: () {
                            signInWithFacebook();
                          },
                          icon: const Icon(
                            Icons.facebook,
                            size: 23,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Facebook',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) =>
                                    const Color.fromRGBO(16, 107, 185, 1)),
                            elevation: MaterialStateProperty.all(2),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5.5,
                      ),
                      Container(
                       height: 60,
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4.5),
                                child: Image.asset(
                                  'assets/images/applyIcon.png',
                                  color: Colors.black,
                                  filterQuality: FilterQuality.high,
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                              Container(
                                child: Text(
                                  'Apple',
                                  style:
                                      TextStyle(fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          style: ButtonStyle(
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.black, width: 1.4),
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) =>
                                    const Color.fromRGBO(243, 244, 252, 1)),
                            elevation: MaterialStateProperty.all(2),
                            overlayColor:
                                MaterialStateProperty.all(Colors.black12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height:AuthScreenState.isSignUp == true ? 0 : 8,),
              if (!AuthScreenState.isSignUp)
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Center(
                    child: Text(
                      'or sign up with email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),
              SizedBox(height:AuthScreenState.isSignUp == true ? 0 : 8,),
              if (AuthScreenState.isSignUp)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.zero,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: RawMaterialButton(
                          onPressed: () async {
                            setState(() {
                              button2Color = false;
                              button1Color = true;
                              AuthScreenState.isBusiness = false;
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool(
                                'isBussines', AuthScreenState.isBusiness);
                            },
                          child: Text(
                            'User',
                            style: TextStyle(
                              fontSize: 14,
                              color: button1Color == true
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          elevation: 0,
                          fillColor: button1Color == true
                              ? const Color.fromRGBO(248, 247, 251, 1)
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 0),
                          splashColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: RawMaterialButton(
                          onPressed: () async {
                            setState(() {
                              button2Color = true;
                              button1Color = false;
                              AuthScreenState.isBusiness = true;
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool(
                                'isBussines', AuthScreenState.isBusiness);
                             },
                          child: Text(
                            'Business',
                            style: TextStyle(
                              fontSize: 14,
                              color: button2Color == true
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          fillColor: button2Color == true
                              ? const Color.fromRGBO(248, 247, 251, 1)
                              : Colors.white,
                          elevation: 0,
                          // autofocus: true,
                          splashColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height:AuthScreenState.isSignUp == true ? 15 : 0,),
              if (AuthScreenState.isSignUp)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: TextFormField(
                    key: const ValueKey('name'),
                    autocorrect: true,
                    obscureText: false,
                    enableSuggestions: true,
                    textCapitalization: TextCapitalization.words,
                    validator: (val) {
                      if (val!.isEmpty || val.length < 4) {
                        return "Please enter at least 4 characters";
                      }
                      return null;
                    },
                    onSaved: (val) => AuthScreenState.userName = val!,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
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
                      label: const Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color.fromRGBO(241, 76, 76, 1),
                      ),
                    ),
                  ),
                ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: TextFormField(
                  controller: _emailController,
                  key: const ValueKey('email'),
                  autocorrect: true,
                  obscureText: false,
                  enableSuggestions: true,
                  textCapitalization: TextCapitalization.none,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 4) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                  onSaved: (val) => AuthScreenState.email = val!,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
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
                    label: const Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Color.fromRGBO(241, 76, 76, 1),
                    ),
                  ),
                ),
              ),
              if (AuthScreenState.isBusiness != false &&
                  AuthScreenState.isSignUp)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: TextFormField(
                    key: const ValueKey('location'),
                    autocorrect: true,
                    obscureText: false,
                    enableSuggestions: true,
                    textCapitalization: TextCapitalization.words,
                    validator: (val) {
                      if (val!.isEmpty || val.length < 4) {
                        return "Please enter your business location";
                      }
                      return null;
                    },
                    onSaved: (val) => AuthScreenState.bussLocation = val!,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
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
                      label: const Text(
                        'Location',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      prefixIcon: const Icon(
                        Icons.location_on,
                        color: Color.fromRGBO(241, 76, 76, 1),
                      ),
                    ),
                  ),
                ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: TextFormField(
                  controller: _passController,
                  key: ValueKey('password'),
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
                  onSaved: (val) => AuthScreenState.password = val!,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
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
                    label: const Text(
                      'Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color.fromRGBO(241, 76, 76, 1),
                    ),
                  ),
                ),
              ),
              if (!AuthScreenState.isSignUp)
                TextButton(
                  onPressed: GoToRest,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              if (AuthScreenState.isSignUp)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: TextFormField(
                    controller: confirmCont,
                    key: const ValueKey('confirmPassword'),
                    autocorrect: true,
                    obscureText: _obscureText,
                    enableSuggestions: true,
                    textCapitalization: TextCapitalization.none,
                    validator: (val) {
                      if (val != _passController.text ) {
                        return "passwords is not same";
                      }
                      return null;
                    },
                    onSaved: (val) => AuthScreenState.password = val!,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
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
                      label: const Text(
                        'Confirm Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromRGBO(241, 76, 76, 1),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color.fromRGBO(241, 76, 76, 1),
                      ),
                    ),
                  ),
                ),
            SizedBox(height:AuthScreenState.isSignUp == true ? 25 : 10,),
              Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.15,
                      height: 60,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.red.withOpacity(0.6),
                              spreadRadius: 0,
                              blurRadius: 50,
                              offset: const Offset(0,15)),
                        ],
                      ),
                      child: RawMaterialButton(
                        splashColor: Colors.red,
                        // for long pees color
                        fillColor: const Color.fromRGBO(241, 76, 76, 1),
                        highlightColor: Colors.red[200],
                        padding: const EdgeInsets.all(15),
                        focusColor: const Color.fromRGBO(241, 76, 76, 1),
                        autofocus: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                AuthScreenState.isSignUp == true
                                    ? 'Sign up'
                                    : 'Sign in',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AuthScreenState.isSignUp == true
                          ? 'Already have account?  '
                          : 'Don\'t have an account?  ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    RawMaterialButton(
                      onPressed: goTo_signUp,
                      child: Text(
                        AuthScreenState.isSignUp == true
                            ? 'Sign in'
                            : 'Sign up',
                        style: const TextStyle(
                          color: Color.fromRGBO(241, 76, 76, 1),
                        ),
                      ),
                      fillColor: Colors.red[200],
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      splashColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
