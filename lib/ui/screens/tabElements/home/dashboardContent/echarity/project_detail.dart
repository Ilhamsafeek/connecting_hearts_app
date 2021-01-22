import 'package:braintree_payment/braintree_payment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connecting_hearts/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connecting_hearts/constant/Constant.dart';
import 'package:connecting_hearts/services/braintree.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:connecting_hearts/ui/screens/tabElements/home/dashboardContent/echarity/payment_result.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';
import 'package:connecting_hearts/utils/read_more_text.dart';
import 'package:connecting_hearts/utils/dialogs.dart';
import 'package:intl/intl.dart';

class ProjectDetail extends StatefulWidget {
  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();

  final dynamic projectData;

  ProjectDetail(this.projectData, {Key key}) : super(key: key);
}

class _ProjectDetailPageState extends State<ProjectDetail> {
  @override
  void initState() {
    super.initState();
  }

  static const _locale = 'en';

  String _formatNumber(String string) {
    final format = NumberFormat.decimalPattern(_locale);
    return format.format(int.parse(string));
  }

  String get currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  String selectedMethod = "bank";
  dynamic paymentAmount;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _amount = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>();
  String _dropDownValue;
  bool _recurring_value = false;
  bool _is_agree = false;
  Widget _warning = Text('I Agree With Above Details');

  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${widget.projectData['short_description']}',
                style: TextStyle(
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: widget.projectData['featured_image'],
                placeholder: (context, url) =>
                    Image.asset('assets/placeholder.png'),
                fit: BoxFit.cover,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share this appeal',
                onPressed: () {
                  Share.share('check out my website https://example.com',
                      subject: 'Please look at this appeal!');
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: _detailSection(),
                );
              },
              childCount: 1,
            ),
          ),
        ]));
  }

  Widget _detailSection() {
    print('=========================>>>>>>>${widget.projectData}');
    var paymentTypeExtension = "";
    var months = '${widget.projectData['months']}';
    if (widget.projectData['type'] == 'Recurring') {
      paymentTypeExtension = 'in $months Months';
    } else {}

    FlutterMoneyFormatter formattedAmount = FlutterMoneyFormatter(
        amount: double.parse('${widget.projectData['amount']}') *
            double.parse('$currencyValue'));
    FlutterMoneyFormatter formattedIncome;
    if (widget.projectData['appeal_type'] == "Individual") {
      formattedIncome = FlutterMoneyFormatter(
          amount: double.parse('${widget.projectData['income']}') *
              double.parse('$currencyValue'));
    }
    FlutterMoneyFormatter formattedRaised = FlutterMoneyFormatter(
        amount: double.parse('${widget.projectData['collected']}') *
            double.parse('$currencyValue'));

    double remainingAmount = double.parse('${widget.projectData['amount']}') -
        double.parse('${widget.projectData['collected']}');

    FlutterMoneyFormatter formattedRemainingAmount = FlutterMoneyFormatter(
        amount: remainingAmount * double.parse('$currencyValue'));
    double completedPercent = 100 *
        double.parse('${widget.projectData['collected']}') /
        double.parse('${widget.projectData['amount']}');
    Color completedColor = Colors.blue;
    Color percentColor = Colors.white;
    if (completedPercent >= 100) {
      completedPercent = 100.0;
      completedColor = Colors.orange;
    }

    double percent = completedPercent / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(
            24,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: RichText(
                      text: new TextSpan(
                        style: new TextStyle(
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                              text: 'Posted: ',
                              style:
                                  new TextStyle(fontWeight: FontWeight.w600)),
                          new TextSpan(text: '${widget.projectData['date']}'),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Star Rating:",
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.stars,
                    color: Colors.orange,
                    size: 18,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "${widget.projectData['rating']}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                  title: Text(
                    "Beneficiary Details",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  tileColor: Color.fromRGBO(80, 172, 225, 1)),
              Divider(height: 0),
              (widget.projectData['appeal_type'] == "Individual")
                  ? ListTile(
                      title: Text(
                          "\nAge: ${widget.projectData['age']}\nLocation: ${widget.projectData['city']},${widget.projectData['district']}\nOccupation: ${widget.projectData['occupation']}\nMonthly Income: ${currentUserData['currency']} ${formattedIncome.output.nonSymbol}\nNumber of Children: ${widget.projectData['children']}\nNumber of Family Members: ${widget.projectData['family']}\n"),
                    )
                  : ListTile(
                      title: (widget.projectData['appeal_type'] == 'Individual')
                          ? Text(
                              "Name: ${widget.projectData['name']}\nLocation: ${widget.projectData['city']},${widget.projectData['district']}")
                          : Text(
                              "Organization Name: ${widget.projectData['name']}\nLocation: ${widget.projectData['city']},${widget.projectData['district']}"),
                    )
            ],
          ),
        ),

        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                  title: Text(
                    "Description",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  tileColor: Color.fromRGBO(80, 172, 225, 1)),
              Divider(height: 0),
              ListTile(
                title: ReadMoreText("${widget.projectData['details']}"),
              ),
              ListTile(
                title: RichText(
                  text: new TextSpan(
                    style: new TextStyle(
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      new TextSpan(
                          text: 'This Appeal Requires:',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      new TextSpan(
                          text:
                              '\n${widget.projectData['type']} Payment $paymentTypeExtension'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),

        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 70),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      new Text('Total ${currentUserData['currency']}',
                          style: TextStyle(fontSize: 20)),
                      new Text('Raised ${currentUserData['currency']}',
                          style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  flex: 6,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      new Text('${formattedAmount.output.nonSymbol}',
                          style: TextStyle(fontSize: 24)),
                      new Text('${formattedRaised.output.nonSymbol}',
                          style: TextStyle(fontSize: 24)),
                    ],
                  ),
                  flex: 6,
                ),
              ],
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 70),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      new Text('Balance ${currentUserData['currency']}',
                          style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  flex: 7,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      new Text('${formattedRemainingAmount.output.nonSymbol}',
                          style: TextStyle(fontSize: 24)),
                    ],
                  ),
                  flex: 6,
                ),
              ],
            )),

        ListTile(
            title: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: FlatButton.icon(
                    icon: Icon(Icons.touch_app, color: Colors.black),
                    onPressed: () {
                      payModalBottomSheet(context, remainingAmount);
                    },
                    label: Text(
                      "Donate",
                      style: TextStyle(fontSize: 16),
                    ),
                    color: Colors.amber,
                  )),
                ],
              ),
            ),
            onTap: () => {}),

        // Padding(
        //     padding: const EdgeInsets.symmetric(
        //       vertical: 10,
        //     ),
        //     child: Center(
        //         child: FlatButton.icon(
        //       color: Colors.amber,
        //       onPressed: () {
        //         payModalBottomSheet(context);
        //       },
        //       icon: Icon(Icons.touch_app, color: Colors.black),
        //       label: Text(
        //         'Donate',
        //         style: TextStyle(color: Colors.black),
        //       ),
        //     )))
      ],
    );
  }

  Future<bool> payModalBottomSheet(context, remainingAmount) {
    return showModalBottomSheet(
        enableDrag: false,
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                      title: Text(
                        'Donating Amount',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      tileColor: Color.fromRGBO(80, 172, 225, 1)),
                  Divider(
                    height: 0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 60),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    new Text(currentUserData['currency'],
                                        style: TextStyle(fontSize: 32)),
                                  ],
                                ),
                                flex: 4,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextFormField(
                                      textAlign: TextAlign.center,
                                      controller: _amount,
                                      validator: (value) {
                                        FlutterMoneyFormatter
                                            formatedRemainingAmount =
                                            FlutterMoneyFormatter(
                                                amount: remainingAmount *
                                                    double.parse(
                                                        '$currencyValue'));
                                        print(formatedRemainingAmount);
                                        if (value.isEmpty) {
                                          return "Please input amount";
                                        }
                                        if (value=='0') {
                                                return "Please input amount";
                                              }
                                        if (remainingAmount *
                                                double.parse('$currencyValue') <
                                            double.parse(_amount.text
                                                .replaceAll(",", ""))) {
                                          return "Maximum: ${currentUserData['currency']} " +
                                              formatedRemainingAmount
                                                  .output.nonSymbol;
                                        }
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter
                                            .digitsOnly,
                                        CurrencyInputFormatter()
                                      ],
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        hintText: '0.00',
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32),
                                      ),
                                      onChanged: (value) {
                                        FlutterMoneyFormatter formattedAmount =
                                            FlutterMoneyFormatter(
                                                amount: double.parse(
                                                    '${_amount.text}'));
                                        print(
                                            "====================${formattedAmount.output.withoutFractionDigits}");
                                        // value = formattedAmount.output.withoutFractionDigits;
                                        //_amount.text=formattedAmount.output.withoutFractionDigits;
                                      },
                                    ),
                                 
                                  ],
                                ),
                                flex: 8,
                              ),
                            ],
                          ),
                        ),
                        //  Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //         vertical: 5, horizontal: 60),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.end,
                        //             children: [
                        //               new Text('This project will continue for ${widget.projectData['months']} Months',
                        //                   style: TextStyle(fontSize: 14)),
                        //             ],
                        //           ),
                        //           flex: 4,
                        //         ),

                        //       ],
                        //     ),
                        //   ),

                        widget.projectData['type'] == 'Recurring'
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 45),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        new Text(
                                            'This project will continue for ${widget.projectData['months']} Months',
                                            style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              new Text(
                                                  'I would like to donate monthly:',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          flex: 8,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Checkbox(
                                                value: _recurring_value,
                                                onChanged: (bool newValue) {
                                                  setState(() {
                                                    _recurring_value = newValue;
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                          flex: 2,
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                            : SizedBox(
                                height: 50,
                              ),
                        ListTile(
                            title: Text(
                              "Select a Donation Method",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            tileColor: Color.fromRGBO(80, 172, 225, 1)),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 11,
                              child: RadioListTile(
                                activeColor: Colors.black,
                                value: 'bank',
                                groupValue: selectedMethod,
                                onChanged: (T) {
                                  print(T);
                                  setState(() {
                                    selectedMethod = T;
                                  });
                                },
                                title: ListTile(
                                  leading: Icon(
                                    FontAwesomeIcons.solidMoneyBillAlt,
                                  ),
                                  title: Text('Bank Deposit'),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: IconButton(
                                icon: Icon(Icons.info_outline),
                                onPressed: () {
                                  infoModalBottomSheet(context);
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 11,
                              child: RadioListTile(
                                activeColor: Colors.black,
                                value: 'card',
                                groupValue: selectedMethod,
                                onChanged: (T) {
                                  print(T);
                                  setState(() {
                                    selectedMethod = T;
                                  });
                                },
                                title: ListTile(
                                  leading: Icon(
                                    Icons.credit_card,
                                    color: Colors.indigo[700],
                                    size: 30,
                                  ),
                                  title: Text('Online Payment'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListTile(
                            title: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: RaisedButton(
                                    onPressed: () {
                                      _formKey.currentState.validate()
                                          ? _navigateToPayment()
                                          : null;
                                    },
                                    child: Text("Donate Now",
                                        style: TextStyle(fontSize: 16)),
                                    color: Colors.amber,
                                  )),
                                ],
                              ),
                            ),
                            onTap: () => {}),
                      ])),
                ],
              ),
            );
          });
        });
  }

  // Widget paymentMethods() {
  //   return FutureBuilder<dynamic>(
  //     future: WebServices(this.mApiListener).getCustomerDataByMobile(),
  //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //       List<Widget> children;
  //       if (snapshot.hasData) {
  //         var data;
  //         if (snapshot.data.length != 0) {
  //           data = snapshot.data[0]['sources']['data'];
  //           children = <Widget>[
  //             for (var item in data)
  //               RadioListTile(
  //                 activeColor: Colors.black,
  //                 value: '${item['id']}',
  //                 groupValue: selectedMethod,
  //                 onChanged: selectMethod,
  //                 title: ListTile(
  //                   leading: Icon(
  //                     FontAwesomeIcons.ccVisa,
  //                     color: Colors.indigo[900],
  //                   ),
  //                   title: Text('****${item['last4']}'),
  //                 ),
  //               )
  //             // ),
  //           ];
  //         } else {
  //           children = <Widget>[
  //             ListTile(
  //               title: Text(
  //                 'Add Debit or Credit card',
  //                 style: TextStyle(color: Colors.blue),
  //               ),
  //               onTap: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(builder: (context) => StripePayment()),
  //                 );
  //               },
  //             ),
  //           ];
  //         }
  //       } else if (snapshot.hasError) {
  //         children = <Widget>[
  //           Icon(
  //             Icons.error_outline,
  //             color: Colors.red,
  //             size: 60,
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(top: 16),
  //             child: Text('something Went Wrong !'), //Error: ${snapshot.error}
  //           )
  //         ];
  //       } else {
  //         children = <Widget>[
  //           Padding(
  //             padding: EdgeInsets.only(top: 16),
  //             child: SizedBox(
  //                 child: CircularProgressIndicator(
  //                     valueColor: new AlwaysStoppedAnimation<Color>(
  //                         Theme.of(context).primaryColor))),
  //           ),
  //         ];
  //       }
  //       return Center(
  //         child: Column(children: children),
  //       );
  //     },
  //   );
  // }

  Future<bool> infoModalBottomSheet(context) {
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
                        title: Text('How Direct diposit works?'),
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
                    leading: Icon(Icons.featured_play_list),
                    title: Text('Cast your donation'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ),
                    title: Text('Click and submit deposit slip'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.rate_review,
                      color: Colors.blue[800],
                    ),
                    title: Text('Our team will review and update'),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: Colors.orange,
                    ),
                    title: Text('Finally you will get notified with status'),
                  ),
                ],
              ),
            );
          });
        });
  }

  _navigateToPayment() async {
    if (this.selectedMethod == 'bank') {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Checkout( widget.projectData,
                _amount.text.replaceAll(",", ""), 'bank', _recurring_value,'project payment','')),
      );
    } else {
      Navigator.pop(context);
      // _doCardCharging();
      cardPaymentAgreementBottomSheet(context);
    }
  }

  _doCardCharging() async {
    showWaitingProgress(context);
    print("Amount--------" + _amount.text.replaceAll(",", ""));
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => Checkout(
    //           selectedMethod, widget.projectData, _amount.text, 'bank')),
    // );
    String clientNonce =
        // "eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJlNTc1Mjc3MzZiODkyZGZhYWFjOTIxZTlmYmYzNDNkMzc2ODU5NTIxYTFlZmY2MDhhODBlN2Q5OTE5NWI3YTJjfGNyZWF0ZWRfYXQ9MjAxOS0wNS0yMFQwNzoxNDoxNi4zMTg0ODg2MDArMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJncmFwaFFMIjp7InVybCI6Imh0dHBzOi8vcGF5bWVudHMuc2FuZGJveC5icmFpbnRyZWUtYXBpLmNvbS9ncmFwaHFsIiwiZGF0ZSI6IjIwMTgtMDUtMDgifSwiY2hhbGxlbmdlcyI6W10sImVudmlyb25tZW50Ijoic2FuZGJveCIsImNsaWVudEFwaVVybCI6Imh0dHBzOi8vYXBpLnNhbmRib3guYnJhaW50cmVlZ2F0ZXdheS5jb206NDQzL21lcmNoYW50cy8zNDhwazljZ2YzYmd5dzJiL2NsaWVudF9hcGkiLCJhc3NldHNVcmwiOiJodHRwczovL2Fzc2V0cy5icmFpbnRyZWVnYXRld2F5LmNvbSIsImF1dGhVcmwiOiJodHRwczovL2F1dGgudmVubW8uc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbSIsImFuYWx5dGljcyI6eyJ1cmwiOiJodHRwczovL29yaWdpbi1hbmFseXRpY3Mtc2FuZC5zYW5kYm94LmJyYWludHJlZS1hcGkuY29tLzM0OHBrOWNnZjNiZ3l3MmIifSwidGhyZWVEU2VjdXJlRW5hYmxlZCI6dHJ1ZSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjp0cnVlLCJtZXJjaGFudEFjY291bnRJZCI6ImFjbWV3aWRnZXRzbHRkc2FuZGJveCIsImN1cnJlbmN5SXNvQ29kZSI6IlVTRCJ9LCJtZXJjaGFudElkIjoiMzQ4cGs5Y2dmM2JneXcyYiIsInZlbm1vIjoib2ZmIn0=";
        "sandbox_rz775339_x226f9698ybxg938"; // Tokenized key

    dynamic usd_amount = 0;
    await WebServices(mApiListener)
        .convertCurrency(currentUserData['currency'], 'USD',
            "${_amount.text.replaceAll(',', '')}")
        .then((value) {
      if (value != null) {
        usd_amount = double.parse(value).toStringAsFixed(2);
      }
    });

  dynamic lkrAmount = 0;
    await WebServices(mApiListener)
        .convertCurrency(currentUserData['currency'], 'LKR',
            "${_amount.text.replaceAll(',', '')}")
        .then((value) {
      if (value != null) {
        lkrAmount = double.parse(value).toStringAsFixed(2);
      }
    });
    print('USD Amount =======>>>>>> $usd_amount');
    BraintreePayment braintreePayment = new BraintreePayment();
    var companyData = await WebServices(this.mApiListener).getCompanyData();
    Navigator.pop(context);
    var data = await braintreePayment.showDropIn(
        nonce: companyData['tokenized_key'], amount: usd_amount);

    print("Response of the payment $data");
    showWaitingProgress(context);
    if (data['status'] == 'success') {
      var saleResponse = await Braintree(mApiListener).sale(usd_amount,lkrAmount,
          data['paymentNonce'], widget.projectData, 'card', 'pending','project payment','');

      print("===============" + saleResponse);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.green[600],
        content: Text("$saleResponse"),
      ));
    }
    Navigator.pop(context);
  }

  Future<bool> cardPaymentAgreementBottomSheet(context) {
    FlutterMoneyFormatter formattedAmount = FlutterMoneyFormatter(
        amount: double.parse("${_amount.text.replaceAll(',', '')}"));
    return showModalBottomSheet(
        enableDrag: false,
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
                        title: Text(
                          "Donation Confirmation",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        tileColor: Color.fromRGBO(80, 172, 225, 1),
                        trailing: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )),
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
                              text: " ${widget.projectData['category']}\n\n"),
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
                              text: " ${formattedAmount.output.nonSymbol}\n\n",
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
                    onTap: (){
                       setState(() {
                           _is_agree==true? _is_agree = false:_is_agree=true;
                          });
                    },
                  ),
                  Divider(height: 10),
                  Center(
                    child: Column(
                      children: [
                        FlatButton.icon(
                          onPressed: () {
                            if (_is_agree) {
                              setState(() {
                                Navigator.pop(context);

                                _doCardCharging();
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
                          icon: Icon(Icons.check_circle_outline,
                              color: Colors.black),
                          label: Text(
                            'Confirm Donation',
                            style: TextStyle(color: Colors.black),
                          ),
                          color: Colors.amber,
                        )
                      ],
                    ),
                  )
                  ,SizedBox(height:MediaQuery.of(context).size.height / 3)
                
                ],
              ),
            );
          });
        });
  }

}
