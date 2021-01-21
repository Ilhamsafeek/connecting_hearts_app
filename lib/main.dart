import 'package:flutter/material.dart';
import 'package:connecting_hearts/Tabs.dart';
import 'package:connecting_hearts/constant/Constant.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:connecting_hearts/services/webservices.dart';
import 'package:connecting_hearts/splashscreen.dart';
import 'package:connecting_hearts/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connecting_hearts/onboarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  ApiListener mApiListener;

  await currentUser().then((value) {
    if (value != null) {
      CURRENT_USER = value.phoneNumber;
    }
  });
  await WebServices(mApiListener).getUserData().then((value) {
    if (value != null) {
      USER_ROLE = value['role'];
      currentUserData = value;
    }
  });
 
  

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: new ThemeData(primaryColor: Color.fromRGBO(7, 82, 139, 1)),
      initialRoute: initScreen == 0 || initScreen == null ? "onboard" : "/",
      routes: <String, WidgetBuilder>{
        "onboard": (BuildContext context) => OnBoardingPage(),
        SPLASH_SCREEN: (BuildContext context) => SplashScreen(),
        SIGN_IN: (BuildContext context) => Signin(),
        HOME_PAGE: (BuildContext context) => MyTabs(),
      },
    );
  }
}

Future<FirebaseUser> currentUser() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return user;
}
