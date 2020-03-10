import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wasan/utility/my_style.dart';
import 'package:wasan/utility/normal_dialog.dart';
import 'package:wasan/widget/my_service.dart';
import 'package:wasan/widget/register.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  // Field
  bool status = true;
  String user, password;

  // Method

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  Future<void> checkStatus() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    if (firebaseUser != null) {
      routeToMyService();
    } else {
      setState(() {
        status = false;
      });
    }
  }

  void routeToMyService() {
    MaterialPageRoute route =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return MyService();
    });
    Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) {
      return false;
    });
  }

  Widget showProcess() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget mySizebox() {
    return SizedBox(
      height: 10.0,
      width: 5.0,
    );
  }

  Widget signUpButton() {
    return Expanded(
      child: OutlineButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        borderSide: BorderSide(color: MyStyle().primaryColor),
        child: Text(
          'SignUp',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          print('You Click Me');
          MaterialPageRoute route =
              MaterialPageRoute(builder: (BuildContext buildContext) {
            return Register();
          });
          Navigator.of(context).push(route);
        },
      ),
    );
  }

  Widget signInButton() {
    return Expanded(
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: MyStyle().primaryColor,
        child: Text(
          'Sigh In',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          if (user == null ||
              user.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'Have Space', 'Please Fill Every Blank');
          } else {
            checkAuthen();
          }
        },
      ),
    );
  }

  Future<void> checkAuthen() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth
        .signInWithEmailAndPassword(email: user, password: password)
        .then((response) {
          routeToMyService();
        })
        .catchError((error) {
          String title = error.code;
          String message = error.message;
          normalDialog(context, title, message);
        });
  }

  Widget showButton() {
    return Container(
      width: 250.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          signInButton(),
          mySizebox(),
          signUpButton(),
        ],
      ),
    );
  }

  Widget passwordForm() {
    return Container(
      width: 250.0,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0), color: Colors.white54),
        height: 35.0,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          style: TextStyle(color: MyStyle().darkColor),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock_open,
                color: MyStyle().darkColor,
              ),
              contentPadding: EdgeInsets.only(
                left: 20.0,
              ),
              border: InputBorder.none,
              hintText: 'Password :',
              hintStyle: TextStyle(color: MyStyle().darkColor)),
        ),
      ),
    );
  }

  Widget userForm() {
    return Container(
      width: 250.0,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0), color: Colors.white54),
        height: 35.0,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          style: TextStyle(color: MyStyle().darkColor),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: MyStyle().darkColor,
              ),
              contentPadding: EdgeInsets.only(
                left: 20.0,
              ),
              border: InputBorder.none,
              hintText: 'User :'),
        ),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      height: 120.0,
      width: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'RETURN GLO',
      style: GoogleFonts.tradeWinds(
          textStyle: TextStyle(
        color: MyStyle().darkColor,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontSize: 30.0,
      )),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: status ? showProcess() : mainContent(),
    );
  }

  Container mainContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: <Color>[Colors.white, MyStyle().primaryColor],
          radius: 1.0,
        ),
      ),
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          showLogo(),
          showAppName(),
          userForm(),
          mySizebox(),
          passwordForm(),
          mySizebox(),
          showButton(),
        ],
      )),
    );
  }
}
