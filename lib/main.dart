import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nowapps_sqllite/screens/index.dart';

AssetImage logo;
void main() {
  logo = new AssetImage("assets/logo.png");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NowApps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _LauncherPage(title: 'NowApps - SQLite'),
      debugShowCheckedModeBanner: false,
    );
  }
}

//This class is used to make launching screen.
//This page will be destroyed and open Home page in 2 Seconds
class _LauncherPage extends StatefulWidget {
  _LauncherPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends State<_LauncherPage> {

  @override
  void initState() {
    super.initState();
    startLauncherTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.width * 0.3,
                width: MediaQuery.of(context).size.width * 0.3,
                alignment: AlignmentDirectional.center,
                child: Image(image: logo)
              //child: Image.asset("assets/curie_connect.png")
            ),
            Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.03,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                alignment: AlignmentDirectional.center,
                child: Text(
                  "NOWAPPS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "QuicksandBold",
                    fontSize: MediaQuery.of(context).size.width * 0.055,
                  ),
                )
            ),
            Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.01,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                alignment: AlignmentDirectional.center,
                child: Text(
                  "Simplicity in Action",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "QuicksandBold",
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  startLauncherTimer() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, () {
      Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false);
    });
  }

}
