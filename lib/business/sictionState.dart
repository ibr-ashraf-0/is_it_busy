import 'package:flutter/material.dart';


class SictionState extends StatefulWidget {
  @override
  SictionStateState createState() => SictionStateState();
}



class SictionStateState extends State<SictionState> {
 static String curantIndx = "1";
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10.0, horizontal: 15),
        height: 60,
        width: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: buildStatesBusy(
               "1",
                Colors.red,
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            Container(
              child: buildStatesBusy(
                "2",
                const Color.fromRGBO(250, 100, 0, 1),
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            Container(
              child: buildStatesOn(
                "3",
                const Color.fromRGBO(0, 221, 181, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildStatesOff(String indx, Color color) {
    return  SizedBox(
            width: 35,
            height: 35,
            child: RawMaterialButton(
              focusElevation: 0,
              disabledElevation: 0,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              onPressed: () {
                setState(() {
                  if (curantIndx == indx) {
                    curantIndx = "0";
                  } else {
                    curantIndx = indx;
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
                      color: indx == curantIndx ? color : Colors.white,
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
      width: 35,
      height: 35,
      child: RawMaterialButton(
        focusElevation: 0,
        disabledElevation: 0,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onPressed: () {
          setState(() {
            if (curantIndx == indx) {
              curantIndx = "0";
            } else {
              curantIndx = indx;
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
                color: curantIndx == indx ? _color : Colors.white,
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
      width: 35,
      height: 35,
      child: RawMaterialButton(
        focusElevation: 0,
        disabledElevation: 0,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onPressed: () {
          setState(() {
            if (curantIndx == indx) {
              curantIndx = "0";
            } else {
              curantIndx = indx;
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
                color: curantIndx == indx ? color : Colors.white,
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