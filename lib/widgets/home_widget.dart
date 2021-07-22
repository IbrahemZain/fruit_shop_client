import 'dart:async';
import 'package:flutter/material.dart';
import '../size.dart';
import 'package:get/get.dart';
import '../controller/getController.dart';

class HomeWidget extends StatefulWidget {
  final int index;
  final Map<String, dynamic> product;

  HomeWidget(this.index, this.product);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final HomeControllers getController = Get.put(HomeControllers());
  int amount = 1;

  Future addCard() async {
    final String message =
        await getController.addToCard(widget.product['_id'].toString(), amount);
    if (message == "success") {
      Get.snackbar(
        "Added To Card",
        "Success",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey,
        colorText: Theme.of(context).accentColor,
      );
    } else {
      print(message);
    }
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

    return Container(
      width: deviceWidth * .31,
      height: MediaQuery.of(context).size.height > 600
          ? deviceHeight * .14
          : deviceHeight * .2,
      margin: EdgeInsets.symmetric(
        horizontal: deviceWidth * .01,
        vertical: deviceHeight * .01,
      ),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: -5,
              blurRadius: 5,
              offset: Offset(0, 13), // changes position of shadow
            ),
          ],
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.black, width: 1)),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: deviceHeight * .005,
            right: deviceWidth * .65,
            left: deviceWidth * .03,
            bottom: deviceHeight * .005,
            child: ClipOval(
              child: Image.network(
                widget.product['imageUrl'].toString(),
                 fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: deviceHeight * .005,
            left: deviceWidth * .30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(textInfo: "Name: ${widget.product['name'].toString()}"),
                SizedBox(height: deviceHeight * .01),
                buildText(textInfo: "Price: ${widget.product['price'].toString()} Eg"),
                SizedBox(height: deviceHeight * .01),
                buildText(textInfo: "Fresh: ${widget.product['fresh']..toString()}"),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.add, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            amount++;
                          });
                        }), //getController.increaseAmount()),
                    Text("$amount"),
                    IconButton(
                        icon: Icon(Icons.remove),
                        color: Colors.black,
                        onPressed: () {
                          setState(() {
                            amount==1 ? print("amount cant be minus") : amount--;
                          });
                        }) //getController.decreaseAmount()),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: deviceHeight * .025,
            right: deviceWidth * .03,
            child: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: addCard,
              iconSize: 26,
            ),
          ),
        ],
      ),
    );
  }
}
