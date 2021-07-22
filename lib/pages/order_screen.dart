import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/controller/getController.dart';
import 'package:graduation_project/size.dart';
import 'package:graduation_project/widgets/order_widget.dart';
import 'main_screen.dart' as main;


class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final HomeControllers getController = Get.put(HomeControllers());
  ScrollController scrollController = ScrollController();

  String response;
  Timer timer;
  String stateOfOrder;

  @override
  void initState() {
    getOrder();
    timer = Timer.periodic(Duration(seconds: 0), (Timer t) => checkData());
    super.initState();
  }

  getOrder() async {
    if(main.stateOrder == "started"){
      response = await getController.getOrder(status: 'started');
    }else if(main.stateOrder == "ended"){
      response = await getController.getOrder(status: 'ended');
    }else{
      response = await getController.getOrder(status: '');
    }
    checkData();
  }

  checkData() {
    if (response == 'success') {
      if (getController.allOrders.isEmpty) {
        setState(() {
          stateOfOrder = 'empty';
        });
      } else if (getController.allOrders.isNotEmpty) {
        setState(() {
          stateOfOrder = 'has data';
        });
      } else {
        setState(() {
          stateOfOrder = "loading";
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

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = widthSize(context);
    final double deviceHeight = heightSize(context);

    return stateOfOrder == "has data"
        ? Container(
            margin: EdgeInsets.only(
              top: deviceHeight * .01,
              bottom: deviceHeight * .01,
              left: deviceWidth * .01,
              right: deviceWidth * .01,
            ),
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, index) =>
                  OrderWidget(index,getController.allOrders[index]),
              itemCount: getController.allOrders.length,
              shrinkWrap: true,
            ),
          )
        : (stateOfOrder == "empty"
            ? Center(
                child: Text("Your Orders is Empty"),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
