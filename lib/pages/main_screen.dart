import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/controller/getController.dart';
import 'card_screen.dart';
import 'home_screen.dart';
import 'order_screen.dart';

String stateOrder = "";

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final HomeControllers getController = Get.put(HomeControllers());

  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeScreen(),
    CardScreen(),
    OrderScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget textOfTitle(){
    if(_currentIndex == 0){
      return Text('Home Screen');
    }else if(_currentIndex == 1){
      return Text("Card Screen");
    }else{
      return Text("Order Screen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: textOfTitle(),
        backgroundColor: Theme.of(context).primaryColor,
        actions: _currentIndex == 2 ? [
        PopupMenuButton<String>(
          onSelected: (value) {
            print(value);
            if(value == "Started"){
              getController.getOrder(status: "started");
              setState(() {
                stateOrder="started";
              });
            }else if (value == "Ended"){
              getController.getOrder(status: "ended");
              setState(() {
                stateOrder="ended";
              });
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text('Started'),
                value: 'Started',
              ),
              PopupMenuItem(
                child: Text('Ended'),
                value: 'Ended',
              ),
            ];
          },
        ),
        ] : null ,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Theme.of(context).accentColor,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart,color: Theme.of(context).accentColor,),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart,color: Theme.of(context).accentColor,),
            label: 'Order',
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
