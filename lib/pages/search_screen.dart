import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduation_project/controller/getController.dart';
import 'package:graduation_project/widgets/search_widget.dart';
import '../size.dart';

class SearchScreen extends StatefulWidget {
  final searchValue;

  SearchScreen({this.searchValue});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final HomeControllers getController = Get.put(HomeControllers());
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController1 = ScrollController();
  String response;
  String stateOfSearch;

  // bool _bottomLoading = false;
  bool check = true;

  @override
  void initState() {
    super.initState();
    getSearchData();

    // _scrollController1.addListener(() {
    //   if (_scrollController1.position.pixels >=
    //       _scrollController1.position.maxScrollExtent) {
    //     setState(() {
    //       _bottomLoading = true;
    //     });
    //     print("21322222#########yes");
    //     // getController.numOfPageSearch = getController.numOfPageSearch + 1;
    //     getController.searchProduct(search: widget.searchValue);
    //     setState(() {
    //       _bottomLoading = false;
    //     });
    //   }
    // });
  }

  getSearchData() async {
    response = await getController.searchProduct(search: widget.searchValue);
    checkData();
  }

  bool checkData() {
    if (response == "success") {
      if (getController.searchProducts.isEmpty) {
        stateOfSearch = "empty";
      } else {
        stateOfSearch = "done";
      }
      return true;
    }
    return false;
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Search Screen"),
      ),
      body: ListView(
        controller: _scrollController1,
        children: [
          Container(
            margin: EdgeInsets.only(
                right: deviceWidth * .04,
                top: deviceHeight * .003,
                left: deviceWidth * .04,
                bottom: deviceHeight * .003),
            child: GetBuilder<HomeControllers>(
              builder: (_) {
                if (!checkData()) {
                  return Container(
                    height: deviceHeight * .7,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return stateOfSearch == "done"
                    ? ListView.builder(
                        controller: _scrollController,
                        itemCount: getController.searchProducts.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) =>
                            SearchWidget(
                                index, getController.searchProducts[index]),
                        shrinkWrap: true,
                      )
                    : Container(
                        height: deviceHeight * .7,
                        child: Center(
                            child: Text("Did not found any Products yet")));
              },
            ),
          ),
          // _bottomLoading
          //     ? Center(child: CircularProgressIndicator())
          //     : SizedBox(width: 0, height: 0),
        ],
      ),
    );
  }
}
