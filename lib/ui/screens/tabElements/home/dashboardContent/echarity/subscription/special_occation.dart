import 'package:braintree_payment/braintree_payment.dart';
import 'package:connecting_hearts/services/braintree.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:connecting_hearts/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:connecting_hearts/constant/Constant.dart';

import '../payment_result.dart';
import '../project_detail.dart';



class SpecialOccation extends StatefulWidget {
  SpecialOccation({Key key}) : super(key: key);

  _SpecialOccationState createState() => _SpecialOccationState();
}

class _SpecialOccationState extends State<SpecialOccation> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController(text: "");
  String selectedMethod = "bank";
  String selectedOccation = "birthday";
  ApiListener mApiListener;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _is_agree = false;
  Widget _warning = Text('I Agree With Above Details');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
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
                                            _formKey.currentState.validate()
                                                ? _navigateToPayment()
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
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Checkout(null,
                _amount.text.replaceAll(",", ""), 'bank', "")),
      );
    } else {
      Navigator.pop(context);
      // _doCardCharging();
      cardPaymentAgreementBottomSheet(context);
    }
  }

  _doCardCharging() async {
    showWaitingProgress(context);
  
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
          data['paymentNonce'], null, 'card', 'pending');

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
                              text: 'Donation Category :',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          new TextSpan(
                              text: " $selectedOccation\n\n"),
                         
                        
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
