import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wasan/container/show_list_product.dart';
import 'package:wasan/container/show_map.dart';
import 'package:wasan/utility/my_style.dart';
import 'package:wasan/widget/authen.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  // Field
  String nameLogin, emailLogin, urlAvatarLogin;
  Widget currentWidget = ShowListProduct();

  //Method
  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<void> findUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await auth.currentUser();
    setState(() {
      nameLogin = firebaseUser.displayName;
      emailLogin = firebaseUser.email;
      urlAvatarLogin = firebaseUser.photoUrl;
    });
  }

  Widget menuListProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = ShowListProduct();
        });
        Navigator.of(context).pop();
      },
      subtitle: Text('Show List Product From JSON'),
      title: Text('List Product'),
      leading: Icon(Icons.home,size: 36.0,color: Colors.green,),
    );
  }

  Widget menuListMap() {
    return ListTile(
      onTap: () {
        setState(() {
          currentWidget = ShowMap();
        });
        Navigator.of(context).pop();
      },
      subtitle: Text('Show Map and Get Location'),
      title: Text('Show Maps'),
      leading: Icon(Icons.map,size: 36.0,color: Colors.green,),
    );
  }

  Widget showAvatar() {
    return urlAvatarLogin == null
        ? Image.network(MyStyle().urlAvatar)
        : showNetworkAvatar();
  }

  Widget showNetworkAvatar() {
    return ClipOval(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(urlAvatarLogin), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget menuSighOut() {
    return ListTile(
      onTap: () {
        processSignOut();
      },
      subtitle: Text('Sign Out and Back to Authentication'),
      title: Text('Sign Out'),
      leading: Icon(
        Icons.exit_to_app,
        size: 36.0,
        color: Colors.red,
      ),
    );
  }

  Future<void> processSignOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut().then((response) {
      MaterialPageRoute route = MaterialPageRoute(builder: (value) => Authen());
      Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
    });
  }

  Widget showHead() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      accountName: showName(),
      accountEmail: showEmail(),
      currentAccountPicture: showAvatar(),
    );
  }

  Text showEmail() {
    return emailLogin == null
        ? Text(
            'Name Login',
            style: TextStyle(color: MyStyle().darkColor),
          )
        : Text(
            emailLogin,
            style: TextStyle(color: MyStyle().darkColor),
          );
  }

  Text showName() {
    return nameLogin == null
        ? Text(
            'Email Login',
            style: TextStyle(color: MyStyle().darkColor),
          )
        : Text(
            nameLogin,
            style: TextStyle(color: MyStyle().darkColor),
          );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHead(),
          menuListProduct(),
          menuListMap(),
          menuSighOut(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: currentWidget,
      drawer: showDrawer(),
      appBar: AppBar(
        title: Text('My Service'),
        backgroundColor: MyStyle().primaryColor,
      ),
    );
  }
}
