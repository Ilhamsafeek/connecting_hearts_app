import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:connecting_hearts/constant/Constant.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:connecting_hearts/ui/screens/tabElements/dashboardContent/echarity/project_detail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Project extends StatefulWidget {
  final dynamic categoryData;

  Project(this.categoryData, {Key key}) : super(key: key);
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<Project> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.categoryData['category'],
              style: TextStyle(fontFamily: "Exo2", color: Colors.white)),
          actions: <Widget>[
            CachedNetworkImage(
              imageUrl: widget.categoryData['photo'],
              placeholder: (context, url) => Image.asset(
                'assets/placeholder.png',
                width: 30,
              ),
              width: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Center(
            child: new RefreshIndicator(
          child: SingleChildScrollView(child: Container(child: buildData())),
          onRefresh: _handleRefresh,
        )));
  }

  Widget buildData() {
    return FutureBuilder<dynamic>(
      future: WebServices(this.mApiListener)
          .getProjectData(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          var data = snapshot.data
              .where((el) =>
                  el['project_category_id'] ==
                      this.widget.categoryData['project_category_id'] &&
                  el['amount'] != el['collected'])
              .toList();
          if (data.length > 0) {
            children = <Widget>[
              for (var item in data) projectCard(item),
            ];
          } else {
            children = <Widget>[
              ListTile(
                title: Center(
                  child: Text(
                      "There are no projects available under this category at the moment",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ),
              ),
            ];
          }
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('something Went Wrong !'), //Error: ${snapshot.error}
            )
          ];
        } else {
          children = <Widget>[
            SizedBox(
              child: SpinKitPulse(
                color: Colors.grey,
                size: 120.0,
              ),
              width: 50,
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(''),
            )
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
    );
  
  }

  Card projectCard(dynamic data) {
    FlutterMoneyFormatter formattedAmount = FlutterMoneyFormatter(
        amount:
            double.parse('${data['amount']}') * double.parse('$currencyValue'));

    double completedPercent = 100 *
        double.parse('${data['collected']}') /
        double.parse('${data['amount']}');
    Color completedColor = Colors.blue;
    Color percentColor = Colors.white;
    if (completedPercent >= 100) {
      completedPercent = 100.0;
      completedColor = Colors.orange;
    }

    double percent = completedPercent / 100;
    return Card(
        child: GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(children: <Widget>[
            ClipRRect(
              // borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
              child: CachedNetworkImage(
                imageUrl: data['featured_image'],
                placeholder: (context, url) =>
                    Image.asset('assets/placeholder.png'),
              ),
            ),
            // Container(
            //   height: MediaQuery.of(context).size.width * 0.58,
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: [
            //         const Color(0xCC000000),
            //         const Color(0x00000000),
            //         const Color(0x00000000),
            //         const Color(0xCC000000),
            //       ],
            //     ),
            //   ),
            // ),
            Container(
                child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    '${data['short_description']}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    '${data['city']}, ${data['district']}',
                    style: TextStyle(
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  trailing: Chip(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    backgroundColor: Colors.amber,
                    avatar: Icon(
                      Icons.star_border,
                      color: Colors.white,
                    ),
                    label: Text(
                      "${data['rating']}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            )),

            Positioned(
              bottom: 40,
              left: 5,
              child: Column(
                children: <Widget>[
                  Chip(
                      label: Text(
                          "Donation Amount: ${currentUserData['currency']} " +
                              "${formattedAmount.output.nonSymbol}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.transparent),
                ],
              ),
            ),

            Positioned(
              bottom: 5,
              left: 5,
              child: Column(
                children: <Widget>[
                  new LinearPercentIndicator(
                    leading: Chip(
                      label: Text(
                        "Donation Received :",
                        style: TextStyle(
                          fontFamily: "Exo2",
                          // color: Colors.white,
                          fontWeight: FontWeight.bold,
                          // fontSize: 16.0,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    alignment: MainAxisAlignment.start,
                    animation: true,
                    lineHeight: 14.0,
                    animationDuration: 2000,
                    width: 150.0,
                    percent: percent,
                    center: Text(
                      "${double.parse(completedPercent.toStringAsFixed(2))}%",
                      style: new TextStyle(fontSize: 12.0, color: percentColor),
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    backgroundColor: Colors.grey,
                    progressColor: completedColor,
                  ),
                ],
              ),
            ),
          ]),
          Container(
              child: Row(children: <Widget>[
            Expanded(
              child: FlatButton.icon(
                icon: Icon(
                  Icons.list,
                  color: Colors.green,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProjectDetail(data)),
                  );
                },
                label: Text('View more'),
              ),
            ),
            if (data['zakat_eligible'] == 'true')
              Expanded(
                child: Column(
                  children: <Widget>[
                    FlatButton.icon(
                        icon: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        label: Text(
                          'Zakat Eligible',
                          style: TextStyle(
                              color: Colors.green[400],
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {}),
                  ],
                ),
              ),
          
          ]))
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProjectDetail(data)),
        );
      },
    ));
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }
}
