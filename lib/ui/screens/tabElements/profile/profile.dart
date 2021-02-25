import 'package:currency_pickers/country.dart';
import 'package:currency_pickers/currency_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connecting_hearts/constant/Constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connecting_hearts/signin.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:connecting_hearts/ui/screens/tabElements/profile/about.dart';
import 'package:connecting_hearts/utils/dialogs.dart';
import 'package:currency_pickers/countries.dart';

import 'privacy_policy.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  ApiListener mApiListener;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  Widget _signoutProgress;

  
  var _emailController;
  var _firstNameController;
  var _lastNameController;
  var _addressController;

  dynamic _country;
  dynamic _currencyCode;
  var _receive_notifications;

@override
  void initState() {
    super.initState();
    setState(() {
       _emailController =TextEditingController(text: "${currentUserData['email']}");
       _addressController =TextEditingController(text: "${currentUserData['address']}");

   _firstNameController =TextEditingController(text: "${currentUserData['firstname']}");
   _lastNameController =TextEditingController(text: "${currentUserData['lastname']}");
   _country = "${currentUserData['country']}";
   _currencyCode = "${currentUserData['currency']}";
   _receive_notifications =currentUserData['receive_notification'].toLowerCase() == 'true';
    });
  
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
                child: ListTile(
              title: Center(
                child: Image.asset(
                  'assets/logo.png',
                  // color: Colors.grey[200],
                  height: MediaQuery.of(context).size.height * .15,
                  fit: BoxFit.fitWidth,
                ),
              ),
              subtitle: Center(
                child: Text(
                  CURRENT_USER,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )),
            Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    children :<Widget>[
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _firstNameController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter first name.';
                                }
                                if (value.length < 5) {
                                  return 'choose a firast name with atleast 5 chars.';
                                }
                              },
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
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter last name.';
                                }
                                if (value.length < 5) {
                                  return 'choose a last name with atleast 5 chars.';
                                }
                              },
                              decoration: InputDecoration(
                                // border: OutlineInputBorder(),
                                labelText: 'Last Name',
                                hintText: '',
                              ),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text("Currency: ",
                                style: TextStyle(
                                    fontSize: 16, fontFamily: "Exo2")),
                            SizedBox(
                              width: 8,
                            ),
                            CurrencyPickerDropdown(
                              initialValue: countryList
                                  .firstWhere(
                                    (country) =>
                                        country.currencyCode == _currencyCode,
                                  )
                                  .isoCode,
                              itemBuilder: _buildDropdownItem,
                              onValuePicked: (Country country) {
                                print("${country.currencyCode}");

                                _currencyCode = country.currencyCode;
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter email address.';
                                }
                                if (value.length < 5) {
                                  return 'choose a username with atleast 5 chars.';
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'email format is not valid';
                                }
                              },
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                                hintText: '',
                              ),
                              textInputAction: TextInputAction.next,
                            ))
                          ],
                        ),
                      ),
                      
                       Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: TextFormField(
                                  maxLines: null,
                                  minLines: 2,
                              validator: (value) {
                               
                                
                              },
                            
                              controller: _addressController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Address',
                                hintText: '',
                              ),
                              textInputAction: TextInputAction.next,
                            ))
                          ],
                        ),
                      ),
                     
                      ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: FlatButton(
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        showWaitingProgress(context);
                                        await WebServices(this.mApiListener)
                                            .updateUser(
                                                _currencyCode,
                                                _emailController.text,
                                                _firstNameController.text,
                                                _lastNameController.text,
                                                _addressController.text,
                                                _receive_notifications)
                                            .then((value) async {
                                          await WebServices(mApiListener)
                                              .getUserData()
                                              .then((value) {
                                            if (value != null) {
                                              currentUserData = value;
                                            }
                                          });
                                          await WebServices(mApiListener)
                                              .convertCurrency(
                                                  'LKR',
                                                  currentUserData['currency'],
                                                  '1')
                                              .then((value) {
                                            if (value != null) {
                                              currencyValue = value;
                                            }
                                          });
                                          print(currencyValue);

                                          Navigator.pop(context);
                                          if (value == 200) {
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Profile Updated Successfully"),
                                              backgroundColor: Colors.green,
                                            ));
                                          } else {
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Something went wrong. Please try again."),
                                              backgroundColor: Colors.red,
                                            ));
                                          }
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Save Profile',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () => {}),
                    ],
                  ),
                )),
            SwitchListTile(
              value: _receive_notifications,
              onChanged: (value) async {
                setState(() {
                  _receive_notifications = value;
                  currentUserData['receive_notification'] = _receive_notifications.toString();

                  print(currentUserData);
                });
                showWaitingProgress(context);
                await WebServices(this.mApiListener)
                    .updateNotificationSetting(currentUserData['receive_notification']);

                Navigator.pop(context);
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Notification Setting updated."),
                  backgroundColor: Colors.green,
                ));
              },
              title: Text('Receive All Notifications'),
              subtitle: Text('I would like to receive all notifications'),
            ),
            Divider(
              height: 0,
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new About();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.admin_panel_settings_sharp),
              title: Text('Privacy Policy'),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new PrivacyPolicy();
                }));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.power_settings_new,
              ),
              title: Text('Sign out'),
              subtitle: SizedBox(height: 2.0, child: _signoutProgress),
              onTap: () async {
                setState(() {
                  _signoutProgress = LinearProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  );
                });
                await FirebaseAuth.instance.signOut().then((action) {
                  // Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Signin()));
                });
              },
            ),
          ],
        ),
      ),
    );
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
