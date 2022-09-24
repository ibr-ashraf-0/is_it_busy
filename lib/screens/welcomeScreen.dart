import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widget/auth/authScreen.dart';

class WelcomeScreen extends StatelessWidget {
  final Uri _url = Uri.parse('https://flutter.dev');

  Future<void> _launchURL() async {
    if (!await launchUrl(_url,
        mode: LaunchMode.externalNonBrowserApplication)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    void pressedStart() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => AuthScreen(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 244, 252, 1),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/welcomePage_cover.png',
            filterQuality: FilterQuality.medium,
            fit: BoxFit.fill,
            width: double.infinity,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: Text(
                  'Welcome to\nIs It Busy',
                  style: TextStyle(
                      fontSize: 35,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18.0, top: 8),
                child: Text(
                  'Enjoy knowing the best tourist\nAreas around you',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                width: MediaQuery.of(context).size.width / 0.5,
                height: 60,
                child: RawMaterialButton(
                  splashColor: Colors.red,
                  fillColor: Colors.white,
                  highlightColor: Colors.red[200],
                  padding: const EdgeInsets.all(15),
                  focusColor: Colors.white,
                  autofocus: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  textStyle: const TextStyle(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 30),
                          alignment: Alignment.center,
                          child: const Text(
                            'Get Started',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.redAccent,
                        size: 30,
                      ),
                    ],
                  ),
                  onPressed: pressedStart,
                ),
              ),
              Container(
                height: 22,
                padding: const EdgeInsets.only(left: 18.0, bottom: 1),
                child: Row(
                  children: [
                    const Text(
                      'By clicking below you agree our',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.43),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 1.2, horizontal: 2.9),
                        ),
                      ),
                      onPressed: _launchURL,
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                padding: const EdgeInsets.only(left: 18.0, bottom: 20, top: 0),
                child: Row(
                  children: [
                    const Text(
                      'and',
                      style:
                          TextStyle(color: Color.fromRGBO(255, 255, 255, 0.43)),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 1.2, horizontal: 2.9),
                        ),
                      ),
                      onPressed: _launchURL,
                      child: const Text(
                        'Terms of Service',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
