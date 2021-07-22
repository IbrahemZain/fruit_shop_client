import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/controller/getController.dart';
import '../size.dart';

class OrderWidget extends StatefulWidget {
  final int index;
  final Map<String, dynamic> order;
  OrderWidget(this.index,this.order);
  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
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

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = widthSize(context);
    final double deviceHeight = heightSize(context);
    return Container(
      width: deviceWidth * .31,
      height: MediaQuery.of(context).size.height > 600
          ? deviceHeight * .25
          : deviceHeight * .39,
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
            buildRowWidget('order Number: ', "${(widget.index + 1).toString()}"),
            buildRowWidget('Name: ', widget.order['products'][widget.index]['product']['name']),
            buildRowWidget('productType: ', widget.order['products'][widget.index]['product']['productType'].toString()),
            buildRowWidget('Fresh: ', widget.order['products'][widget.index]['product']['fresh'].toString()),
            buildRowWidget('price: ', widget.order['products'][widget.index]['product']['price'].toString() + ' Eg'),
            SizedBox(height: 10),
          ],
        )
    );
  }
}