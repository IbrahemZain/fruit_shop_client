import 'package:flutter/material.dart';
import '../controller/getController.dart';
import '../size.dart';
import 'package:get/get.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final HomeControllers getController = Get.put(HomeControllers());

  String selectedCity;
  String _password;
  String _phone;
  String _name;
  String _email;
  bool _buttonIsLoading = false;
  String selectedGender;
  bool _hidePass = true;
  bool _hideConfirmPass = true;
  final _form = GlobalKey<FormState>();

  List<dynamic> gender = ["male", "female"];

  List<dynamic> city = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Shubra El Kheima',
    'Port Said',
    'Suez',
    'El Mahalla El Kubra',
    'Luxor',
    'Mansoura',
    'Tanta',
    'Asyut',
    'Ismailia',
    'Faiyum',
    'Zagazig',
    'Damietta',
    'Aswan',
    'Minya',
    'Damanhur',
    'Beni Suef',
    'Hurghada',
    'Qena',
    'Sohag',
    'Shibin El Kom',
    'Banha',
    'Arish',
  ];

  void _submitForm() async {
    if (!_form.currentState.validate()) {
      setState(() {
        _buttonIsLoading = false;
      });
      return;
    }
    _form.currentState.save();
    getController
        .signUpAuth(
      name: _name,
      password: _password,
      comfirmPassword: _password,
      city: selectedCity,
      code: "2",
      mobile: _phone,
      sex: selectedGender,
      email: _email,
    )
        .then((value) {
      if (value == 'Authentication succeeded') {
        {
          Get.offNamedUntil('/mainScreen', (route) => false);
        }
      } else if (value == 'Check net connection') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Check connection",
                textAlign: TextAlign.left,
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Center(child: Text("Ok")),
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(
                value,
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

  Widget buildText({String textInfo}) {
    return Text(
      textInfo,
      style: TextStyle(color: Colors.black, fontSize: 18.0, inherit: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = widthSize(context);
    final double deviceHeight = heightSize(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account"),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            buildText(textInfo: 'Name'),
            TextFormField(
              textDirection: TextDirection.rtl,
              maxLength: 15,
              autovalidateMode: AutovalidateMode.always,
              textAlign: TextAlign.left,
              cursorColor: Colors.grey,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: 'Enter your Name',
                  hintStyle: TextStyle(color: Colors.black12)),
              onSaved: (value) {
                _name = value;
              },
              validator: (String value) {
                var _spaces = value.trim();
                if (value.isEmpty || _spaces.length < 5) {
                  return 'Please Enter correct Name';
                }
                if (value.length <= 3) {
                  return 'Name Must be more than 3 Character';
                }
                return null;
              },
            ),
            SizedBox(height: deviceHeight * .01),
            buildText(textInfo: 'Email'),
            TextFormField(
              textAlign: TextAlign.left,
              cursorColor: Colors.lightBlueAccent,
              // keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter your Email',
                hintStyle: TextStyle(
                  color: Colors.black12,
                ),
              ),
              validator: (String value) {
                if (value.isEmpty ||
                    value.length < 5 ||
                    !value.contains("@")) {
                  return 'Please Enter correct Email';
                }
                return null;
              },
              onSaved: (value) {},
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            SizedBox(height: deviceHeight * .01),
            buildText(textInfo: 'Phone Number'),
            Row(children: [
              Flexible(
                child: TextFormField(
                  textAlign: TextAlign.left,
                  cursorColor: Colors.lightBlueAccent,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter your Phone Number',
                    hintStyle: TextStyle(
                      color: Colors.black12,
                    ),
                  ),
                  validator: (String value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Please Enter correct Number';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                ),
              ),
              Icon(
                Icons.phone,
                color: Theme.of(context).primaryColor,
              ),
            ],),
            SizedBox(height: deviceHeight * .01),
            buildText(textInfo: 'Password'),
            Row(
              children: [
                Flexible(child: TextFormField(
                  maxLength: 30,
                  validator: (String value) {
                    if (value.isEmpty || value.length < 6) {
                      return 'Please Enter Password more than 6';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  textAlign: TextAlign.left,
                  cursorColor: Colors.grey,
                  style: TextStyle(color: Colors.black),
                  obscureText: _hidePass,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      counterText: '',
                      hintStyle: TextStyle(color: Colors.black12)),
                ),),
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
            SizedBox(height: deviceHeight * .01),
            buildText(textInfo: 'Confirm Password'),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    cursorColor: Colors.grey,
                    style: TextStyle(color: Colors.black),
                    validator: (String value) {
                      if (value != _password) {
                        return 'Not the same password';
                      }
                      return null;
                    },
                    obscureText: _hideConfirmPass,
                    decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: Colors.black12)),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _hideConfirmPass = !_hideConfirmPass;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: deviceHeight * .01),
            buildText(textInfo: 'Gender'),
            DropdownButtonFormField<dynamic>(
              autovalidateMode: AutovalidateMode.always,
              value: selectedGender,
              isExpanded: true,
              items: gender
                  .map((label) => DropdownMenuItem(
                  child: Container(
                      width: deviceWidth,
                      child: Text(
                        label.toString(),
                        textAlign: TextAlign.left,
                      )),
                  value: label))
                  .toList(),
              hint: Text(
                'Select Gender',
                textAlign: TextAlign.left,
              ),
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
              onSaved: (value) {
                setState(() {
                  selectedGender = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please Select the Gender';
                }
                return null;
              },
            ),
            SizedBox(height: deviceHeight * .01),
            buildText(textInfo: 'City'),
            DropdownButtonFormField<dynamic>(
              autovalidateMode: AutovalidateMode.always,
              value: selectedCity,
              isExpanded: true,
              items: city
                  .map((label) => DropdownMenuItem(
                  child: Container(
                      width: deviceWidth,
                      child: Text(
                        label.toString(),
                        textAlign: TextAlign.left,
                      )),
                  value: label))
                  .toList(),
              hint: Text(
                'Select City',
                textAlign: TextAlign.left,
              ),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                });
              },
              onSaved: (value) {
                setState(() {
                  selectedCity = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please Select the City';
                }
                return null;
              },
            ),
            SizedBox(height: deviceHeight * .01),
            !_buttonIsLoading
                ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                setState(() {
                  _buttonIsLoading = true;
                });
                _submitForm();
              },
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.black),
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
            Center(child: buildText(textInfo: 'Do you have Already account?')),
            SizedBox(height: deviceHeight * .01),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                Get.to(LoginScreen());
              },
              child: Text(
                'Log In',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
