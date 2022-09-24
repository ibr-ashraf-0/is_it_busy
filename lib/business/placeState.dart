import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlaceState extends StatefulWidget {
  String? placeColor;
  PlaceState({required this.placeColor});
  @override
  _PlaceStateState createState() => _PlaceStateState();
}
final user = FirebaseAuth.instance.currentUser;

class _PlaceStateState extends State<PlaceState> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 35,
            height: 35,
            child: buildStatesOff(
              "1",
              const Color.fromRGBO(224, 32, 32, 1),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Container(
            width: 35,
            height: 35,
            child: buildStatesBusy(
              "2",
              const Color.fromRGBO(250, 100, 0, 1),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Container(
            width: 35,
            height: 35,
            child: buildStatesOn(
              "3",
              const Color.fromRGBO(0, 221, 181, 1),
            ),
          ),
        ],
      ),
    );
  }


Widget buildStatesOff(String indx, Color color) {
  return SizedBox(
    width: 45,
    height: 45,
    child: RawMaterialButton(
      focusElevation: 0,
      disabledElevation: 0,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100))),
      onPressed: () {
        setState(() {
          if (widget.placeColor == indx) {
            widget.placeColor = "0";
            FirebaseFirestore.instance.collection('Buss_User').doc(user!.uid).update({
              'colorIndex' : widget.placeColor,
            });
          } else {
            widget.placeColor = indx;
            FirebaseFirestore.instance.collection('Buss_User').doc(user!.uid).update({
              'colorIndex' : widget.placeColor,
            });
          }
        });
      },
      autofocus: false,
      fillColor: Colors.white,
      splashColor: color.withOpacity(0.6),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(1.5),
            margin: const EdgeInsets.all(0.2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: indx == widget.placeColor ? color : Colors.white,
            ),
            child: Container(
              padding: const EdgeInsets.all(1.2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Container(
                padding: const EdgeInsets.all(4.5),
                child: null,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildStatesBusy(String indx, Color _color) {
  return SizedBox(
    width: 45,
    height: 45,
    child: RawMaterialButton(
      focusElevation: 0,
      disabledElevation: 0,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100))),
      onPressed: () {
        setState(() {
          if (widget.placeColor == indx) {
            widget.placeColor = "0";
            FirebaseFirestore.instance.collection('Buss_User').doc(user!.uid).update({
              'colorIndex' : widget.placeColor,
            });
          } else {
            widget.placeColor = indx;
            FirebaseFirestore.instance.collection('Buss_User').doc(user!.uid).update({
              'colorIndex' : widget.placeColor,
            });
          }
        });
      },
      autofocus: false,
      fillColor: Colors.white,
      splashColor: _color.withOpacity(0.6),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(1.5),
            margin: const EdgeInsets.all(0.2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.placeColor == indx ? _color : Colors.white,
            ),
            child: Container(
              padding: const EdgeInsets.all(1.2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Container(
                padding: const EdgeInsets.all(4.5),
                child: null,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _color,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildStatesOn(String indx, Color color) {
  return SizedBox(
    width: 45,
    height: 45,
    child: RawMaterialButton(
      focusElevation: 0,
      disabledElevation: 0,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100))),
      onPressed: () {
        setState(() {
          if (widget.placeColor == indx) {
            widget.placeColor = "0";
            FirebaseFirestore.instance.collection('Buss_User').doc(user!.uid).update({
              'colorIndex' : widget.placeColor,
            });
          } else {
            widget.placeColor = indx;
            FirebaseFirestore.instance.collection('Buss_User').doc(user!.uid).update({
              'colorIndex' : widget.placeColor,
            });
          }
        });
      },
      autofocus: false,
      fillColor: Colors.white,
      splashColor: color.withOpacity(0.6),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(1.5),
            margin: const EdgeInsets.all(0.2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.placeColor == indx ? color : Colors.white,
            ),
            child: Container(
              padding: const EdgeInsets.all(1.2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Container(
                padding: const EdgeInsets.all(4.5),
                child: null,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}