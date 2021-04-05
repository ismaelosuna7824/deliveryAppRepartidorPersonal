import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:TuGoRepartidor/api/stoarge.dart';
import '../controllers/controller.dart';


class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  Controller _con;

  SplashScreenState() : super(Controller()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getUserName().then((value)  {
          if(value == '')
            {
              Navigator.of(context).pushReplacementNamed('/Login');
            }
          else
            {
              Navigator.of(context).pushReplacementNamed('/Pages');
            }
        });
     
      // if (currentUser.apiToken == null) {

      // } else {
      //   Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset('assets/img/tugo.png', scale: 1,),
              ),
              Text(
                'TuGo Repartidor',
                style: Theme.of(context).textTheme.display1.merge(TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor)),
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).scaffoldBackgroundColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
