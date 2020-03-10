import 'package:flutter/material.dart';
import 'package:wasan/models/product_model.dart';

class Detail extends StatefulWidget {
  final ProductModel model;
  Detail({Key key, this.model}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  //Field
  ProductModel productModel;

  //Method
  @override
  void initState() {
    super.initState();
    productModel = widget.model;
  }

  Widget showPic() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Image.network(
        productModel.url,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget arrowBack() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        size: 36.0,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  Widget mainContent() {
    return Column(
      children: <Widget>[
        showPic(),
        showID(),
        showTitle(),
      ],
    );
  }

  Widget showID() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          productModel.id.toString(),
          style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget showTitle(){
    return Text(productModel.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            mainContent(),
            arrowBack(),
          ],
        ),
      ),
    );
  }
}
