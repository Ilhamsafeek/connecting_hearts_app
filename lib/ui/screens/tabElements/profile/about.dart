import 'package:flutter/material.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

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
        appBar: AppBar(title: Text('About'),),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(1.0),
                child: Column(
                  children: <Widget>[
                    // Center(child: Image.asset('assets/logo.png', height: 80)),
                      Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset('assets/logo.png', height: 80),
                          ListTile(
                            
                            title: Text(
                                '\nZam Zam Foundation works with diverse communities across Sri Lanka beyond social, ethnic, religious divides with the principle “Humanity beyond Religion”. As a Government Registered Social Services Organization working on uplifting communities island-wide through Education, Shelter, Sanitation, Poverty Alleviation and Capacity Development initiatives, the beneficiaries are from all faith, ethnic communities and not limited to Muslim community.'),
                          ),
                          
                          
                          ListTile(
                              title: Text(
                            '\nWith our Mobile App, keep yourself updated from anywhere in the world about the work of Zam Zam Foundation and be a part of our projects in Sri Lanka. You can contribute towards Zam Zam Foundation through your words of encouragement, prayers and financial donations through this app',
                          )),
                          SizedBox(
                            height: 30,
                          ),
                           Divider(
              height: 0,
            ),
                           ListTile(
              // leading: Icon(Icons.admin_panel_settings_sharp),
              title: Text('Proudly developed by'),
              trailing:  Image.asset('assets/hashnate_logo.png', height: 30),
              onTap: (){
                _launchURL('https://hashnate.com');
              },
            ),
                         
                        ],
                      
                      ),
                    ),
                 
                  
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
   _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("You will be notified when we prepared your receipt."),
      ));
    }
  }
}
