import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wasan/utility/my_style.dart';
import 'package:wasan/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Field
  File file;
  String name, email, password;

  // Method
  Widget nameForm() {
    Color color = Colors.purple;
    return Container(
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      child: TextField(
          onChanged: (String string) {
            name = string.trim();
          },
          decoration: InputDecoration(
            enabledBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: color)),
            icon: Icon(
              Icons.face,
              size: 36.0,
              color: color,
            ),
            helperText: 'Type You Name in Blank',
            helperStyle: TextStyle(color: color),
            labelText: 'Display Name :',
            labelStyle: TextStyle(color: color),
          )),
    );
  }

  Widget emailForm() {
    Color color = Colors.green;
    return Container(
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      child: TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: (String string) {
            email = string.trim();
          },
          decoration: InputDecoration(
            enabledBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: color)),
            icon: Icon(
              Icons.email,
              size: 36.0,
              color: color,
            ),
            helperText: 'Type You Email in Blank',
            helperStyle: TextStyle(color: color),
            labelText: 'Display Email :',
            labelStyle: TextStyle(color: color),
          )),
    );
  }

  Widget passwordForm() {
    Color color = Colors.orange;
    return Container(
      padding: EdgeInsets.only(left: 30.0, right: 30.0),
      child: TextField(
          onChanged: (String string) {
            password = string.trim();
          },
          decoration: InputDecoration(
            enabledBorder:
                UnderlineInputBorder(borderSide: BorderSide(color: color)),
            icon: Icon(
              Icons.lock,
              size: 36.0,
              color: color,
            ),
            helperText: 'Type You Password in Blank',
            helperStyle: TextStyle(color: color),
            labelText: 'Display Password :',
            labelStyle: TextStyle(color: color),
          )),
    );
  }

  Widget cameraButton() {
    return IconButton(
      color: MyStyle().darkColor,
      icon: Icon(Icons.add_a_photo),
      onPressed: () {
        chooseImageThread(ImageSource.camera);
      },
    );
  }

  Future<void> chooseImageThread(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );

      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 36.0,
      ),
      onPressed: () {
        chooseImageThread(ImageSource.gallery);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget showAvatar() {
    return Container(
      child: file == null ? Image.asset('images/avatar.png') : Image.file(file),
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
    );
  }

  Widget registerButton() {
    return IconButton(
      tooltip: 'Upload to Firebase',
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        if (file == null) {
          normalDialog(
              context, 'None Choose Avatar', 'Please Tap Camera or Gallery');
        } else if (name == null ||
            name.isEmpty ||
            email == null ||
            email.isEmpty ||
            password == null ||
            password.isEmpty) {
          normalDialog(context, 'Have Space', 'Please Fill Every Blank');
        } else {
          registerFirebase();
        }
      },
    );
  }

  Future<void> registerFirebase() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((response) {
      print('Register Success');
    }).catchError((error) {
      String title = error.code;
      String message = error.message;
      normalDialog(context, title, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[registerButton()],
        title: Text('Register'),
        backgroundColor: MyStyle().darkColor,
      ),
      body: ListView(
        children: <Widget>[
          showAvatar(),
          showButton(),
          nameForm(),
          emailForm(),
          passwordForm(),
        ],
      ),
    );
  }
}
