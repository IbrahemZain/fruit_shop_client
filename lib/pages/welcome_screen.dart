import 'package:flutter/material.dart';
import '../size.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';

import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _notConnected = true;

  @override
  void initState() {
    checkConnection();
    super.initState();
  }

  checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _notConnected = true;
      });
    } else {
      setState(() {
        _notConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = widthSize(context);
    final double _deviceHeight = heightSize(context);

    Widget buildRaisedButton(nameOfButton, thePageReturned) {
      return Container(
        height: _deviceHeight*.05,
        width: _deviceWidth*.5,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              primary: Colors.amberAccent,
            ),
            child: Text(nameOfButton, style: TextStyle(color: Colors.black,fontSize: 20)),
            onPressed: () {
              !_notConnected
                  ? Get.to(thePageReturned)
                  : showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text(
                      'please connect to internet',
                      textAlign: TextAlign.right,
                    ),
                    actions: <Widget>[
                      // ignore: deprecated_member_use
                      ElevatedButton(
                        child: Center(child: Text("Ok")),
                        onPressed: () {
                          setState(() {
                            checkConnection();
                          });
                          Get.back();
                        },
                      ),
                    ],
                  );
                },
              );
            }),
      );
    }

    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        width: _deviceWidth,
        height: _deviceHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildRaisedButton('Log In', LoginScreen()),   //LoginScreen()
            SizedBox(height: _deviceHeight * .05),
            buildRaisedButton('Sign up', SignUpScreen()),
          ],
        ),
      ),
    );
  }
}
