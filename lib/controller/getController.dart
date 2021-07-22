import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeControllers extends GetxController {
  List<dynamic> allProducts = [];
  List<dynamic> searchProducts = [];
  List<dynamic> allCards = [];
  List<dynamic> allOrders = [];
  int allPageCount;
  int numOfPage = 1;
  int allPageCountSearch;
  int numOfPageSearch = 1;
  bool isLoading = false;

  Future logInAuth(String phoneOrEmail, String password) async {
    try {
      final String uri = "https://gradubanana.herokuapp.com/client/login";
      var body =
          json.encode({"emailOrPhone": phoneOrEmail, "password": password});
      var response = await http.post(
        Uri.parse(uri),
        body: body,
        headers: {
          "Content-Type": "application/json",
        },
      );

      var message = jsonDecode(response.body);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      print("###################$message");

      if (message['state'] == 1) {
        sharedPreferences.setString('token', message['data']['token']);
        return 'success';
      } else {
        return 'error';
      }
    } catch (e) {
      print(e);
    }
  }

  Future signUpAuth({
    String email,
    String name,
    String mobile,
    String password,
    String comfirmPassword,
    String code,
    String sex,
    String city,
  }) async {
    String message = 'Check net connection';
    String uri = 'https://gradubanana.herokuapp.com/client/signup';
    var request = http.MultipartRequest('put', Uri.parse(uri));

    request.fields['email'] = email;
    request.fields['name'] = name;
    request.fields['mobile'] = mobile;
    request.fields['password'] = password;
    request.fields['comfirmPassword'] = comfirmPassword;
    request.fields['code'] = code;
    request.fields['sex'] = sex;
    request.fields['city'] = city;

    var res = await request.send();
    final respStr = await res.stream.bytesToString();
    Map<String, dynamic> jResponse = jsonDecode(respStr);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print("##############################$jResponse");
    if (jResponse['state'] == 1) {
      sharedPreferences.setString('token', jResponse['data']['token']);
      // sharedPreferences.setString('name', jResponse['data']['sellerName']);
      // sharedPreferences.setString('mobile', jResponse['data']['sellerMobile']);
      // sharedPreferences.setString('photo', jResponse['data']['sellerImage']);
      // sharedPreferences.setString('field', jResponse['data']['sellerEmail']);
      return "Authentication succeeded";
    } else {
      message = jResponse['message'];
      return message;
    }
  }

  Future getProducts() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String uri =
          "https://gradubanana.herokuapp.com/client/shop/getProducts?page=${numOfPage.toString()}&order=-1&date=1";
      var response = await http.get(Uri.parse(uri), headers: {
        "Authorization": "hh ${sharedPreferences.getString("token")}"
      });
      var message = jsonDecode(response.body);

      print("#######$message");

      if (message['state'] == 1) {
        allPageCount = (message['total'] / 10).floor().toInt();
        if (numOfPage == 1) {
          print("This is the products ### ${message['products']}");
          allProducts = message['products'];
        } else if (numOfPage < allPageCount) {
          allProducts.addAll(message['products']);
        }
        update();
        return message['products'];
      } else {
        return message['message'];
      }
    } catch (e) {
      print(e);
    }
  }

  Future searchProduct({String search}) async {
    try {
      final String uri = "https://gradubanana.herokuapp.com/search?search=$search";
      var response = await http.get(Uri.parse(uri));
      var message = jsonDecode(response.body);

      if (message['state'] == 1) {
        searchProducts = message['searchResult'];
        update();
        return "success";
      } else {
        return message['message'];
      }
    } catch (e) {
      print(e);
    }
  }

  Future addToCard(String productId, int amount) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String uri =
          "https://gradubanana.herokuapp.com/client/shop/cart/addProduct";

      var body =
          json.encode({"productId": productId, "amount": amount.toString()});

      var response = await http.put(
        Uri.parse(uri),
        body: body,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "hh ${sharedPreferences.getString("token")}"
        },
      );

      var message = jsonDecode(response.body);

      if (message['state'] == 1) {
        return "success";
      } else if (message['state'] == 0) {
        return message; //'fail';
      } else {
        return message; //'not connection';
      }
    } catch (e) {
      print(e);
    }
  }

  Future getCards() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String uri =
          "https://gradubanana.herokuapp.com/client/shop/getCart";

      var response = await http.get(
        Uri.parse(uri),
        headers: {
          "Authorization": "hh ${sharedPreferences.getString("token")}"
        },
      );

      var message = jsonDecode(response.body);

      // print("###############################$message");

      if (response.statusCode == 200) {
        allCards = message['cartItems'];
        print("###############################$allCards");

        update();
        return "success";
      } else {
        return response.body.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  Future deleteCard(String id) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String uri =
          'https://gradubanana.herokuapp.com/client/shop/cart/deleteItem';
      var body = json.encode({
        "productId": id.toString(),
      });

      var response = await http.delete(
        Uri.parse(uri),
        body: body,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "hh ${sharedPreferences.getString("token")}"
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  Future makeOrder(city, location) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String uri =
          "https://gradubanana.herokuapp.com/client/shop/makeOrder";

      var body =
          json.encode({"locationName": city, "locationAddres": location});

      var response = await http.post(
        Uri.parse(uri),
        body: body,
        headers: {
          // "Content-Type": "application/json",
          // 'Accept': 'application/json',
          HttpHeaders.authorizationHeader:
              "Bearer ${sharedPreferences.getString("token")}"
        },
      );

      var message = jsonDecode(response.body);

      print("!@!12#!@#@!#!@# $message");

      if (message['message'] == "order created") {
        return "success";
      } else if (message['message'] == 0) {
        return message; //'fail';
      } else {
        return message; //'not connection';
      }
    } catch (e) {
      print(e);
    }
  }

  Future getOrder({String status}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final String uri =
          "https://gradubanana.herokuapp.com/client/shop/getOrders?status=${status == null? '' : status}";

      var response = await http.get(
        Uri.parse(uri),
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer ${sharedPreferences.getString("token")}"
        },
      );

      var message = jsonDecode(response.body);
      print("###############################$message");
      if (response.statusCode == 200) {
        allOrders = message['orders'];
        print("###############################$allOrders");
        update();
        return "success";
      } else {
        return response.body.toString();
      }
    } catch (e) {
      print(e);
    }
  }
}
