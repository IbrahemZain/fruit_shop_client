import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/controller/getController.dart';
import '../widgets/home_widget.dart';
import '../size.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeControllers getController = Get.put(HomeControllers());
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  TextEditingController searchHolder = TextEditingController();
  String searchValue;

  final _form = GlobalKey<FormState>();
  bool _bottomLoading = false;
  bool check = true;

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController1.addListener(() {
      if (_scrollController1.position.pixels >=
          _scrollController1.position.maxScrollExtent) {
        setState(() {
          _bottomLoading = true;
        });
        getController.numOfPage = getController.numOfPage + 1;
        getData();
        setState(() {
          _bottomLoading = false;
        });
      }
    });
  }

  getData() {
    getController.getProducts();
  }

  Future _getAllDataRefresh() async {
    refreshKey.currentState?.show(atTop: true);
    await Future.delayed(Duration(seconds: 2));
    getController.numOfPage = 1;
    getData();
  }

  bool checkDataNotExist() {
    check = getController.allProducts == null ? true : false;
    return check;
  }

  void _submitForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    // getController.searchProduct(search: searchValue);
    Get.to(SearchScreen(
      searchValue: searchValue,
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = widthSize(context);
    final double deviceHeight = heightSize(context);

    return checkDataNotExist()
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _getAllDataRefresh,
            displacement: 5,
            child: ListView(
              controller: _scrollController1,
              children: [
                Form(
                  key: _form,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black12,
                    ),
                    child: TextFormField(
                      controller: searchHolder,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      textDirection: TextDirection.ltr,
                      onSaved: (value) {
                        setState(() {
                          searchValue = value;
                        });
                      },
                      onEditingComplete: () {
                        _submitForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Enter any word to search";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            _submitForm();
                          },
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      right: deviceWidth * .04,
                      top: deviceHeight * .003,
                      left: deviceWidth * .04,
                      bottom: deviceHeight * .003),
                  child: GetBuilder<HomeControllers>(
                    builder: (_) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: getController.allProducts.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) =>
                            HomeWidget(index, getController.allProducts[index]),
                        shrinkWrap: true,
                      );
                    },
                  ),
                ),
                _bottomLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(width: 0, height: 0),
              ],
            ),
          );
  }
}
