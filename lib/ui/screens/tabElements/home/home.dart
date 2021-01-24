import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:connecting_hearts/constant/Constant.dart';
import 'package:connecting_hearts/model/Gridmodel.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:connecting_hearts/ui/screens/tabElements/home/dashboardContent/echarity/echarity.dart';
import 'package:connecting_hearts/ui/screens/media/update_detail.dart';
import 'dart:async';

import '../dashboardContent/donate_points.dart';
import 'dashboardContent/updates/media.dart';
import 'dashboardContent/details/categories.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

Future<dynamic> _zamzamUpdates;

class _HomeState extends State<Home> {
  ApiListener mApiListener;
  dynamic completedProjectData = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WebServices(this.mApiListener).getCompletedProjectData().then((data) {
      setState(() {
        // completed last 10 projects
        completedProjectData = data;
      });
    });

    _zamzamUpdates = WebServices(this.mApiListener).getZamzamUpdateData();
    WebServices(mApiListener)
        .convertCurrency('LKR', currentUserData['currency'], '1')
        .then((value) {
      if (value != null) {
        currencyValue = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey[200],
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.center,
                      child: Container(
                          child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child:
                                _zamzamUpdatesSlider(), //Error: ${snapshot.error}
                          ),

                          _dashboardGrid(),
                          SizedBox(
                            height: 2,
                          ),
                          ListTile(
                              contentPadding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * .03,
                                right: MediaQuery.of(context).size.width * .03,
                              ),
                              leading: Icon(Icons.star),
                              title: Center(
                                child: Text(
                                  "Our Success Stories",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              trailing: Icon(Icons.star),
                              tileColor: Color.fromRGBO(80, 172, 225, 1)),
                          //              FutureBuilder<dynamic>(
                          //   future: WebServices(this.mApiListener)
                          //       .getProjectData(), // a previously-obtained Future<String> or null
                          //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          //     List<Widget> children;

                          //     if (snapshot.hasData) {
                          //       var data = snapshot.data
                          //           .where((el) =>

                          //               el['amount'] != el['collected'])
                          //           .toList();

                          //       children = <Widget>[
                          //         for (var item in data) projectCard(item),
                          //       ];
                          //     } else if (snapshot.hasError) {
                          //       children = <Widget>[
                          //         Icon(
                          //           Icons.error_outline,
                          //           color: Colors.red,
                          //           size: 60,
                          //         ),
                          //         Padding(
                          //           padding: const EdgeInsets.only(top: 16),
                          //           child: Text('something Went Wrong !'), //Error: ${snapshot.error}
                          //         )
                          //       ];
                          //     } else {
                          //       children = <Widget>[
                          //         SizedBox(
                          //           child: SpinKitPulse(
                          //             color: Colors.grey,
                          //             size: 120.0,
                          //           ),
                          //           width: 50,
                          //           height: 50,
                          //         ),
                          //         const Padding(
                          //           padding: EdgeInsets.only(top: 16),
                          //           child: Text(''),
                          //         )
                          //       ];
                          //     }
                          //     return Center(
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         children: children,
                          //       ),
                          //     );
                          //   },
                          // )
                        ],
                      ))),
                  if (completedProjectData.length > 0)
                    for (var item in completedProjectData)
                      _buildProjectList(item)
                ],
              ),
            )));
  }

  // List<dynamic> _getImageSliderList(data) {
  //   List<dynamic> list = new List();
  //   for (var item in data) {
  //     list.add(new ImageSliderModel(item['image_url'], item['tag_line']));
  //   }

  //   return list;
  // }

  carouselSliderList(List<dynamic> imageSliderList) {
    return imageSliderList.map((item) {
      return Builder(builder: (BuildContext context) {
        return imageSliderItem(item);
      });
    }).toList();
  }

  Widget imageSliderItem(dynamic item) {
    return Container(
      child: InkWell(
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: item['image_url'],
              placeholder: (context, url) =>
                  Image.asset('assets/placeholder.png'),
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 50,
                  color: const Color(0xFF0E3311).withOpacity(0.5),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ListTile(
                    title: Center(
                        child: Text("${item['tag_line']}",
                            style: TextStyle(color: Colors.white))))
              ],
            )
          ],
        ),
        onTap: () {
          Navigator.of(context)
              .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
            return new UpdateDetail(item);
          }));
        },
      ),
    );
  }

  Widget _dashboardGrid() {
    return GridView.count(
      padding: const EdgeInsets.all(3),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: <Widget>[
          InkWell(
              child: GridItem(
                  GridModel('assets/help-a-nest.png', 'Help a Nest', null)),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  var featuredImage = 'assets/help-a-nest.png';
                  var overview =
                      '\n“Help a Nest” project primarily focuses on fulfilling housing & shelter needs of communities through both restricted “Zakath” charity donations and other donations by Sri Lankan Muslim community. A significant percentage of the funds are allocated to provide shelter for needy families from other ethnic and religious communities as a conscious effort to build interfaith harmony and to serve humanity\n';
                  var secondTitle = '';
                  var secondOverview = '';
                  var hadeeth = '';
                  var milestoneImage = '';
                  var packContent = [];
                  dynamic thumbnailImages = [
                    'assets/han01.png',
                    'assets/han02.png',
                    'assets/han03.png',
                    'assets/han04.png'
                  ];
                  return new Categories(
                      featuredImage,
                      'Help a Nest',
                      overview,
                      thumbnailImages,
                      secondTitle,
                      secondOverview,
                      hadeeth,
                      milestoneImage,
                      packContent);
                }));
              }),
          InkWell(
              child: GridItem(
                  GridModel('assets/feed-a-family.png', 'Feed a Family', null)),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  var featuredImage = 'assets/feed-a-family.png';
                  var overview =
                      '\n“Feed a Family” is an annual project carried out by Zam Zam Foundation since 2014 to provide with food provisions to support needy families across Sri Lanka, in the holy month of Ramadan. So far the project has supported more than to 40,000 families in many districts in Sri Lanka by easing their burden during Ramadan. An extra effort is made to share the spirit of charity and goodwill in the month of Ramadhan, with other faith communities as well by giving such Food Provisions totaling 30KG, to needy families in multi-ethnic localities.\n';
                  var secondTitle =
                      'An opportunity to share the joy of Ramadhan';
                  var secondOverview =
                      'Ramadhan is a month, which we await every year, to multiply our good deeds through charity and by assisting the needy.\n\n “Feed a Family” Project by Zam Zam Foundation is carried out annually with the objective of assisting our donors to Obtain rewards and satisfaction during the holy month of Ramadhan with by contributing towards feeding a needy family Prophet Muhammed (peace be upon him) has encouraged us to give as much as possible in Charity. It is said that amongst the deeds that are most beloved to Almighty Allah, are feeding the poor and taking care of the orphans.';
                  var hadeeth = [
                    '"Have you seen him who denies the Requital? So he is the one who pushes away the ophan, and does not persuade (others) to feed the needy."',
                    'Holy Quran - Surah Al Ma un:verse 1-3'
                  ];
                  var milestoneImage = 'assets/faf_milestone.png';
                  var packContent = [
                    'Samba Rice - 10 kg\nFlour - 05 kg\nSugar - 03 kg\nMilk Powder - 01 kg\nTea Leaves - 500g\n',
                    'Dhal - 02 kg\nDrink Powder - 01 kg\nCooking Oil Can\nDates - 01 kg\nTin Fish – 06\n'
                  ];

                  dynamic thumbnailImages = [
                    'assets/faf01.png',
                    'assets/faf02.png',
                    'assets/faf03.png',
                    'assets/faf04.png'
                  ];
                  return new Categories(
                      featuredImage,
                      'Feed a Family',
                      overview,
                      thumbnailImages,
                      secondTitle,
                      secondOverview,
                      hadeeth,
                      milestoneImage,
                      packContent);
                }));
              }),
          InkWell(
              child: GridItem(GridModel('assets/school-with-a-smile.png',
                  'SWS', null)),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  var featuredImage = 'assets/school-with-a-smile.png';
                  var overview =
                      '\n“School with a Smile” is our flagship project which has so far helped over 60,000 students with a complete pack of school supplies including shoes, school bag, exercise books & stationary being distributed via temples, mosques, churches and other community centres. Beneficiary students are selected through school principals and education authorities with the objective of helping the needy students in order to minimize school drop-outs and to ensure the financial burden of the parents is reduced so the savings can be used for betterment of their quality of life.\n';
                  var secondTitle =
                      'Let\'s Making A Difference Through Education';
                  var secondOverview =
                      '\n"School with a Smile" project by Zam Zam Foundation has, for the last 5 years, provided assistance to more than 56,000 needy students across Sri Lanka.\nThis project supports continuous education of students from low-income families by helping parents to reduce their financial burden in educating their children. And this allows students to continue their education without dropping out of school due to poverty.\nEach "Student\'s Pack" consists of a high-quality school bag, exercise books, stationery items and a (Rs. 1,000) shoe voucher, totally worth over Rs. 3,000. This project is carried out with virtually 100% contribution from Muslims living in Sri Lanka and abroad, while the beneficiaries are from all religious and ethnic backgrounds in the country. This project also gives hopes to Sri Lankans in building national unity and reconciliation, through a feeling of caring for each other\n';
                  var hadeeth = '';
                  var milestoneImage = 'assets/swas_milestone.png';
                  var packContent = [
                    'High Quality School Bag\n10 x 120P Single Rule Books\n02 x 80P CR Books\n10 x Pencils\n01 x 12 Color Pencil Set\n01 x Pencil Box\n01 x Scissor\n',
                    'Rs: 1,000/- Shoe Voucher\n02 x 120P Squre Rule Books\n01 x 40P Drawing Books\n04 x Pens\n06 x Erasers\n01 x Glue Stick\n01 x Ruler\n'
                  ];
                  dynamic thumbnailImages = [
                    'assets/swas01.png',
                    'assets/swas02.png',
                    'assets/swas03.png',
                    'assets/swas04.png'
                  ];
                  return new Categories(
                      featuredImage,
                      'School With a Smile',
                      overview,
                      thumbnailImages,
                      secondTitle,
                      secondOverview,
                      hadeeth,
                      milestoneImage,
                      packContent);
                }));
              }),
          InkWell(
              child: GridItem(GridModel(
                  'assets/healthy-society.png', 'Healthy Society', null)),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  var featuredImage = 'assets/healthy-society.png';
                  var overview =
                      '\n“Healthy Society” is an initiative which focuses on building interfaith and inter-community relationships in mixed ethnic neighborhoods and villages by facilitating partnerships within communities to work towards finding solutions for common needs of the village. Projects include building water tanks for safe drinking water, renovation of common facilities in rural hospitals, assisting with infrastructure needs of schools where children from multiple faith and ethnic groups study together, etc. the sustainability of the projects are managed by local committees comprising community and religious leaders from diverse backgrounds\n';
                  var secondTitle = '';
                  var secondOverview = '';
                  var hadeeth = '';
                  var milestoneImage = '';
                  var packContent = [];
                  dynamic thumbnailImages = [
                    'assets/healthy01.png',
                    'assets/healthy02.png',
                    'assets/healthy03.png',
                    'assets/healthy04.png'
                  ];
                  return new Categories(
                      featuredImage,
                      'Healthy Society',
                      overview,
                      thumbnailImages,
                      secondTitle,
                      secondOverview,
                      hadeeth,
                      milestoneImage,
                      packContent);
                }));
              }),
          InkWell(
              child:
                  GridItem(GridModel('assets/sankalpa.png', 'Academy', null)),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  var featuredImage = 'assets/sankalpa.png';
                  var overview =
                      '\nThe Course on Contemporary Affairs, Cultures and Communication in Sinhala for Islamic Scholars is a unique 1-year residential course conducted through a theological education institute (Fath Academy) affiliated to Zam Zam Foundation, for Islamic Scholars selected through an open call for applications and an interview process, is currently underway with 20 participants in the first batch. The course is expected to be continued on an annual basis and a new batch is expected to be commencing by September 2019 as the 2nd batch of another 20 participant Islamic Scholars.\n\n\nThis course objective is to create and nurture Islamic Scholars / Imams who are able to responsibly guide the Muslim community in Sri Lanka and specially the youth with a very broadminded manner to counter challenges of radicalization and social alienation, while building interfaith relationships and bridging the divide between communities by clarifying doubts, eliminating suspicions and giving positive leadership by being able to communicate in a relatable manner in Sinhala Language\n';
                  var secondTitle = '';
                  var secondOverview = '';
                  var hadeeth = '';
                  var milestoneImage = '';
                  var packContent = [];
                  dynamic thumbnailImages = [
                    'assets/sankalpa01.png',
                    'assets/sankalpa02.png',
                    'assets/sankalpa03.png',
                    'assets/sankalpa04.png'
                  ];
                  return new Categories(
                      featuredImage,
                      'Sankalpa',
                      overview,
                      thumbnailImages,
                      secondTitle,
                      secondOverview,
                      hadeeth,
                      milestoneImage,
                      packContent);
                }));
              }),
          InkWell(
              child: GridItem(
                  GridModel('assets/zamzam_updates.png', 'Updates', null)),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new Media();
                }));
              }),
          InkWell(
              child:
                  GridItem(GridModel('assets/e-charity.png', 'eCharity', null)),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new Charity();
                }));
              }),
          InkWell(
              child: GridItem(
                  GridModel('assets/shop-icon.png', 'Charity Shop', null)),
              onTap: () {
                // Navigator.of(context).push(
                //     CupertinoPageRoute<Null>(builder: (BuildContext context) {
                //   return new Money();
                // }));
              }),
          InkWell(
              child: GridItem(
                  GridModel('assets/donate_points.png', 'Donate Points', null)),
              onTap: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new DonatePoints();
                }));
              }),
        ]);
  }

  Widget _dashboardPanel(dynamic image, dynamic title) {
    return Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Image.asset(
        image,
        width: 65,
      ),
      Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.2, color: Colors.black),
        ),
      ),
    ]));
  }

  // Widget _gridView() {
  //   return GridView.builder(
  //     itemCount: 250,
  //     gridDelegate:
  //         const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
  //     itemBuilder: (BuildContext context, int index) => CachedNetworkImage(
  //       imageUrl: 'https://loremflickr.com/100/100/music?lock=$index',
  //     ),
  //   );
  // }

  Widget _zamzamUpdatesSlider() {
    return FutureBuilder<dynamic>(
        future: _zamzamUpdates,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          List<Widget> children;
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              dynamic data = snapshot.data
                  .where((el) => el['status'] == 'active')
                  .toList();
              children = <Widget>[
                CarouselSlider(
                  // pauseAutoPlayOnTouch: Duration(seconds: 4),

                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                    initialPage: 0,
                    autoPlayInterval: Duration(seconds: 4),
                    autoPlayAnimationDuration: Duration(milliseconds: 1000),
                    enlargeCenterPage: true,
                    autoPlay: true,
                  ),
                  items: carouselSliderList(data),
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
                  child:
                      Text('something Went Wrong !'), //Error: ${snapshot.error}
                )
              ];
            }
          } else {
            children = <Widget>[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset('assets/placeholder.png'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        });
  }

  // ignore: missing_return
  Widget _buildProjectList(item) {
    var formattedAmount = FlutterMoneyFormatter(
            amount: double.parse('${item['amount']}') *
                double.parse('$currencyValue'))
        .output
        .nonSymbol;
    return Card(
      child: GestureDetector(
        child: Column(
          children: <Widget>[
            Stack(children: <Widget>[
              CachedNetworkImage(
                imageUrl: item['featured_image'],
                placeholder: (context, url) =>
                    Image.asset('assets/placeholder.png'),
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 2,
                left: 4,
                child: Column(
                  children: <Widget>[
                    Text(
                      "${item['completed_date']}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 2,
                left: 4,
                right: 4,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "${item['city']}, ${item['district']}",
                        style: TextStyle(
                          fontSize: 16,
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
                    ),
                  ],
                ),
              ),
            ]),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text("${item['short_description']}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                          "${currentUserData['currency']}. $formattedAmount"),
                    ),
                  ]),
                )),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      FlatButton.icon(
                          icon: Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          label: Text(
                            'Completed',
                            style: TextStyle(
                                color: Colors.green[400],
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Card projectCard(dynamic data) {
    FlutterMoneyFormatter formattedAmount = FlutterMoneyFormatter(
        amount:
            double.parse('${data['amount']}') * double.parse('$currencyValue'));

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
                ),
              ],
            )),
            Positioned(
              bottom: 5,
              left: 5,
              child: Column(
                children: <Widget>[
                  Chip(
                      label: Text(
                          'Donation Amount: Rs.' +
                              '${formattedAmount.output.nonSymbol}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.transparent),
                ],
              ),
            ),
          ]),
        ],
      ),
      onTap: () {},
    ));
  }
}

class GridItem extends StatelessWidget {
  GridModel gridModel;

  GridItem(this.gridModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7.0),
          child: Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    gridModel.imagePath,
                    width: 60,
                    height: 60,
                    color: gridModel.color,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      gridModel.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
