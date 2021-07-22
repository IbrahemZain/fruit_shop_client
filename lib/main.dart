import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/pages/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuth = false;

  @override
  void initState() {
    checkAuth();
    super.initState();
  }

  checkAuth()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    if(token != null){
      setState(() {
        isAuth = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff9BE7E0),
        accentColor: Colors.amberAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Color(0xff9BE7E0),
          ),
        ),
      ),
      home: WelcomeScreen(), //isAuth == true ? MainScreen() :WelcomeScreen(),
      routes: {
        '/mainScreen':(context)=> MainScreen(),
      },
    );
  }
}