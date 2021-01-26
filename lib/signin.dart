import 'package:country_list_pick/country_list_pick.dart';
import 'package:currency_pickers/country.dart';
import 'package:currency_pickers/currency_pickers.dart';
import 'package:currency_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:country_pickers/country.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';
import 'package:connecting_hearts/constant/Constant.dart';
import 'package:connecting_hearts/services/webservices.dart';
import 'package:connecting_hearts/services/apilistener.dart';
// import 'package:country_pickers/country_pickers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connecting_hearts/utils/dialogs.dart';

class Signin extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<Signin> {
  final TextEditingController amountController = TextEditingController();

  ApiListener mApiListener;
  String phoneNo;
  String countryPhoneCode = '+94';
  String countryCode = 'LK';
  String smsCode;
  String verificationId;
  var _mobileController = new MaskedTextController(mask: '0000000000000');

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  // Widget _signoutProgress;

  Future<void> verifyPhone() async {
    Navigator.pop(context);
    final PhoneCodeAutoRetrievalTimeout autoRetrive = (String verId) {
      this.verificationId = verId;
      smsCodeDialog(context);
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('signed in');
        CURRENT_USER = "${this.countryPhoneCode}${this.phoneNo}";
      });
    };
    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential credential) {
      print('verified');
      CURRENT_USER = "${this.countryPhoneCode}${this.phoneNo}";

      FirebaseAuth.instance.signInWithCredential(credential).then((user) {
        if (user != null) {
          _redirect();
        }
      }).catchError((e) {
        print(e);
      });
    };
    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print('From here: ${exception.message}');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("${exception.message}"),
      ));
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${this.countryPhoneCode}${this.phoneNo}",
      codeAutoRetrievalTimeout: autoRetrive,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: veriFailed,
    );
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contect) {
          double deviceHeight(BuildContext context) =>
              MediaQuery.of(context).size.height;

          double deviceWidth(BuildContext context) =>
              MediaQuery.of(context).size.width;
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text("Mobile verification",
                    style: TextStyle(fontFamily: "Exo2", color: Colors.white)),
              ),
              body: Padding(
                  padding: EdgeInsets.only(
                    top: deviceHeight(context) * 0.3,
                    // left: deviceWidth(context) * 0.09,
                    // bottom: deviceHeight(context) * 0.06,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Center(
                              child: Text(
                                  "Enter the 6 digit code sent to ${this.phoneNo}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          new VerificationCodeInput(
                            keyboardType: TextInputType.number,
                            length: 6,
                            onCompleted: (String value) {
                              this.smsCode = value;
                            },
                          ),
                          Spacer(),
                          Container(
                            child: Ink(
                              decoration: ShapeDecoration(
                                color: Colors.black,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward),
                                color: Colors.white,
                                onPressed: () {
                                  FirebaseAuth.instance
                                      .currentUser()
                                      .then((user) {
                                    if (user != null) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .pushReplacementNamed(HOME_PAGE);
                                    } else {
                                      Navigator.of(context).pop();
                                      signIn();
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )));
        });
  }

  signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    FirebaseAuth.instance.signInWithCredential(credential).then((user) async {
      if (user != null) {
        _redirect();
      }
    }).catchError((e) {
      print("====>>>>${e.message}");
    });
  }

  _redirect() async {
    CURRENT_USER = '${this.countryPhoneCode}${this.phoneNo}';
    var userdata = await WebServices(this.mApiListener).getUserData();
    
    print("======User Data======$userdata");
    if (userdata != null && userdata.length!=0) {
      currentUserData = userdata;
      if (userdata.length != 0) {
        Navigator.pop(context);
        Navigator.of(context).pushReplacementNamed(HOME_PAGE);
      } else {
        _registerUser();
      }
    } else {
      _registerUser();
    }
  }

  _registerUser() async {
    showWaitingProgress(context);
    await WebServices(this.mApiListener)
        .createAccount('${this.countryPhoneCode}${this.phoneNo}', countryCode);
    Navigator.pop(context);

    Navigator.of(context).pushReplacement(
        CupertinoPageRoute<Null>(builder: (BuildContext context) {
      return new Details();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text("Signin",
      //       style: TextStyle(fontFamily: "Exo2", color: Colors.white)),
      // ),
      body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            image: DecorationImage(
                image: AssetImage(
                  "assets/conecting-hearts-logo.png",
                ),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ListTile(
                  title: Center(
                    child: Text("You make a difference, We make it easy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Architekt',
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.all(16.0),
                    decoration: new BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2),
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0),
                          bottomLeft: const Radius.circular(10.0),
                          bottomRight: const Radius.circular(10.0),
                        )),
                    child: Column(children: <Widget>[
                      Text('Please enter your mobile number',
                          style: TextStyle(fontSize: 18, fontFamily: "Exo2")),
                      // SizedBox(height: 2.0, child: _signoutProgress),
                      SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: CountryListPick(
                              appBar: AppBar(
                                title: Text('Choose a Country'),
                              ),
                              useUiOverlay: false,
                              useSafeArea: true,
                              // if you need custome picker use this
                              pickerBuilder:
                                  (context, CountryCode countryCode) {
                                return Row(
                                  children: [
                                    Image.asset(
                                      countryCode.flagUri,
                                      package: 'country_list_pick',
                                      width: 40,
                                    ),
                                    // Text(countryCode.code),
                                    Text(
                                        " " +
                                            countryCode.dialCode +
                                            "(" +
                                            countryCode.code +
                                            ")",
                                        style: TextStyle(
                                          fontSize: 18,
                                        )),
                                  ],
                                );
                              },
                              theme: CountryTheme(
                                isShowFlag: true,
                                isShowTitle: true,
                                isShowCode: true,
                                isDownIcon: true,
                                showEnglishName: true,
                              ),
                              initialSelection: '+94',
                              onChanged: (CountryCode code) {
                                print(code.name);
                                print(code.code);
                                print(code.dialCode);
                                print(code.flagUri);
                                this.countryPhoneCode = "${code.dialCode}";
                                this.countryCode = "${code.code}";
                              },
                            ),

                            // CountryPickerDropdown(
                            //   initialValue: 'LK',
                            //   itemBuilder: _buildDropdownItem,
                            //   itemFilter: (Country country) {
                            //     return ['AR', 'DE', 'GB', 'CN', 'LK', 'AU']
                            //         .contains(country.isoCode);
                            //   },
                            //   onValuePicked: (Country country) {
                            //     this.countryPhoneCode = "+${country.phoneCode}";
                            //     this.countryCode = "${country.isoCode}";
                            //   },
                            // ),
                          ),
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              controller: _mobileController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter phone number.';
                                }
                                if (value[0] == '0') {
                                  return 'Please remove leading 0';
                                }
                              },
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                focusColor: Colors.black,
                                hintText: "",
                              ),
                              style: TextStyle(fontSize: 18),
                              onChanged: (value) {
                                print("======>>>$value");

                                this.phoneNo = _mobileController.text;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      RaisedButton(
                        onPressed: () {
                          setState(() {
                            // _signoutProgress = LinearProgressIndicator(
                            //   backgroundColor: Colors.white,
                            //   valueColor: new AlwaysStoppedAnimation<Color>(
                            //       Colors.black),
                            // );
                            showWaitingProgress(context);

                            if (_formKey.currentState.validate()) {
                              verifyPhone();
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Please check the input"),
                              ));
                              // setState(() {
                              //   // _signoutProgress = null;
                              //   Navigator.pop(context);
                              // });
                            }
                          });
                        },
                        child: Text('Signin to Continue',
                            style: TextStyle(color: Colors.white)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        color: Theme.of(context).primaryColor,
                      )
                    ])),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .10,
                    padding: const EdgeInsets.all(16.0),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(children: <Widget>[
                      Image.asset(
                        'assets/zamzamlogo.png',
                        width: 100,
                      )
                    ]))
              ],
            ),
          )),
    );
  }
}

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  ApiListener mApiListener;
  dynamic totalContribution = 0;
  final _emailController = TextEditingController(text: "");
  final _firstNameController = TextEditingController(text: "");
  final _lastNameController = TextEditingController(text: "");
  dynamic _currencyCode = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _is_agree = false;

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
          title: Text('Account Registration'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
              child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        Column(
                          children: <Widget>[
                            SpinKitThreeBounce(
                              color: Colors.grey,
                              size: 50.0,
                            ),
                            SizedBox(height: 20.0),
                            Text('One more step to go',
                                style: TextStyle(
                                    fontSize: 18, fontFamily: "Exo2")),

                            SizedBox(height: 40.0),
                            Row(children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _firstNameController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'please enter first name.';
                                    }
                                    if (value.length < 5) {
                                      return 'choose a firast name with atleast 5 chars.';
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    // border: OutlineInputBorder(),
                                    labelText: 'First Name',
                                    hintText: '',
                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _lastNameController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'please enter last name.';
                                    }
                                    if (value.length < 5) {
                                      return 'choose a last name with atleast 5 chars.';
                                    }
                                  },
                                  // controller: _usernameController,
                                  decoration: InputDecoration(
                                    // border: OutlineInputBorder(),
                                    labelText: 'Last Name',
                                    hintText: '',
                                  ),
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ]),
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter email.';
                                }
                                if (value.length < 5) {
                                  return 'enter a valid email address';
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'email format is not valid';
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                // border: OutlineInputBorder(),
                                labelText: 'Email',
                                hintText: '',
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: 30.0),
                            Row(
                              children: [
                                Text("Currency: ",
                                    style: TextStyle(
                                        fontSize: 16, fontFamily: "Exo2")),
                                SizedBox(
                                  width: 8,
                                ),
                                CurrencyPickerDropdown(
                                  initialValue: 'lk',
                                  itemBuilder: _buildDropdownItem,
                                  onValuePicked: (Country country) {
                                    print("${country.currencyCode}");
                                    _currencyCode = country.currencyCode;
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 15.0),
                            ListTile(
                              leading: Checkbox(
                                  value: _is_agree,
                                  onChanged: (value) {
                                    setState(() {
                                      _is_agree = value;
                                    });
                                  }),
                              title:
                                  Text('I would like to receive notifications'),
                            ),

                            SizedBox(height: 15.0),
                            RaisedButton(
                              onPressed: () {
                                showWaitingProgress(context);
                                _formKey.currentState.validate()
                                    ? WebServices(this.mApiListener)
                                        .updateUser(
                                            _currencyCode,
                                            _emailController.text,
                                            _firstNameController.text,
                                            _lastNameController.text,
                                            '')
                                        .then((value) {
                                        if (value == 200) {
                                          Navigator.pop(context);
                                          Navigator.of(context)
                                              .pushReplacementNamed(HOME_PAGE);
                                        } else {
                                          Navigator.pop(context);
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Something went wrong. Please try again."),
                                          ));
                                        }
                                      })
                                    : _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                        content:
                                            Text("Please check the inputs"),
                                      ));
                              },
                              child: Text('Register and Continue',
                            style: TextStyle(color: Colors.white)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        color: Theme.of(context).primaryColor,
                      )
                          ],
                        )
                      ])))),
        ));
  }

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CurrencyPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Text("+${country.currencyCode}(${country.isoCode})"),
          ],
        ),
      );
}
