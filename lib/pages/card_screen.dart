import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/controller/getController.dart';
import 'package:graduation_project/pages/main_screen.dart';
import 'package:graduation_project/widgets/card_widget.dart';

import '../size.dart';

class CardScreen extends StatefulWidget {
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final HomeControllers getController = Get.put(HomeControllers());
  ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String response;
  Timer timer;
  String stateOfCard;

  String city;
  String location;

  @override
  void initState() {
    getCard();
    timer = Timer.periodic(Duration(seconds: 0), (Timer t) => checkData());
    super.initState();
  }

  getCard() async {
    response = await getController.getCards();
    checkData();
  }

  checkData() {
    if (response == 'success') {
      if (getController.allCards.isEmpty) {
        setState(() {
          stateOfCard = 'empty';
        });
      } else if (getController.allCards.isNotEmpty) {
        setState(() {
          stateOfCard = 'has data';
        });
      } else {
        setState(() {
          stateOfCard = "loading";
        });
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    timer?.cancel();
    super.dispose();
  }

  //submit of add Order .
  void _submitForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    await getController.makeOrder(city, location).then((value) {
      if (value == 'success') {
        Get.offNamedUntil('/mainScreen', (route) => false);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(
                'Try again Later',
                textAlign: TextAlign.left,
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("Ok"),
                  onPressed: () {
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

  addOrder(parentContext) {
    return Get.defaultDialog(
        title: "Add To Order",
        cancel: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 10,
            // primary: Colors.amberAccent,
          ),
          onPressed: () {
            Get.back();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        confirm: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 10,
            // primary: Colors.amberAccent,
          ),
          onPressed: () {
            _submitForm();
          },
          child: Text(
            'Make Order',
            style: TextStyle(color: Colors.white),
          ),
        ),
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(alignment: Alignment.topLeft, child: Text("City:")),
              TextFormField(
                textAlign: TextAlign.left,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  hintText: 'Enter Your City',
                  hintStyle: TextStyle(color: Colors.black12),
                ),
                validator: (String value) {
                  if (value.isEmpty || value.length < 3) {
                    return 'Please enter your city';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    city = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Align(alignment: Alignment.topLeft, child: Text("Location:")),
              TextFormField(
                textAlign: TextAlign.left,
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  hintText: 'Enter Your Location',
                  hintStyle: TextStyle(color: Colors.black12),
                ),
                validator: (String value) {
                  if (value.isEmpty || value.length < 3) {
                    return 'Please enter your Location';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    location = value;
                  });
                },
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = widthSize(context);
    final double deviceHeight = heightSize(context);

    return stateOfCard == "has data"
        ? Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: deviceHeight * .01,
                  bottom: deviceHeight * .01,
                  left: deviceWidth * .01,
                  right: deviceWidth * .01,
                ),
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) =>
                      CardWidget(index),
                  itemCount: getController.allCards.length,
                  shrinkWrap: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height > 600
                        ? deviceHeight * .044
                        : deviceHeight * .07,
                    width: MediaQuery.of(context).size.height > 600
                        ? deviceWidth * .8
                        : deviceWidth * .6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        elevation: 10,
                        primary: Colors.amberAccent,
                      ),
                      onPressed: () {
                        addOrder(context);
                      },
                      child: Text(
                        'Make Order',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : (stateOfCard == "empty"
            ? Center(
                child: Text("Your Card is Empty"),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
