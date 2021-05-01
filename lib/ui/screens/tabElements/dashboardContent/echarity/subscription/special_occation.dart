import 'dart:async';
import 'dart:io';

import 'package:braintree_payment/braintree_payment.dart';
import 'package:connecting_hearts/services/braintree.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:connecting_hearts/utils/currency_formatter.dart';
import 'package:connecting_hearts/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecting_hearts/constant/Constant.dart';

import '../payment_result.dart';

class SpecialOccation extends StatefulWidget {
  SpecialOccation({Key key}) : super(key: key);

  _SpecialOccationState createState() => _SpecialOccationState();
}

class _SpecialOccationState extends State<SpecialOccation> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController(text: "");
  String selectedMethod = "bank";
  String selectedOccation = "Birth";
  ApiListener mApiListener;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: non_constant_identifier_names
  bool _is_agree = false;
  Widget _warning = Text('I Agree');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('My Special Occasions')),
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
                         ListTile(
                contentPadding: EdgeInsets.all(10),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Donate here to celebrate or commemorate any special occasion close to your heart, or simply if you are feeling happy and thankful about your blessings, why not spend in charity now?',style: TextStyle(fontSize: 14, color: Colors.white),),
                    Text('\n(The donations from this window will go directly to Zam Zam Foundation’s Admin account.)', style: TextStyle(fontSize: 13, color: Colors.white),),
                  ],
                ),
                tileColor: Colors.green
                ,onTap: (){
                 
                },),
            
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
                                        value: 'Birth',
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
                                        value: 'Anniversary',
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
                                        value: 'Gift in Memory',
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
                                        value: 'Fulfil a Vow',
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
                                        value: 'I feel happy',
                                        groupValue: selectedOccation,
                                        onChanged: (T) {
                                          print(T);
                                          setState(() {
                                            selectedOccation = T;
                                          });
                                        },
                                        title: Text('I Feel Happy Today')),
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
                                            // ignore: missing_return
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
                                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                            //  WhitelistingTextInputFormatter.digitsOnly,
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
                                              // FlutterMoneyFormatter
                                              //     formattedAmount =
                                              //     FlutterMoneyFormatter(
                                              //         amount: double.parse(
                                              //             '${_amount.text}'));
                                              // print(
                                              //     "====================${formattedAmount.output.withoutFractionDigits}");
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
                              // Row(
                              //   children: <Widget>[
                              //     Expanded(
                              //       flex: 11,
                              //       child: RadioListTile(
                              //         activeColor: Colors.black,
                              //         value: 'card',
                              //         groupValue: selectedMethod,
                              //         onChanged: (T) {
                              //           print(T);
                              //           setState(() {
                              //             selectedMethod = T;
                              //           });
                              //         },
                              //         title: ListTile(
                              //           leading: Icon(
                              //             Icons.credit_card,
                              //             color: Colors.indigo[700],
                              //             size: 30,
                              //           ),
                              //           title: Text('Online Payment'),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              
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
                                                // ignore: unnecessary_statements
                                                : null;
                                          },
                                          child: Text("Donate Now"),
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
    if (this.selectedMethod == 'bank') {
      // Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Checkout(
                null,
                _amount.text.replaceAll(",", ""),
                'bank',
                "",
                'occasion',
                selectedOccation)),
      );
    } else {
      // Navigator.pop(context);
      // _doCardCharging();
      cardPaymentAgreementBottomSheet(context);
    }
  }

  _doCardCharging() async {
    showWaitingProgress(context);

    dynamic usdAmount = 0;
    await WebServices(mApiListener)
        .convertCurrency(currentUserData['currency'], 'USD',
            "${_amount.text.replaceAll(',', '')}")
        .then((value) {
      if (value != null) {
        usdAmount = double.parse(value).toStringAsFixed(2);
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
    print('USD Amount =======>>>>>> $usdAmount');
    BraintreePayment braintreePayment = new BraintreePayment();
    var companyData = await WebServices(this.mApiListener).getCompanyData();
    Navigator.pop(context);
    var data = await braintreePayment.showDropIn(
        nonce: companyData['tokenized_key'], amount: usdAmount);

    print("Response of the payment $data");
    showWaitingProgress(context);
     if (Platform.isAndroid) {
    if (data['status'] == 'success') {
      var saleResponse = await Braintree(mApiListener).sale(
          usdAmount,
          lkrAmount,
          data['paymentNonce'],
          null,
          'card',
          'pending',
          'occasion',
          selectedOccation);

      print("===============" + saleResponse);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.green[600],
        content: Text("$saleResponse"),
      ));
    }
     }else{
        if (data!=null) {
            var saleResponse = await Braintree(mApiListener).sale(
          usdAmount,
          lkrAmount,
          data['paymentNonce'],
          null,
          'card',
          'pending',
          'occasion',
          selectedOccation);

      print("===============" + saleResponse);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.green[600],
        content: Text("$saleResponse"),
      ));
        }
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
                              text: 'Donation Category :',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          new TextSpan(text: " $selectedOccation\n\n"),
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
                                  "I confirm that this donation is through my own sources of funding, legally compliant and i take responsibility / complete liability for all information provided. (Full T&C)"),
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
                                    leading: Text('I Agree With'),
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
}
