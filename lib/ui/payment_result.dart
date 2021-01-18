import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connecting_hearts/ui/camera.dart';
import 'package:camera/camera.dart';
import 'package:connecting_hearts/utils/read_more_text.dart';

import 'image_picker.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();

  final String cardId;
  final dynamic projectData;
  final dynamic paymentAmount;
  final dynamic method;
  final dynamic is_recurring;
  Checkout(this.cardId, this.projectData, this.paymentAmount, this.method,
      this.is_recurring,
      {Key key})
      : super(key: key);
}

class _CheckoutState extends State<Checkout> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;
  bool _processing = false;
  bool _is_agree = false;
  Widget _paid = Text('');
  Widget _title = Text('Donation');
  Widget _result = Text('');
  Widget _warning = Text('I Agree With Above Details');
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    FlutterMoneyFormatter formattedAmount =
        FlutterMoneyFormatter(amount: double.parse('${widget.paymentAmount}'));
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            title: _title,
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: SingleChildScrollView(
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        title: Text(
                          "Donation Confirmation",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        tileColor: Color.fromRGBO(80, 172, 225, 1)),
                    Divider(height: 5),
                    ListTile(
                      title: RichText(
                        text: new TextSpan(
                          style: new TextStyle(
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(
                                text: 'Project Category :',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            new TextSpan(
                                text:
                                    " ${widget.projectData['appeal_id']}\n\n"),
                            new TextSpan(
                                text: 'Project Title :',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            new TextSpan(
                                text:
                                    " ${widget.projectData['short_description']}\n\n"),
                            new TextSpan(
                                text: 'Location :',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            new TextSpan(
                                text:
                                    " ${widget.projectData['city']},${widget.projectData['district']}\n\n"),
                            new TextSpan(
                                text: 'My Contribution Amount :',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20)),
                            new TextSpan(
                                text:
                                    " ${formattedAmount.output.withoutFractionDigits}\n\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20)),
                            new TextSpan(
                                text:
                                    "I confirm that this donation is through my own sources of funding, legally compliant and i take responsibility / complete liability for all information provided. (full t&c)"),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Checkbox(
                          value: _is_agree,
                          onChanged: (value) {
                            setState(() {
                              _is_agree = value;
                            });
                          }),
                      title: _warning,
                    ),
                    Divider(height: 5),
                  ],
                ),
              ),
              Divider(height: 10),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        title: Text(
                          "Bank Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        tileColor: Color.fromRGBO(80, 172, 225, 1)),
                    Divider(height: 5),
                    ListTile(
                      title: RichText(
                        text: new TextSpan(
                          style: new TextStyle(
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            new TextSpan(
                                text: 'Account Name :',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            new TextSpan(
                                text:
                                    " ${widget.projectData['account_name']}\n\n"),
                            new TextSpan(
                                text: 'Account Number :',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            new TextSpan(
                                text:
                                    " ${widget.projectData['account_number']}\n\n"),
                            new TextSpan(
                                text: 'Bank :',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            new TextSpan(
                                text:
                                    " ${widget.projectData['bank_name']}\n\n"),
                            new TextSpan(
                                text: 'Branch :',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            new TextSpan(
                                text: " ${widget.projectData['branch']}\n\n",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            new TextSpan(
                                text: 'Swift Code :',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            new TextSpan(
                                text: " ${widget.projectData['swift_code']}",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 5),
                  ],
                ),
              ),
              Divider(height: 30),
              FlatButton.icon(
                onPressed: () {
                  if (_is_agree) {
                    setState(() {
                      // _processing = true;

                      Navigator.pop(context);
                      _showDialog();
                      _result = doCharging();
                    });
                  } else {
                    setState(() {
                      _warning = ListTile(
                          leading: Text('I Agree With Above Details'),
                          title: Icon(
                            Icons.info,
                            color: Colors.red,
                          ));
                    });
                  }
                },
                icon: Icon(Icons.check_circle_outline, color: Colors.black),
                label: Text(
                  'Confirm Donation',
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.amber,
              )
            ],
          )),
        ));
  }

  Widget doCharging() {
    return FutureBuilder<dynamic>(
      future: WebServices(this.mApiListener).createPayment(widget.paymentAmount,
          widget.projectData, widget.method, 'pending', widget.is_recurring),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          var data = snapshot.data;

          if (data == 200) {
            children = <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 120,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Thank you for your donation",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 19.0)),
              ),
              Divider(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Your Donation Will be Approved once you Submit the Deposit Slip',
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(
                height: 0,
              ),
              ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("May be later"),
                            textColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () => {}),
              ListTile(
                  title: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                          color: Colors.red,
                          onPressed: () async {
                            Navigator.of(context).pop();

                            Navigator.of(context).push(CupertinoPageRoute<Null>(
                                builder: (BuildContext context) {
                              return new PickImage(
                                "${widget.projectData['payment_id']}",
                              );
                            }));
                          },
                          child: Text(
                            'Submit Deposit Slip',
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                      ],
                    ),
                  ),
                  onTap: () => {}),
            ];
          } else {
            children = <Widget>[
              Text('Could not make donation. Please try again')
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
              child: Text('something Went Wrong !'), //Error: ${snapshot.error}
            )
          ];
        } else {
          children = <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: SizedBox(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor))),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Processing payment..'),
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
    );
  }

  Future _showDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: _result,
        );
      },
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
