import 'package:flutter/material.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();

  // final dynamic projectData;
  // Payment(this.projectData, {Key key}) : super(key: key);
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  ApiListener mApiListener;
  dynamic totalContribution = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Privacy Policy'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(1.0),
                child: Column(
                  children: <Widget>[
                    //   ListTile(
                    // title: Text(
                    //   "Privacy Policy",
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.bold, color: Colors.white),
                    // ),
                    // tileColor: Color.fromRGBO(80, 172, 225, 1)),

                    Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                                '\nPlease read the policy in order to be familiar with the way Connecting Hearts is collecting, using and processing your personal information pertaining to the usage of the Electronic Payment Gateway which is available through Connecting Hearts’s electronic services.'),
                          ),
                          ListTile(
                              title: Text(
                                  'The approval of obtaining your personal information',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600))),
                          ListTile(
                            title: Text(
                                'Once you give an approval to provide Connecting Hearts with your personal information, you agree upon the conditions set forth in this document, and Connecting Hearts may change these conditions from time to time. Connecting Hearts does not collect any information from visitors except for what he or she provides when subscribing, or making a donation.\nConnecting Hearts does not sell, rent or publish personal information provided willingly, except for the continuation of the process of donation initiated.\nConnecting Hearts is committed to ensure the privacy of users of its electronic services, which include all electronic donation points and apps and websites of other projects'),
                          ),
                          ListTile(
                              title: Text('Collecting Personal Information',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600))),
                          ListTile(
                              title: Text(
                            'Connecting Hearts ensures the safety and privacy of users’ personal information, which may use only for the purposes it was collected for. For instance, information might be used to complete donation processes, verify personal information, remind donors of their donation dates, and to notify them of new campaigns in this regard, including information about those who expressed their intention to volunteer at the Charity',
                          )),
                          ListTile(
                              title: Text('Data Security',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600))),
                          ListTile(
                              title: Text(
                            'Connecting Hearts applies a group of data security procedures that ensure the safety, accuracy and updating of data. Connecting Hearts will not sell, rent or disclose your personal information with a third party.\n',
                          )),
                        ],
                      
                      ),
                    ),
                 
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
