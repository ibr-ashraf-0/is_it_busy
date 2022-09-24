import 'package:flutter/material.dart';
import 'package:isit_busy/utils/helpers.dart';

class ResetPassScreen extends StatelessWidget  with Helpers{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 244, 252, 1),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(28, 8, 28, 8),
            child: Image.asset(
              'assets/images/logo.png',
              height: 200,
              width: 200,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 2, 0, 2),
            child: Text(
              'Reset your password',
              style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold, wordSpacing: 4),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            margin: EdgeInsets.only(left: 12),
            child: const Text(
              'lorem ipsum dolor sit amet, consectetur',
              style: TextStyle(
                fontSize: 18,

              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            margin: EdgeInsets.only(left: 12),
            child: const Text(
              'addipiscing elit, sed do elusmod',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextFormField(
              key: const ValueKey('resetPass'),
              autocorrect: false,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.none,
              validator: (val) {
                if (val!.isEmpty || !val.contains('@')) {
                  return "Please enter a valid email address";
                }
                return null;
              },
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
                      fontSize: 18,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Color.fromRGBO(241, 76, 76, 1),
                  )),
              style: TextStyle(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
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
                        "Send",
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
              onPressed:(){
    showSnackBar(context: context, message: 'Your Rest Url Sent to your email please check it', width: 250 , textAlign: TextAlign.start , error: false);
    },
            ),
          ),
        ],
      ),
    );
  }
}
