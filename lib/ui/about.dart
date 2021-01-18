import 'package:flutter/material.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();

  // final dynamic projectData;
  // Payment(this.projectData, {Key key}) : super(key: key);
}

class _AboutState extends State<About> {
  ApiListener mApiListener;
  dynamic totalContribution = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
   
    WebServices(mApiListener).getPaymentData().then((value) {
      print(value);
      setState(() {
        dynamic total = 0;
        for (var item in value) {
          total = total + double.parse(item['amount']);
        }
        totalContribution = total;
      });
    });
  }


  void showNotification() {
    var android = AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        priority: Priority.High);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    flutterLocalNotificationsPlugin.show(0, 'title', 'body', platform,
        payload: "send message");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Center(child: Image.asset('assets/logo.png', height: 80)),
                    // RaisedButton(
                    //   onPressed: () async {
                       
                    //       showNotification();
                    //   },
                    //   child: Text('Notify'),
                    // )
                  
                  ],
                ),
              ),
              // Builder(builder: (BuildContext context){
              //   return OfflineBuilder(
              //     connectivityBuilder: (
              //       BuildContext context,
              //       ConnectivityResult connectivity,
              //       Widget child){
              //       final bool connected =connectivity!= ConnectivityResult.none;
              //         return Stack(
              //           fit: StackFit.expand,
              //           children: [
              //             child,
              //             Positioned(
              //               left: 0.0,
              //               right: 0.0,
              //               height: 12.0,
              //               child: AnimatedContainer(
              //                 duration: const Duration(milliseconds: 300),
              //                 color: connected ? null : Colors.red,
              //                 child: connected ? null :
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: <Widget>[
              //                     Text('Offline')
              //                   ],
              //                 )
              //               ),
              //             )
              //           ],
              //         );

              //       }
                  
              //     );

                  

              // })
           
            ],
          ),
        ));
  }
}
