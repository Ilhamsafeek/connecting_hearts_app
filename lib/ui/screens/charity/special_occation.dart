import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecting_hearts/constant/Constant.dart';

import '../../project_detail.dart';

class SpecialOccation extends StatefulWidget {
  SpecialOccation({Key key}) : super(key: key);

  _SpecialOccationState createState() => _SpecialOccationState();
}

class _SpecialOccationState extends State<SpecialOccation> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController(text: "");
  String selectedMethod = "bank";
  String selectedOccation = "birthday";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('My Special Occations')),
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
                                        value: 'birthday',
                                        groupValue: selectedOccation,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedOccation = T;
                                          });
                                        },
                                        title: Text('Birth')),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: RadioListTile(
                                        activeColor: Colors.black,
                                        value: 'anniversary',
                                        groupValue: selectedOccation,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedOccation = T;
                                          });
                                        },
                                        title: Text('Anniversary')),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: RadioListTile(
                                        activeColor: Colors.black,
                                        value: 'giftinmemory',
                                        groupValue: selectedOccation,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedOccation = T;
                                          });
                                        },
                                        title: Text('Gift in Memory')),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: RadioListTile(
                                        activeColor: Colors.black,
                                        value: 'fulfilavow',
                                        groupValue: selectedOccation,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedOccation = T;
                                          });
                                        },
                                        title: Text('Fulfil a Vow')),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: RadioListTile(
                                        activeColor: Colors.black,
                                        value: 'ifeelhappy ',
                                        groupValue: selectedOccation,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedOccation = T;
                                          });
                                        },
                                        title: Text('I Feel Happy ')),
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
                              SizedBox(
                                height: 3,
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
                                            // _formKey.currentState.validate()
                                            //     ? _navigateToPayment()
                                            //     : null;
                                          },
                                          child: Text("Donat Now"),
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
}
