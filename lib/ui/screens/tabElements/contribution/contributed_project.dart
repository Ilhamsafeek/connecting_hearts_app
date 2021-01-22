import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connecting_hearts/constant/Constant.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:connecting_hearts/utils/read_more_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:connecting_hearts/ui/screens/tabElements/chat/chat_detail.dart';
import 'package:connecting_hearts/utils/dialogs.dart';

import '../../../../miscellaneous/image_picker.dart';

class ContributedProject extends StatefulWidget {
  @override
  _ContributedProjectState createState() => _ContributedProjectState();

  final dynamic projectData;

  ContributedProject(this.projectData, {Key key}) : super(key: key);
}

class _ContributedProjectState extends State<ContributedProject> {
  Future _projectImages;
  @override
  void initState() {
    _projectImages = WebServices(this.mApiListener)
        .getImageFromFolder(widget.projectData['project_supportives'],'project_supportives');
    super.initState();
  }

  String selectedMethod;
  dynamic paymentAmount;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  selectsku(method) {
    print(method);
    setState(() {
      selectedMethod = method;
    });
  }

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
                      offset: Offset(0, 0),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              background: CachedNetworkImage(
                imageUrl: widget.projectData['featured_image'],
                fit: BoxFit.cover,
              ),
            ),
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
    var paymentTypeExtension = "";
    var months = '${widget.projectData['months']}';
    if (widget.projectData['type'] == 'recursive') {
      paymentTypeExtension = 'in $months months';
    } else {}

    FlutterMoneyFormatter formattedAmount = FlutterMoneyFormatter(
        amount: double.parse('${widget.projectData['amount']}')*double.parse('$currencyValue'));
    FlutterMoneyFormatter formattedPaid = FlutterMoneyFormatter(
        amount: double.parse('${widget.projectData['paid_amount']}')*double.parse('$currencyValue'));
    FlutterMoneyFormatter formattedRaised = FlutterMoneyFormatter(
        amount: double.parse('${widget.projectData['collected']}')*double.parse('$currencyValue'));

    double remainingAmount = double.parse('${widget.projectData['amount']}') -
        double.parse('${widget.projectData['collected']}');
    FlutterMoneyFormatter formattedRemainingAmount =
        FlutterMoneyFormatter(amount: remainingAmount*double.parse('$currencyValue'));
        FlutterMoneyFormatter formattedIncome;
    if (widget.projectData['appeal_type'] == "Individual") {
       formattedIncome = FlutterMoneyFormatter(
          amount: double.parse('${widget.projectData['income']}')*double.parse('$currencyValue'));
    }
    // double completedPercent = 100 *
    //     double.parse('${widget.projectData['collected']}') /
    //     double.parse('${widget.projectData['amount']}');
    Color completedColor = Colors.blue;
    Color percentColor = Colors.white;
    // if (completedPercent >= 100) {
    //   completedPercent = 100.0;
    //   completedColor = Colors.orange;
    // }
    String projectStatus='Open';
    Color status_color=Colors.orange;
    if(double.parse('${widget.projectData['collected']}')-double.parse('${widget.projectData['amount']}')==0){
        projectStatus='In Progress';  
        status_color=Colors.blue;  
        }else if(widget.projectData['completed_percentage']=='100'){
projectStatus='Completed'; 
status_color=Colors.green; 
        }
    
    // double percent = completedPercent / 100;

    Widget _trailing = Text("Success");
    Icon _statusIcon = Icon(
      Icons.check_circle,
      color: Colors.green,
    );

    dynamic _text = "You have donated. Now you can monitor the project status.";
    if (widget.projectData['status'] == 'pending' &&
        (widget.projectData['method'] == 'bank'||widget.projectData['method'] == 'direct debit')) {
      if (widget.projectData['slip_url'] == "") {
        _trailing = RaisedButton(
          color: Colors.red,
          onPressed: () async {
           
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => PickImage(
                    "${widget.projectData['payment_id']}",
                    
                  ),
                ));
          },
          child: Text(
            'Submit Deposit Slip',
            style: TextStyle(color: Colors.white),
          ),
        );

        _statusIcon = Icon(
          Icons.info_outline,
          color: Colors.orange,
        );
        _text =
            "You have donated. Please submit your bank slip to be effective";
      } else {
        _trailing = Column(children: <Widget>[
          //  CircleAvatar(child: Icon(Icons.insert_emoticon)),
          FlatButton.icon(
            icon: Icon(Icons.edit),
            onPressed: () async {
              // WidgetsFlutterBinding.ensureInitialized();
              // final cameras = await availableCameras();
              // final firstCamera = cameras.first;
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (BuildContext context) => TakePictureScreen(
              //         "${widget.projectData['payment_id']}",
              //         firstCamera,
              //       ),
              //     ));
            },
            label: Text('Edit Slip'),
          ),
        ]);
        _statusIcon = Icon(
          Icons.schedule,
          color: Colors.blue,
        );
        _text =
            "You have submitted slip for your donation. your deposit slip is under review.";
      }
    }

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
                      title: Text(
                          "Name: ${widget.projectData['name']}\nLocation: ${widget.projectData['city']},${widget.projectData['district']}"),
                    )
            ],
          ),
        ),
       
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
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
              FlatButton.icon(
                onPressed: () async {
                  print(
                      "User data========>>>${widget.projectData['manager_id']}");
                  dynamic chatId = '0';
                  dynamic topic =
                      '${widget.projectData['appeal_id']} - ${widget.projectData['sub_category']}';
                  showWaitingProgress(context);
                  await WebServices(mApiListener).getChatTopics().then((value) {
                    if (value != null) {
                      dynamic result;
                      if (value.length != 0) {
                        result =
                            value.where((el) => el['topic'] == topic).toList();
                        if (result.length != 0) {
                          print('${result[0]['chat_id']}');
                          chatId = result[0]['chat_id'];
                        }
                      }
                    }
                  });
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      CupertinoPageRoute<Null>(builder: (BuildContext context) {
                    return new ChatDetail(
                        topic, chatId, widget.projectData['manager_id']);
                  }));
                },
                icon: Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                label: Text(
                  'Contact project manager',
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Theme.of(context).primaryColor)),
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              ListTile(
                  title: Text(
                    "My contribution",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  tileColor: Color.fromRGBO(80, 172, 225, 1)),
              Divider(height: 0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RichText(
                          text: new TextSpan(
                            style: new TextStyle(
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              new TextSpan(
                                  text: 'Contributed Date: ',
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold)),
                              new TextSpan(
                                  text: widget.projectData['date_time']),
                            ],
                          ),
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
                        Icon(
                          Icons.reply,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Transfer Method:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        widget.projectData['method'] == 'card'
                            ? FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.credit_card),
                                label: Text('${widget.projectData['method']}'))
                            : FlatButton.icon(
                                onPressed: null,
                                icon: Icon(Icons.local_atm),
                                label: Text('${widget.projectData['method']}')),
                      ],
                    ),
                    
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                         Icon(FontAwesomeIcons.moneyBill,size: 15,),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'My Commitment:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('${currentUserData['currency']} ${formattedPaid.output.nonSymbol}',
                            style: TextStyle(color: Colors.red, fontSize: 15.0))
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
                        Icon(
                          Icons.timelapse,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Donation Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        _trailing,
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            infoModalBottomSheet(context, _statusIcon, _text);
                          },
                          child: _statusIcon,
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
                        Icon(
                          Icons.receipt,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          child: Text(
                            'View Donation Receipt',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          onTap: () {
                            _launchURL(widget.projectData['receipt_url']);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        
        // Card(
        //   color: Colors.cyan[50],
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: <Widget>[
        //       SizedBox(
        //         height: 10,
        //       ),
        //       Text(
        //         "Project Updates",
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       ),
        //       Divider(height: 0),
        //       Padding(
        //         padding: const EdgeInsets.symmetric(
        //           vertical: 5,
        //         ),
        //         child: Column(
        //           children: <Widget>[
        //             RichText(
        //               text: new TextSpan(
        //                 style: new TextStyle(
        //                   color: Colors.black,
        //                 ),
        //                 children: <TextSpan>[
        //                   new TextSpan(
        //                       text: 'Rs.',
        //                       style:
        //                           new TextStyle(fontWeight: FontWeight.w600)),
        //                   new TextSpan(
        //                       text:
        //                           '${formattedAmount.output.withoutFractionDigits}',
        //                       style: TextStyle(fontSize: 32)),
        //                 ],
        //               ),
        //             ),
        //             new LinearPercentIndicator(
        //               alignment: MainAxisAlignment.center,
        //               animation: true,
        //               lineHeight: 14.0,
        //               animationDuration: 2000,
        //               width: 140.0,
        //               percent: percent,
        //               center: Text(
        //                 "${double.parse(completedPercent.toStringAsFixed(2))}%",
        //                 style:
        //                     new TextStyle(fontSize: 12.0, color: percentColor),
        //               ),
        //               linearStrokeCap: LinearStrokeCap.roundAll,
        //               backgroundColor: Colors.grey,
        //               progressColor: completedColor,
        //             ),
        //             SizedBox(
        //               height: 15,
        //             ),
        //             Row(
        //               children: <Widget>[
        //                 Icon(Icons.donut_small),
        //                 SizedBox(
        //                   width: 10,
        //                 ),
        //                 Text(
        //                   "Project Execution stage: ",
        //                   style: TextStyle(fontWeight: FontWeight.bold),
        //                 ),
        //                 Text(
        //                   "${widget.projectData['completed_percentage']} %",
        //                   style: TextStyle(color: Colors.red),
        //                 )
        //               ],
        //             )
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 70),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      new Text('Total ${currentUserData['currency']}', style: TextStyle(fontSize: 20)),
                      new Text('Raised ${currentUserData['currency']}', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  flex: 6,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      new Text(
                          '${formattedAmount.output.nonSymbol}',
                          style: TextStyle(fontSize: 24)),
                      new Text(
                          '${formattedRaised.output.nonSymbol}',
                          style: TextStyle(fontSize: 24)),
                    ],
                  ),
                  flex: 6,
                ),
              ],
            )),

        Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 70),
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
                          new Text(
                              '${formattedRemainingAmount.output.nonSymbol}',
                              style: TextStyle(fontSize: 24)),
                        ],
                      ),
                      flex: 6,
                    ),
                  ],
                ),
              ),
           

        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

               Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.timelapse,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Project Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          projectStatus,
                          style: TextStyle(fontWeight: FontWeight.bold, color: status_color),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                         Positioned(
              bottom: 5,
              left: 5,
              child: Column(
                children: <Widget>[
                  new LinearPercentIndicator(                   
                    alignment: MainAxisAlignment.start,
                    animation: true,
                    lineHeight: 14.0,
                    animationDuration: 2000,
                    width: 100.0,
                    percent: double.parse('${widget.projectData['completed_percentage']}')/100,
                    center: Text(
                      "${widget.projectData['completed_percentage']} %",
                      style: new TextStyle(fontSize: 12.0, color: percentColor),
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    backgroundColor: Colors.grey,
                    progressColor: completedColor,
                  ),
                
                ],
              ),
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
                        Icon(FontAwesomeIcons.fileImage),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Project Images: ',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 0),
              FutureBuilder<dynamic>(
                future: _projectImages,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  List<Widget> children;

                  if (snapshot.hasData) {
                    dynamic data = snapshot.data;
                   
                    children = <Widget>[
                      for (var item in data)
                      if(lookupMimeType(item).startsWith("image/"))
                        CachedNetworkImage(
                          imageUrl: item,
                          placeholder: (context, url) =>
                              Image.asset('assets/placeholder.png'),
                        ),
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                            'something Went Wrong !'), //Error: ${snapshot.error}
                      )
                    ];
                  } else {
                    children = <Widget>[
                      Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 16 / 10,
                                child: Container(color: Colors.black),
                              ),
                            ],
                          )))
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
              ),
            
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> infoModalBottomSheet(context, icon, text) {
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
                        title: Text('What does it means?'),
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
                    leading: icon,
                    title: Text(text),
                  ),
                ],
              ),
            );
          });
        });
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("You will be notified when we prepared your receipt."),
      ));
    }
  }
}
