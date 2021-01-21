import 'package:braintree_payment/braintree_payment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connecting_hearts/services/braintree.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:connecting_hearts/ui/screens/tabElements/home/dashboardContent/echarity/payment_result.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share/share.dart';
import 'package:connecting_hearts/ui/screens/tabElements/home/dashboardContent/echarity/echarity.dart';
import 'package:connecting_hearts/utils/read_more_text.dart';
import 'package:connecting_hearts/utils/dialogs.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();

  final dynamic photo;
  final dynamic category;
  final dynamic description;
  final dynamic thumbnailImages;
  final dynamic secondTitle;
  final dynamic secondOverview;
  final dynamic hadeeth;
  final dynamic milestoneImage;
  final dynamic packContent;


  Categories(this.photo, this.category, this.description, this.thumbnailImages,
      this.secondTitle, this.secondOverview, this.hadeeth, this.milestoneImage,this.packContent,
      {Key key})
      : super(key: key);
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                '${widget.category}',
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
              background: Image.asset(
                '${widget.photo}',
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(child: _dashboardGrid())),
                );
              },
              childCount: 1,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(child: _secondDetail())),
                );
              },
              childCount: 1,
            ),
          ),
        ]));
  }

  Widget _dashboardGrid() {
    return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: (16 / 10.95),
        children: <Widget>[
          for (var image in widget.thumbnailImages)
            InkWell(
                child: Card(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      Image.asset(image, fit: BoxFit.fill)
                    ])),
                onTap: () {}),
        ]);
  }

  Widget _detailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
            title: Text(
              "Project Overview",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            trailing: FlatButton.icon(
              color: Colors.amber,
              onPressed: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<Null>(builder: (BuildContext context) {
                  return new Charity();
                }));
              },
              icon: Icon(
                Icons.touch_app,
                color: Colors.black,
              ),
              label: Text(
                'Donate Now',
                style: TextStyle(color: Colors.black),
              ),
            ),
            tileColor: Color.fromRGBO(80, 172, 225, 1)),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text("${widget.description}"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _secondDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if(widget.secondTitle!='')
          ListTile(
            contentPadding: EdgeInsets.all(30),
            title: Text(
              "${widget.secondTitle}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 28),
            ),
            tileColor: Theme.of(context).primaryColor),
        if (widget.hadeeth.length > 0 || widget.secondOverview!='')
            Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if(widget.secondOverview!='')
              ListTile(
                title: Text("${widget.secondOverview}"),
              ),
               if(widget.hadeeth.length > 0)
                ListTile(
                    contentPadding: EdgeInsets.all(30),
                    title: Text(
                      "${widget.hadeeth[0]}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    subtitle: Text(
                      "\n${widget.hadeeth[1]}",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    tileColor: Theme.of(context).primaryColor),
            ],
          ),
        ),
        if(widget.milestoneImage!='')
          Image.asset('${widget.milestoneImage}'),
        SizedBox(
          height: 4,
        ),
         if (widget.packContent.length > 0)
        ListTile(
            contentPadding: EdgeInsets.only(left:80),
            title: Text(
              "Each Pack Contains",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20),
            ),
            tileColor: Theme.of(context).primaryColor),
            if (widget.packContent.length > 0)
            GridView.count(
              
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: <Widget>[
          ListTile(subtitle:Text('${widget.packContent[0]}')),
          ListTile(subtitle:Text('${widget.packContent[1]}')),
        ]),
        

      ],
    );
  }
}
