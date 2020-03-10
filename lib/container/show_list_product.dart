import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wasan/models/product_model.dart';
import 'package:wasan/utility/my_style.dart';
import 'package:wasan/widget/detail.dart';

class ShowListProduct extends StatefulWidget {
  @override
  _ShowListProductState createState() => _ShowListProductState();
}

class _ShowListProductState extends State<ShowListProduct> {
  // Field
  String urlAPI = 'http://jsonplaceholder.typicode.com/photos';
  List<ProductModel> productModels = List();
  ScrollController scrollController = ScrollController();
  int sizeListView = 10;

  // Method
  @override
  void initState() {
    super.initState();
    readJSON();
    setupController();
  }

  void setupController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('This is End');
        setState(() {
          sizeListView += 10;
        });
      }
    });
  }

  Future<void> readJSON() async {
    try {
      Response response = await Dio().get(urlAPI);
      print('response = $response');

      for (var map in response.data) {
        ProductModel model = ProductModel.fromJson(map);
        setState(() {
          productModels.add(model);
        });
      }
    } catch (e) {}
  }

  Widget showProcess() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget showListView() {
    return ListView.builder(
        controller: scrollController,
        itemCount: sizeListView,
        itemBuilder: (BuildContext buildContext, int index) {
          return GestureDetector(
            onTap: () {
              MaterialPageRoute route = MaterialPageRoute(
                builder: (value) => Detail(
                  model: productModels[index],
                ),
              );
              Navigator.of(context).push(route);
            },
            child: Row(
              children: <Widget>[
                showPic(index),
                showText(index),
              ],
            ),
          );
        });
  }

  Widget showPic(int index) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.5,
      child: Image.network(productModels[index].url),
    );
  }

  Widget showText(int index) {
    return Container(
      padding: EdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          showId(index),
          showTitle(index),
        ],
      ),
    );
  }

  Widget showId(int index) {
    return Text(
      productModels[index].id.toString(),
      style: TextStyle(
          fontSize: 70.0,
          fontWeight: FontWeight.bold,
          color: MyStyle().darkColor),
    );
  }

  Widget showTitle(int index) {
    return Text(productModels[index].title);
  }

  @override
  Widget build(BuildContext context) {
    return productModels.length == 0 ? showProcess() : showListView();
  }
}
