import 'package:cached_network_image/cached_network_image.dart';
import 'package:connecting_hearts/constant/Constant.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';



class SuccessStories extends StatefulWidget {
  @override
  _SuccessStoriesState createState() => _SuccessStoriesState();

  SuccessStories({Key key}) : super(key: key);
}

class _SuccessStoriesState extends State<SuccessStories> {
    dynamic completedProjectData = [];
  ApiListener mApiListener;

  @override
  void initState() {
    super.initState();
     WebServices(this.mApiListener).getCompletedProjectData().then((data) {
      setState(() {
        // completed last 10 projects
        completedProjectData = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Success Stories',
                style: TextStyle(
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.0, 0.0),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                  ],
                ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
       if (completedProjectData.length > 0)
                    for (var item in completedProjectData)
                      _buildProjectList(item)
      ],
    );
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


}
