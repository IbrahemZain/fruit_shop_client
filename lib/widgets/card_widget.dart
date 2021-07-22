import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/controller/getController.dart';
import '../size.dart';

class CardWidget extends StatefulWidget {
  final int index;
  CardWidget(this.index);
  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  final HomeControllers getController = Get.put(HomeControllers());

  Widget buildRowWidget(String name, String value) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 15),
      child: Row(
        children: [
          Text(
            '$name:',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          SizedBox(width: 30),
          Text(
            '$value',
            style: TextStyle(color: Colors.black45, fontSize: 15),
          ),
        ],
      ),
    );
  }
  Future deleteCard() async {
    final bool message = await getController
        .deleteCard(getController.allCards[widget.index]['_id'].toString());
    if (message == true) {
      Get.snackbar(
        "Deleted Card",
        "Success",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey,
        colorText: Theme.of(context).accentColor,
      );
      getController.getCards();
    } else {
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = widthSize(context);
    final double deviceHeight = heightSize(context);

    return Container(
        width: deviceWidth * .31,
        height: MediaQuery.of(context).size.height > 600
            ? deviceHeight * .24
            : deviceHeight * .36,
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
                offset: Offset(0, 13),
              ),
            ],
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.black, width: 1)),
        child: Column(
          children: [
            buildRowWidget('order Number', "${(widget.index + 1).toString()}"),
            buildRowWidget('fruits Kind',
                getController.allCards[widget.index]['product']['name']),
            buildRowWidget('amount',
                getController.allCards[widget.index]['amount'].toString()),
            buildRowWidget(
                'price',
                getController.allCards[widget.index]['totalPrice'].toString() +
                    ' Eg'),
            // buildRowWidget('location', "Suez"),
            //allOrder[widget.index]['location']),
            // buildRowWidget('date', "24/5"),
            SizedBox(
              height: 12,
            ),
            Container(
              height: MediaQuery.of(context).size.height > 600
                  ? deviceHeight * .044
                  : deviceHeight * .07,
              width: MediaQuery.of(context).size.height > 600
                  ? deviceWidth * .8
                  : deviceWidth * .6,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  primary: Colors.red,
                ),
                onPressed: () {
                  deleteCard();
                },
                child: Text('Delete Card'),
              ),
            )
          ],
        ));
  }
}
