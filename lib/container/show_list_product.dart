import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wasan/models/product_model.dart';

class ShowListProduct extends StatefulWidget {
  @override
  _ShowListProductState createState() => _ShowListProductState();
}

class _ShowListProductState extends State<ShowListProduct> {
  // Field
  String urlAPI = 'http://jsonplaceholder.typicode.com/photos';
  List<ProductModel> productModels = List();

  // Method
  @override
  void initState() {
    super.initState();
    readJSON();
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
        itemCount: productModels.length,
        itemBuilder: (BuildContext buildContext, int index) {
          return Text(productModels[index].title);
        });
  }

  @override
  Widget build(BuildContext context) {
    return productModels.length == 0 ? showProcess() : showListView();
  }
}
