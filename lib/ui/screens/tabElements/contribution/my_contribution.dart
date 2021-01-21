import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connecting_hearts/constant/Constant.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:connecting_hearts/ui/screens/tabElements/contribution/contributed_project.dart';

import '../../../../miscellaneous/image_picker.dart';

class MyContribution extends StatefulWidget {
  @override
  _MyContributionState createState() => _MyContributionState();

  // final dynamic projectData;
  // Payment(this.projectData, {Key key}) : super(key: key);
}

class _MyContributionState extends State<MyContribution> {
  ApiListener mApiListener;
  dynamic totalContribution = 0;
  Future<dynamic> _paymentData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WebServices(mApiListener).getPaymentData().then((value) {
      print(value);
      setState(() {
        dynamic total = 0;
        for (var item in value) {
          total = total + double.parse(item['paid_amount']);
        }
        totalContribution = total;
      });
    });
    _paymentData = WebServices(mApiListener).getPaymentData();
  }

  @override
  Widget build(BuildContext context) {
    FlutterMoneyFormatter formattedAmount =
        FlutterMoneyFormatter(amount: double.parse('$totalContribution')*double.parse('$currencyValue'));
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              // automaticallyImplyLeading: false,
              toolbarHeight: 70,
              expandedHeight: 160,
              backgroundColor: Color.fromRGBO(80, 172, 225, 0.7),
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: ListTile(
                  title: Text(
                    "My Total Contribution",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 12),
                  ),
                  subtitle: RichText(
                    text: new TextSpan(
                      style: new TextStyle(
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                            text: "${currentUserData['currency']} ",
                            style: new TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            )),
                        new TextSpan(
                            text:
                                '${formattedAmount.output.nonSymbol}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    child: Container(
                      child: Column(children: <Widget>[
                        FutureBuilder(
                          future: _paymentData,
                          builder: (context, snapshot) {
                            List<Widget> children;
                            if (snapshot.hasData) {
                              var data;
                              if (snapshot.data.length != 0) {
                                data = snapshot.data;
                                dynamic total = 0;
                                for (var item in data) {
                                  total =
                                      total + double.parse(item['paid_amount']);
                                }

                                children = <Widget>[
                                  for (var item in data) contributionCard(item)
                                ];
                                this.totalContribution = total;
                              } else {
                                children = <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: ListTile(
                                      title: Image.asset(
                                        "assets/my_contribution.png",
                                        width: 120,
                                        height: 120,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                      title: Text(
                                    'Make your donations simply and get access to project tracking.',
                                    style: TextStyle(
                                        color: Colors.black45, fontSize: 14),
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
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: SizedBox(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Theme.of(context)
                                                      .primaryColor))),
                                ),
                              ];
                            }
                            return Center(
                              child: Column(children: children),
                            );
                          },
                        ),
                      ]),
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ));
  }

  Widget contributionCard(item) {
    FlutterMoneyFormatter formattedAmount =
        FlutterMoneyFormatter(amount: double.parse('${item['paid_amount']}')*double.parse('$currencyValue'));
    Widget _trailing;
    dynamic _moreDetailsLeading = FlatButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContributedProject(item)),
          );
        },
        icon: Icon(Icons.list),
        label: Text('More details'));
    Icon _statusIcon = Icon(
      Icons.check_circle,
      color: Colors.green,
    );

    dynamic _text = "Thank You ! \nYour Donation has Confirmed";
    if (item['status'] == 'pending' && item['method'] == 'bank') {
      if (item['slip_url'] == "") {
        _trailing = RaisedButton(
          color: Colors.orange,
          onPressed: () async {
           
            Navigator.of(context)
                .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
              return new PickImage(
                "${item['payment_id']}",
              
              );
            }));
          },
          child: Text(
            'Submit Slip',
            style: TextStyle(color: Colors.white),
          ),
        );

        _statusIcon = Icon(
          Icons.info_outline,
          color: Colors.orange,
        );
        _text = "Please Submit Your Bank Slip for Your Contribution";
      } else {
        _trailing =
            //  CircleAvatar(child: Icon(Icons.insert_emoticon)),
            RaisedButton(
          child: Text(
            'Edit Slip',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
          onPressed: () async {
           
            Navigator.of(context)
                .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
              return new PickImage(
                "${item['payment_id']}",
              
              );
            }));
          },
        );

        _statusIcon = Icon(
          Icons.schedule,
          color: Colors.blue,
        );
        _text = "Thank You ! \nWe are Reviewing you Donation.";
      }
    } else if (item['status'] == 'cancelled') {
      _moreDetailsLeading=null;
      _trailing = FlatButton(
        color: Colors.red,
        onPressed: () {},
        child: Text(
          'Cancelled',
          style: TextStyle(color: Colors.white),
        ),
      );

      _statusIcon = Icon(
        Icons.info_outline,
        color: Colors.red,
      );
      _text = item['cancel_reason'];
    } else {
      _trailing = RaisedButton(
        color: Colors.green,
        onPressed: () async {
          _launchURL(item['receipt_url']);
        },
        child: Text(
          'View Receipt',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('${item['short_description']}'),
            subtitle: Text(
              '${item['date_time']}  ${item['method']} payment',
              style: TextStyle(fontSize: 12),
            ),
            trailing: FlatButton.icon(
                onPressed: () {
                  infoModalBottomSheet(context, _statusIcon, _text);
                },
                icon: _statusIcon,
                label: Chip(
                    backgroundColor: Colors.blueGrey[50],
                    label: Text(
                        '${currentUserData['currency']} ${formattedAmount.output.nonSymbol}',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0)))),
          ),
          Divider(height: 0),
          ListTile(
            leading: _moreDetailsLeading,
            trailing: _trailing,
            tileColor: Color.fromRGBO(206, 220, 233, 1),
          )
        ],
      ),
    );
  }

  Future<bool> infoModalBottomSheet(context, icon, text) {
    return showModalBottomSheet(
        enableDrag: true,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: ListTile(
                        title: Text('Donation Status'),
                        trailing: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )),
                  Divider(
                    height: 0,
                  ),
                  ListTile(
                    leading: icon,
                    title: Text(text),
                  ),
                ],
              ),
            );
          });
        });
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
