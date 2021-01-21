import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:connecting_hearts/constant/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:connecting_hearts/offline.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;
  ApiListener mApiListener;
  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigateFromSplash);
    
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 800),
    );
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();

    
  }

  Future navigateFromSplash() async {
    await WebServices(mApiListener).createUserHit();
    FirebaseAuth.instance.currentUser().then((user) {
      print(user);

      if (user != null) {
        //User Hit

        Navigator.of(context).pushReplacementNamed(HOME_PAGE);
      } else {
        Navigator.of(context).pushReplacementNamed(SIGN_IN);
      }
    });
  
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
       OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;
              return new Stack(
                fit: StackFit.expand,
                children: [
                  connected
                      ?  Stack(
        fit: StackFit.expand,
        children: <Widget>[
      
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: new Image.asset(
                  "assets/powered_by.png",
                  height: 35.0,
                  fit: BoxFit.scaleDown,
                ),
              )
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                "assets/logo.png",
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      )
                      : Offline()
                ],
              );
            },
            child: Column(
              children: <Widget>[
                new Text(
                  'There are no bottons to push :)',
                ),
              ],
            ),
          )
     
    );
  }
}
