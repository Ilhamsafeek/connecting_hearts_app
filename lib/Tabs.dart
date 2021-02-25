
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:connecting_hearts/ui/screens/tabElements/management_webview.dart';
import 'package:connecting_hearts/ui/screens/tabElements/contribution/my_contribution.dart';
import 'package:connecting_hearts/offline.dart';
import 'package:connecting_hearts/ui/screens/notifications.dart';
import 'package:connecting_hearts/ui/screens/tabElements/chat/chat.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:connecting_hearts/ui/screens/tabElements/profile/profile.dart';
import 'package:connecting_hearts/miscellaneous/data_search.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/screens/tabElements/home/home.dart';
import 'utils/badge_icon.dart';
import 'constant/Constant.dart';

// Main code for all the tabs
class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  static final homePageKey = GlobalKey<MyTabsState>();
  TabController tabcontroller;
  FirebaseMessaging messaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ApiListener mApiListener;

  int currentIndex = 0;
  PageController _pageController;
  int _tabBarNotificationCount = 0;
  // final ScrollController controller = ScrollController();

  StreamController<int> _countController = StreamController<int>();

  Future<void> updateNotificationCount(int nofificationcount) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt("notificationCount", nofificationcount);
  }

  Future<int> getNotificationCount() async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getInt("notificationCount");
    return allSearches;
  }

  @override
  void didChangeDependencies() {
     WebServices(mApiListener).getUserData().then((value) {
    if (value != null) {
      USER_ROLE = value['role'];
      currentUserData = value;
    }
  });
    getNotificationCount().then((value) {
      if (value == null) {
        setState(() {
          _tabBarNotificationCount = 0;
          _countController.sink.add(_tabBarNotificationCount);
        });
      } else {
        setState(() {
          _tabBarNotificationCount = value;
          _countController.sink.add(_tabBarNotificationCount);
        });
      }
    });
    _pageController = PageController();

    messaging.configure(
      onLaunch: (Map<String, dynamic> event) async {
        // dynamic data = json.decode(event['data']['args']);

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Play(video)),
        // );
        // showNotification();
      },
      onMessage: (Map<String, dynamic> event) async {
        // foreground

        // dynamic data = json.decode(event['data']['args']);

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Play(video)),
        // );
        showNotification();
        _tabBarNotificationCount = _tabBarNotificationCount + 1;
        _countController.sink.add(_tabBarNotificationCount);
        updateNotificationCount(_tabBarNotificationCount);
      },
      onResume: (Map<String, dynamic> event) async {
        //background - when App is not Opened
        _tabBarNotificationCount = _tabBarNotificationCount + 1;
        _countController.sink.add(_tabBarNotificationCount);
        updateNotificationCount(_tabBarNotificationCount);
        // dynamic video = json.decode(event['data']['args']);

        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Notifications(pageController: _pageController)),
        );
      },
    );
    // messaging.subscribeToTopic('all');
    messaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    messaging.getToken().then((token) {
      print("your token is : $token");
    });

    messaging.onTokenRefresh.listen((token) {
      WebServices(this.mApiListener).updateUserToken(token);

      print("your token is chnged to : $token");
    });

    // Local notification
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = new IOSInitializationSettings();
    var initSetting = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: _selectNotification);

    super.didChangeDependencies();
  }

  Future _selectNotification(payload) {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Notifications(pageController: _pageController)),
    );
  }

  void showNotification() {
    var android = AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    flutterLocalNotificationsPlugin.show(0, 'Connecting hearts',
        'You have received a notification. Tap to view', platform,
        payload: "send message");
  }

  @override
  void dispose() {
    _pageController.dispose();
    _countController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: new Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: new AppBar(
              leading: Image.asset(
                'assets/ch_logo.png',
                color: Colors.white60,
              ),
              leadingWidth: 40,
              title: Text('Connecting Hearts',
                  style: TextStyle(
                    fontFamily: 'Architekt',
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  )),
              titleSpacing: 8,
              actions: <Widget>[
                IconButton(
                  onPressed: () async {
                    await showSearch<String>(
                      context: context,
                      delegate: DataSearch(
                        onSearchChanged: DataSearch().getRecentSearchesLike,
                      ),
                    );
                  },
                  icon: Icon(Icons.search),
                ),
                IconButton(
                  icon: StreamBuilder(
                    initialData: _tabBarNotificationCount,
                    stream: _countController.stream,
                    builder: (_, snapshot) => BadgeIcon(
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      badgeCount: snapshot.data,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notifications(pageController: _pageController)),
                    );
                    _tabBarNotificationCount = 0;
                    _countController.sink.add(_tabBarNotificationCount);
                    updateNotificationCount(_tabBarNotificationCount);
                  },
                ),
              ],
            ),
          ),
          body: OfflineBuilder(
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
                      ? SizedBox.expand(
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() => currentIndex = index);
                            },
                            children: <Widget>[
                              Home(),
                              MyContribution(),
                              USER_ROLE == 'Management'
                                  ? MAnagementWebView()
                                  : Chat(),
                              Profile(),
                            ],
                          ),
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
          ),
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: currentIndex,
            onItemSelected: (index) {
              setState(() => currentIndex = index);
              _pageController.jumpToPage(index);
            },
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                title: Text(
                  'Home',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                icon: Icon(Icons.apps, color: Theme.of(context).primaryColor),
                activeColor: Theme.of(context)
                    .primaryColor, //Theme.of(context).primaryColor,
              ),
              BottomNavyBarItem(
                title: Text(
                  'Contribution',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                icon: Icon(Icons.verified_user,
                    color: Theme.of(context).primaryColor),
                activeColor: Theme.of(context).primaryColor,
              ),
              BottomNavyBarItem(
                title: Text(
                  USER_ROLE == 'Management' ? 'Report' : 'Messages',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                icon: Icon(
                    USER_ROLE == 'Management' ? Icons.insert_chart : Icons.chat,
                    color: Theme.of(context).primaryColor),
                activeColor: Theme.of(context).primaryColor,
              ),
              BottomNavyBarItem(
                title: Text(
                  'Profile',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                //Actually icon was in Icon type. we have changed in the cache of bottomnavybaritem. (Ctrl + click on BottomNavyBarItem to edit)
                icon: Icon(Icons.person, color: Theme.of(context).primaryColor),
                activeColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
        onWillPop: () {
          print('Back button pressed');
          if (currentIndex != 0) {
            setState(() => currentIndex = 0);
            _pageController.jumpToPage(0);
            return new Future(() => false);
          }
          return new Future(() => true);
        });
  }
}
