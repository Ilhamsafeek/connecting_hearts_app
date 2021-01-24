import 'dart:async';

import 'package:braintree_payment/braintree_payment.dart';
import 'package:connecting_hearts/services/braintree.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:connecting_hearts/services/webservices.dart';
import 'package:connecting_hearts/utils/currency_formatter.dart';
import 'package:connecting_hearts/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecting_hearts/constant/Constant.dart';

import '../payment_result.dart';
import '../project_detail.dart';

class Subscription extends StatefulWidget {
  Subscription({Key key}) : super(key: key);

  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  ApiListener mApiListener;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController(text: "");
  String selectedMethod = "bank";
  String selectedPeriod = "Daily";
  String selectedPaymentPackage = "Monthly";

  dynamic daily_amount = 0;
  dynamic weekly_amount = 0;
  dynamic monthly_amount = 0;
  dynamic annual_amount = 0;
  bool _is_agree = false;
  Widget _warning = Text('I Agree With Above Details');
  dynamic chargin_amount = 0;
  dynamic _decissionPanel = null;
  // List<String> _currencies = ['LKR','USD', 'EUR', 'JPY', 'GBP','AUD', 'KWD', 'CNH', 'GBP'];
  // String _selectedCurrency;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Subscription')),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    child: new Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: (16 / 7),
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: RadioListTile(
                                        activeColor: Colors.black,
                                        value: 'Daily',
                                        groupValue: selectedPeriod,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedPeriod = T;
                                            _decissionPanel = decissionPanel();
                                          });
                                        },
                                        title: Container(
                                            height: 70,
                                            color: Colors.blue,
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Text(
                                                    'Daily',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  // Text(
                                                  //   '$daily_amount',
                                                  //   style: TextStyle(
                                                  //       color: Colors.white,
                                                  //       fontWeight:
                                                  //           FontWeight.bold),
                                                  // )
                                                ],
                                              ),
                                            ))),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: RadioListTile(
                                        activeColor: Colors.black,
                                        value: 'Weekly',
                                        groupValue: selectedPeriod,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedPeriod = T;

                                            _decissionPanel = decissionPanel();
                                          });
                                        },
                                        title: Container(
                                            height: 70,
                                            color: Colors.yellow[700],
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Text(
                                                    'Weekly',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  // Text(
                                                  //   '$weekly_amount',
                                                  //   style: TextStyle(
                                                  //       color: Colors.white,
                                                  //       fontWeight:
                                                  //           FontWeight.bold),
                                                  // )
                                                ],
                                              ),
                                            ))),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: RadioListTile(
                                        activeColor: Colors.black,
                                        value: 'Monthly',
                                        groupValue: selectedPeriod,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedPeriod = T;
                                            _decissionPanel = decissionPanel();
                                          });
                                        },
                                        title: Container(
                                            height: 70,
                                            color: Colors.green[300],
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Text(
                                                    'Monthly',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  // Text(
                                                  //   '$monthly_amount',
                                                  //   style: TextStyle(
                                                  //       color: Colors.white,
                                                  //       fontWeight:
                                                  //           FontWeight.bold),
                                                  // )
                                                ],
                                              ),
                                            ))),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: RadioListTile(
                                        activeColor: Colors.black,
                                        value: 'Annually',
                                        groupValue: selectedPeriod,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedPeriod = T;
                                            _decissionPanel = decissionPanel();
                                          });
                                        },
                                        title: Container(
                                            height: 70,
                                            color: Colors.pink[900],
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Text(
                                                    'Annually',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  // Text(
                                                  //   '$annual_amount',
                                                  //   style: TextStyle(
                                                  //       color: Colors.white,
                                                  //       fontWeight:
                                                  //           FontWeight.bold),
                                                  // )
                                                ],
                                              ),
                                            ))),
                                  ),
                                ],
                              ),
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                            title: Text(
                              'Donating Amount',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            tileColor: Color.fromRGBO(80, 172, 225, 1)),
                        SizedBox(
                          height: 10,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            currentUserData['currency'],
                                            style: TextStyle(fontSize: 20),
                                          )
                                        ],
                                      ),
                                      flex: 4,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          TextFormField(
                                            textAlign: TextAlign.center,
                                            controller: _amount,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Please input amount";
                                              }
                                              if (value == '0') {
                                                return "Please input amount";
                                              }
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
                                                  // WhitelistingTextInputFormatter.digitsOnly,
                                              // CurrencyInputFormatter()
                                              // FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                              CurrencyInputFormatter(decimalRange: 2)
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
                                              setState(() {
                                                _decissionPanel =
                                                    decissionPanel();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      flex: 8,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              "(Daily / Weekly amount will be deducted Monthly)")
                                        ],
                                      ),
                                      flex: 8,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: _decissionPanel,
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
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 11,
                                    child: RadioListTile(
                                      activeColor: Colors.black,
                                      value: 'direct debit',
                                      groupValue: selectedMethod,
                                      onChanged: (T) {
                                        print(T);
                                        setState(() {
                                          selectedMethod = T;
                                        });
                                      },
                                      title: ListTile(
                                        leading: Icon(
                                          Icons.money,
                                          color: Colors.indigo[700],
                                          size: 30,
                                        ),
                                        title: Text('Direct Debit'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
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
                })
              ],
            ),
          ),
        ));
  }

  _navigateToPayment() async {
    if (this.selectedMethod == 'bank' ||
        this.selectedMethod == 'direct debit') {
      // Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Checkout(
                null,
                chargin_amount.replaceAll(",", ""),
                this.selectedMethod,
                "",
                'subscription',
                selectedPeriod)),
      );
    } else if (selectedMethod == 'card') {
      cardPaymentAgreementBottomSheet(context);
    }
  }

  _doCardCharging() async {
    showWaitingProgress(context);

    dynamic usd_amount = 0;
    await WebServices(mApiListener)
        .convertCurrency(currentUserData['currency'], 'USD',
            "${chargin_amount.replaceAll(',', '')}")
        .then((value) {
      if (value != null) {
        usd_amount = double.parse(value).toStringAsFixed(2);
      }
    });

    dynamic lkrAmount = 0;
    await WebServices(mApiListener)
        .convertCurrency(currentUserData['currency'], 'LKR',
            "${chargin_amount.replaceAll(',', '')}")
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
      var saleResponse = await Braintree(mApiListener).sale(
          usd_amount,
          lkrAmount,
          data['paymentNonce'],
          null,
          'card',
          'pending',
          'subscription',
          selectedPeriod);

      print("===============" + saleResponse);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.green[600],
        content: Text("$saleResponse"),
      ));
    }
    Navigator.pop(context);
    Timer(Duration(seconds: 2), () {
      // 5s over, navigate to a new page

      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  Future<bool> cardPaymentAgreementBottomSheet(context) {
    FlutterMoneyFormatter formattedAmount = FlutterMoneyFormatter(
        amount: double.parse("${chargin_amount.replaceAll(',', '')}"));
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
                              text: 'Donation Category :',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          new TextSpan(text: " $selectedPeriod\n\n"),
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
                    onTap: () {
                      setState(() {
                        _is_agree == true
                            ? _is_agree = false
                            : _is_agree = true;
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
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 3)
                ],
              ),
            );
          });
        });
  }

  Future<bool> directDepositModalBottomSheet(context) {
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
                      'Direct Deposit Details',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    tileColor: Colors.grey[300],
                  ),
                  Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Account Name:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'ZamZam Foundation',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Account Number:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '35874356918395629',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Branch:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Colombo',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'SWIFT Code:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '2463',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: RaisedButton(
                          onPressed: () {},
                          child: Text("Continue"),
                          color: Colors.amber,
                        )),
                  )
                ],
              ),
            );
          });
        });
  }

  Widget decissionPanel() {
    dynamic value=_amount.text;
    if (value == ''||_amount == null) {
      value = '0';
    } else {
      value = _amount.text.replaceAll(",", "");
    }
    print('done');
    _setFinalAmounts(value);
    if (selectedPeriod != 'Annually' && value != '0') {
      return GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          childAspectRatio: (16 / 5),
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: RadioListTile(
                      activeColor: Colors.black,
                      value: 'Monthly',
                      groupValue: selectedPaymentPackage,
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          selectedPaymentPackage = value;
                          _decissionPanel = decissionPanel(); //Refreshing it
                        });
                      },
                      title: Container(
                          height: 100,
                          color: Colors.grey[350],
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 18,
                                ),
                                Text(
                                  'Donate for this month',
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '${currentUserData['currency']} $monthly_amount',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                )
                              ],
                            ),
                          ))),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: RadioListTile(
                      activeColor: Colors.black,
                      value: 'Annually',
                      groupValue: selectedPaymentPackage,
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          selectedPaymentPackage = value;
                          _decissionPanel = decissionPanel(); //Refreshing it
                        });
                      },
                      title: Container(
                          height: 100,
                          color: Colors.pink[900],
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 18,
                                ),
                                Text(
                                  'Donate for this year',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                    '${currentUserData['currency']} $annual_amount',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ))
                              ],
                            ),
                          ))),
                ),
              ],
            ),
          ]);
    } else {
      return null;
    }
  }

  _setFinalAmounts(value) {
    setState(() {
      if (selectedPeriod == 'Daily') {
        monthly_amount = double.parse("$value") * 30;
        annual_amount = monthly_amount * 12;
      } else if (selectedPeriod == 'Weekly') {
        monthly_amount = double.parse("$value") * 4;
        annual_amount = monthly_amount * 12;
      } else if (selectedPeriod == 'Monthly') {
        monthly_amount = double.parse("$value");
        annual_amount = monthly_amount * 12;
      } else if (selectedPeriod == 'Annually') {
        monthly_amount = double.parse("$value");
        annual_amount = double.parse("$value");
        print("=======<<<<"+annual_amount.toString());
      }

      monthly_amount =
          FlutterMoneyFormatter(amount: double.parse('$monthly_amount'))
              .output
              .nonSymbol;
              print("=======>>>>"+monthly_amount);
      annual_amount =
          FlutterMoneyFormatter(amount: double.parse('$annual_amount'))
              .output
              .nonSymbol;
 print("=======:Annual:>>>>"+annual_amount);
      if (selectedPaymentPackage == 'Monthly') {
        chargin_amount = monthly_amount.toString();
      } else if (selectedPaymentPackage == 'Annually') {
        chargin_amount = annual_amount.toString();
      }
    });
  }
}
