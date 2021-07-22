import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/controller/getController.dart';
import '../size.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final HomeControllers getController = Get.put(HomeControllers());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String phoneOrEmail;
  String password;
  bool _hidePass = true;
  bool _buttonIsLoading = false;

  Widget buildText({String textInfo}) {
    return Text(
      textInfo,
      style: TextStyle(color: Colors.black, fontSize: 18.0, inherit: false),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState.validate()) {
      setState(() {
        _buttonIsLoading = false;
      });
      return;
    }
    _formKey.currentState.save();

    await getController.logInAuth(phoneOrEmail, password).then((value) {
      if (value == 'success') {
        {
          Get.offNamedUntil('/mainScreen', (route) => false);
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(
                'Incorrect Password',
                textAlign: TextAlign.left,
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
                    setState(() {
                      _buttonIsLoading = false;
                    });
                    Get.back();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = widthSize(context);
    final double deviceHeight = heightSize(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Login in"),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: new ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(15),
            children: [
              buildText(textInfo: 'Phone number Or Email'),
              TextFormField(
                textAlign: TextAlign.left,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number Or Email',
                  hintStyle: TextStyle(color: Colors.black12),
                ),
                validator: (String value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Please enter your phone number Or Email';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    phoneOrEmail = value;
                  });
                },
              ),
              SizedBox(
                height: deviceHeight * .01,
              ),
              buildText(textInfo: 'Password'),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      cursorColor: Colors.grey,
                      obscureText: _hidePass,
                      decoration: InputDecoration(
                        hintText: 'Enter your Password',
                        hintStyle: TextStyle(color: Colors.black12),
                      ),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter password more than 6';
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _hidePass = !_hidePass;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: deviceHeight * .04,
              ),
              !_buttonIsLoading
                  ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 10,
                ),
                onPressed: () {
                  setState(() {
                    _buttonIsLoading = true;
                  });
                  _submitForm();
                },
                child: Text(
                  'Log In',
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: deviceHeight * .01),
              Center(child: buildText(textInfo: 'you do not have account')),
              SizedBox(height: deviceHeight * .01),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 10,
                ),
                // elevation: 10,
                onPressed: () {
                  Get.to(SignUpScreen());
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
