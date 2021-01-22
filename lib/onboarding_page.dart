import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connecting_hearts/constant/Constant.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: onBordingBody(),
    );
  }

  Widget onBordingBody() => Container(
        child: SliderLayoutView(),
      );
}

class SliderLayoutView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliderLayoutViewState();
}

class _SliderLayoutViewState extends State<SliderLayoutView> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) => topSliderLayout();

  Widget topSliderLayout() => Container(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: sliderArrayList.length,
                  itemBuilder: (ctx, i) => SlideItem(i),
                ),
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: <Widget>[
                    Container(
                      alignment: AlignmentDirectional.bottomCenter,
                      margin: EdgeInsets.only(bottom: 100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < sliderArrayList.length; i++)
                            if (i == _currentPage)
                              SlideDots(true)
                            else
                              SlideDots(false)
                        ],
                      ),
                    ),
                    Container(
                      alignment: AlignmentDirectional.bottomCenter,
                      margin: EdgeInsets.only(bottom: 75.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Click to view our'),
                         GestureDetector(
                           child:  Text(
                            ' Privacy Policy',
                            style: TextStyle(
                              decoration: TextDecoration.underline, fontWeight: FontWeight.bold
                            ),
                          ),
                           onTap: (){
                             _privacyPolicy();
                           }
                         ),
                         
                        ],
                      ),
                    ),
                   
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(right: 15.0, bottom: 15.0),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(SIGN_IN);
                          },
                          child: Text('Accept and Continue', style: TextStyle(color:Colors.white),),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color:  Theme.of(context).primaryColor)),
                              color:  Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                 
                  ],
                )
              ],
            )),
      );

       Future _privacyPolicy() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            title: Center(child: Text("Privacy Policy")),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Container(
              height: 300,
              
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                          ListTile(
                            title: Text(
                                '\nPlease read the policy in order to be familiar with the way Connecting Hearts is collecting, using and processing your personal information pertaining to the usage of the Electronic Payment Gateway which is available through Connecting Hearts’s electronic services.'),
                          ),
                          ListTile(
                              title: Text(
                                  'The approval of obtaining your personal information',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600))),
                          ListTile(
                            title: Text(
                                'Once you give an approval to provide Connecting Hearts with your personal information, you agree upon the conditions set forth in this document, and Connecting Hearts may change these conditions from time to time. Connecting Hearts does not collect any information from visitors except for what he or she provides when subscribing, or making a donation.\nConnecting Hearts does not sell, rent or publish personal information provided willingly, except for the continuation of the process of donation initiated.\nConnecting Hearts is committed to ensure the privacy of users of its electronic services, which include all electronic donation points and apps and websites of other projects'),
                          ),
                          ListTile(
                              title: Text('Collecting Personal Information',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600))),
                          ListTile(
                              title: Text(
                            'Connecting Hearts ensures the safety and privacy of users’ personal information, which may use only for the purposes it was collected for. For instance, information might be used to complete donation processes, verify personal information, remind donors of their donation dates, and to notify them of new campaigns in this regard, including information about those who expressed their intention to volunteer at the Charity',
                          )),
                          ListTile(
                              title: Text('Data Security',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600))),
                          ListTile(
                              title: Text(
                            'Connecting Hearts applies a group of data security procedures that ensure the safety, accuracy and updating of data. Connecting Hearts will not sell, rent or disclose your personal information with a third party.\n',
                          )),
                        ],
                      
                ),
              ),
            ),
             actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                 
                Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(right: 100.0,),
                        child: RaisedButton(
                        child: new Text(
                          'Close',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Color(0xFF121A21),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ),
                    ),
                 
                ],
              )
            ]);
      },
    );
  }
}

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(sliderArrayList[index].sliderImageUrl))),
        ),
        SizedBox(
          height: 60.0,
        ),
        Text(
          sliderArrayList[index].sliderHeading,
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            fontSize: 20.5,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              sliderArrayList[index].sliderSubHeading,
              style: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                fontSize: 12.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}

class Slider {
  final String sliderImageUrl;
  final String sliderHeading;
  final String sliderSubHeading;

  Slider(
      {@required this.sliderImageUrl,
      @required this.sliderHeading,
      @required this.sliderSubHeading});
}

final sliderArrayList = [
  Slider(
      sliderImageUrl: 'assets/slider_1.png',
      sliderHeading: "Get notified with recent updates.",
      sliderSubHeading:
          "Keep in touch with us by notifications on recent sermon updates, events organized"),
  Slider(
      sliderImageUrl: 'assets/slider_2.png',
      sliderHeading: "Find needy people",
      sliderSubHeading:
          "You may not aware of how people are needy. This is the platform for you"),
  Slider(
      sliderImageUrl: 'assets/slider_3.png',
      sliderHeading: "Support them",
      sliderSubHeading:
          "We connect needy people and donors and make a network"),
];

class SlideDots extends StatelessWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3.3),
      height: isActive ? 10 : 6,
      width: isActive ? 10 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        border: isActive
            ? Border.all(
                color: Color(0xff927DFF),
                width: 2.0,
              )
            : Border.all(
                color: Colors.transparent,
                width: 1,
              ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
