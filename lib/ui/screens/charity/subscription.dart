import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecting_hearts/constant/Constant.dart';
import 'package:connecting_hearts/management_webview.dart';

import '../../project_detail.dart';

class Subscription extends StatefulWidget {
  Subscription({Key key}) : super(key: key);

  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController(text: "");
  String selectedMethod = "bank";
  String selectedPeriod = "daily";
  // List<String> _currencies = ['LKR','USD', 'EUR', 'JPY', 'GBP','AUD', 'KWD', 'CNH', 'GBP'];
  // String _selectedCurrency;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: new Wrap(
                      children: <Widget>[
                        GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: (16 / 5),
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: RadioListTile(
                                        activeColor: Colors.black,
                                        value: 'daily',
                                        groupValue: selectedPeriod,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedPeriod = T;
                                          });
                                        },
                                        title: Text('Daily')),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: RadioListTile(
                                        activeColor: Colors.black,
                                        value: 'weekly',
                                        groupValue: selectedPeriod,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedPeriod = T;
                                          });
                                        },
                                        title: Text('Weekly')),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: RadioListTile(
                                        activeColor: Colors.black,
                                        value: 'monthly',
                                        groupValue: selectedPeriod,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedPeriod = T;
                                          });
                                        },
                                        title: Text('Monthly')),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: RadioListTile(
                                        activeColor: Colors.black,
                                        value: 'annually',
                                        groupValue: selectedPeriod,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedPeriod = T;
                                          });
                                        },
                                        title: Text('Annually')),
                                  ),
                                ],
                              ),
                            ]),
                        ListTile(
                            title: Text(
                              'Donating Amount',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(currentUserData['currency'], style: TextStyle(fontSize: 20),)
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
                                            },
                                            inputFormatters: <
                                                TextInputFormatter>[
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
                                              FlutterMoneyFormatter
                                                  formattedAmount =
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
                                            if(selectedPeriod=='annually')
                                            Text("(Daily / Weekly amount will be deducted "+selectedPeriod+")"),
                                            if(selectedPeriod!='annually')
                                            Text("(Daily / Weekly amount will be deducted Monthly)")
                                        ],
                                      ),
                                      flex: 8,
                                    ),
                                    
                                  ],
                                ),
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
                                      value: 'direct',
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
                                            if (selectedMethod == 'direct') {
                                              payModalBottomSheet(context);
                                            } else if (selectedMethod ==
                                                'card') {}
                                          },
                                          child: Text("Donate Now", style: TextStyle(fontSize: 16)),
                                          color: Colors.amber,
                                        )),
                                      ],
                                    ),
                                  ),
                                  onTap: () => {

                   

                                  }),
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

  Future<bool> payModalBottomSheet(context) {
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
}
