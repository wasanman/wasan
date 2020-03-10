import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ShowListProduct extends StatefulWidget {
  @override
  _ShowListProductState createState() => _ShowListProductState();
}

class _ShowListProductState extends State<ShowListProduct> {
  // Field
  String urlAPI = 'http://jsonplaceholder.typicode.com/photos';

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

    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text('This is List Product');
  }
}
