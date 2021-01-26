import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:connecting_hearts/constant/Constant.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connecting_hearts/ui/screens/tabElements/home/dashboardContent/echarity/project_detail.dart';
import 'package:connecting_hearts/miscellaneous/single_video.dart';

import '../../Tabs.dart';

class Notifications extends StatefulWidget {
  final PageController pageController;

  Notifications({Key key, this.pageController}) : super(key: key);

  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  ApiListener mApiListener;
  dynamic notificationData;
  dynamic projectData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    notificationData = WebServices(this.mApiListener).getNotificationData();
    WebServices(this.mApiListener).getProjectData().then((value) {
      setState(() {
        projectData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            RefreshIndicator(
              child: SingleChildScrollView(
                  child: Container(
                child: FutureBuilder<dynamic>(
                  future: notificationData,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    List<Widget> children;

                    if (snapshot.hasData) {
                      if (snapshot.data.length != 0) {
                        dynamic data = snapshot.data.where((el) {
                          if (el['target'].contains(CURRENT_USER)) {
                            return true;
                          } else {
                            return false;
                          }
                        }).toList();

                        children = <Widget>[
                          for (var item in data)
                            Column(
                              children: <Widget>[
                                ListTile(
                                    leading:
                                        // CircleAvatar(
                                        //   backgroundColor: Colors.grey[400],
                                        //   child: item['type'] == 'approval'
                                        //       ? Icon(
                                        //           Icons.check_circle,
                                        //           color: Colors.green,
                                        //         )
                                        //       : item['type'] == 'project'
                                        //           ? Icon(Icons.fiber_new)
                                        //           : Icon(Icons.videocam),
                                        // ),
                                        _notificationAvatar(item['message']),
                                    title: Text(item['message']),
                                    subtitle: Text(
                                      item['time'],
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    // trailing: Text(
                                    //   item['type'],
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.w300),
                                    // ),
                                    onTap: () {
                                      var specificProject = projectData
                                          .where((el) =>
                                              el['appeal_id'] ==
                                              json.decode(
                                                  item['data'])['appeal_id'])
                                          .toList();
                                      // print(json.decode(item['data'])['appeal_id']);
                                      print(specificProject.toString());
                                      if (item['type'] == 'project') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProjectDetail(
                                                      specificProject[0])),
                                        );
                                      } else if (item['type'] == 'approval') {
                                        //  setState(() => MyTabs(). = index);
                                        // widget.pageController.animateTo(1, curve: null, duration:null);
                                        //  setState(() => widget.currentIndex = 1);
                                        widget.pageController.jumpToPage(1);
                                        Navigator.pop(context);
                                      }
                                    }),
                                Divider(
                                  height: 0,
                                ),
                              ],
                            ),
                        ];
                      } else {
                        children = <Widget>[
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: ListTile(
                                title: Icon(
                              Icons.notifications_active,
                              size: 150,
                              color: Colors.grey,
                            )),
                          ),
                          ListTile(
                              title: Text(
                            'you have not received notification yet. You will be notified once you get notifications.',
                            style:
                                TextStyle(color: Colors.black45, fontSize: 14),
                            textAlign: TextAlign.center,
                          )),
                        ];
                      }
                    } else if (snapshot.hasError) {
                      children = <Widget>[
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                              'something Went Wrong !'), //Error: ${snapshot.error}
                        )
                      ];
                    } else {
                      children = <Widget>[
                        SizedBox(
                          child: SpinKitPulse(
                            color: Colors.grey,
                            size: 120.0,
                          ),
                          width: 50,
                          height: 50,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text(''),
                        )
                      ];
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),
                    );
                  },
                ),
              )),
              onRefresh: _handleRefresh,
            )
          ],
        )));
  }

  Widget _notificationAvatar(message) {
    
    var outline_color=Colors.green;
    var icon=Icons.fiber_new;
    if(message.contains('new project')){
      outline_color=Colors.green;
      icon=Icons.fiber_new;
    }else if(message.contains('has been received')){
      outline_color=Colors.blue;
      icon=Icons.beenhere_sharp;
    }else if(message.contains('Reminder about your Subscription')){
      outline_color=Colors.yellow;
      icon=Icons.payments_outlined;
    }else if(message.contains('Please attach bank deposit')){
      outline_color=Colors.orange;
      icon=Icons.signal_cellular_no_sim_outlined;
    }else if(message.contains('has been cancelled')){
      outline_color=Colors.red;
      icon=Icons.cancel_outlined;
    }else if(message.contains('successfully been completed')){
      outline_color=Colors.green;
      icon=Icons.download_done_outlined;
    }else if(message.contains('Zam Zam Update')){
      outline_color=Colors.amber;
      icon=Icons.new_releases_outlined;
    }else if(message.contains('We will send you a receipt once your payment confirmed')){
      outline_color=Colors.purple;
      icon=Icons.beenhere_sharp;
    }
    
    return new Container(
      child: Icon(
        icon,
        size: 27,color: outline_color,
      ),
      width: 50.0,
      height: 50.0,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
        border: new Border.all(
          color: outline_color,
          width: 2.0,
        ),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }
}

class Messages extends StatefulWidget {
  Messages({Key key}) : super(key: key);

  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
