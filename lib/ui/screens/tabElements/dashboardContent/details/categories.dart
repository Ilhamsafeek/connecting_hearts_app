
import 'package:connecting_hearts/ui/screens/tabElements/dashboardContent/echarity/project.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:connecting_hearts/services/services.dart';


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

  Categories(
      this.photo,
      this.category,
      this.description,
      this.thumbnailImages,
      this.secondTitle,
      this.secondOverview,
      this.hadeeth,
      this.milestoneImage,
      this.packContent,
      {Key key})
      : super(key: key);
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;

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
              onPressed: () async {
                // Navigator.of(context).push(
                //     CupertinoPageRoute<Null>(builder: (BuildContext context) {
                //   return new Charity();
                // }));
                await WebServices(this.mApiListener)
                    .getCategoryData()
                    .then((value) {
                  // item['category']
                  dynamic item = value
                      .where((el) => el['category'] == widget.category)
                      .toList()[0];
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Project(item)),
                  );
                });
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
              widget.category == 'Academy'
                  ? Container(
                      color: Colors.blueGrey[100],
                      child: ExpansionTile(
                        initiallyExpanded:true,
                        childrenPadding: EdgeInsets.all(10),
                        title: Text("Sankalpa"),
                        children: <Widget>[
                          Text(
                              'Unique 1-year residential course conducted for Islamic Scholars with Sinhala language fluency, selected through an open call for applications and an interview process. This course objective is to create and nurture Islamic Scholars / Imams who are able to responsibly guide the Muslim community in Sri Lanka and specially the youth with a very broadminded manner to counter challenges of radicalization and social alienation, while building interfaith relationships and bridging the divide between communities by clarifying doubts, eliminating suspicions and giving positive leadership by being able to communicate in a relatable manner in Sinhala Language.\n')
                      
                         ,GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: (16 / 9.35),
                              children: <Widget>[
                                for (var image in ['assets/sankalpa-01s.jpg','assets/sankalpa-02s.jpg','assets/sankalpa-03s.jpg','assets/sankalpa-04s.jpg'])
                                  InkWell(
                                      child: Card(
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                            Image.asset(image, fit: BoxFit.fill)
                                          ])),
                                      onTap: () {}),
                              ])
                        
                        ],
                        
                      ))
                  : Text(''),
              widget.category == 'Academy'
                  ? Container(
                      color: Colors.blueGrey[200],
                      child: ExpansionTile(
                        childrenPadding: EdgeInsets.all(10),
                        title: Text("VIP"),
                        children: <Widget>[
                          Text(
                              'Through the Valued Imam Project (VIP) selected qualified Chief Imams from Mosques in various Districts of Sri Lanka are provided with Continuous Professional Development through a once-a-week civic and soft skills development session series. The sessions provide them the knowledge and skills on personality development, to work with other religious leaders, to engage with diverse congregants,  to develop the mosques towards Model Mosques and to work with other communities in their own local areas.\n')
                       ,
                        GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: (16 / 9.35),
                              children: <Widget>[
                                for (var image in ['assets/vip-01s.jpg','assets/vip-02s.jpg','assets/vip-03s.jpg','assets/vip-04s.jpg'])
                                  InkWell(
                                      child: Card(
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                            Image.asset(image, fit: BoxFit.fill)
                                          ])),
                                      onTap: () {}),
                              ])
                        
                       
                        ],
                        initiallyExpanded: false,
                      ))
                  : Text(''),
              widget.category == 'Academy'
                  ? Container(
                      color: Colors.blueGrey[100],
                      child: ExpansionTile(
                        childrenPadding: EdgeInsets.all(10),
                        title: Text("Explore Knowledge Series"),
                        children: <Widget>[
                          Text(
                              'A monthly knowledge sharing session series with information related to modern day / contemporary topics which are being explained from a technical and spiritual background through subject matter experts.\n'),
                          GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: (16 / 9.35),
                              children: <Widget>[
                                for (var image in ['assets/explore-01s.jpg','assets/explore-02s.jpg'])
                                  InkWell(
                                      child: Card(
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                            Image.asset(image, fit: BoxFit.fill)
                                          ])),
                                      onTap: () {}),
                              ])
                        
                        ],
                        initiallyExpanded: false,
                      ))
                  : Text(''),
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
        if (widget.secondTitle != '')
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
        if (widget.hadeeth.length > 0 || widget.secondOverview != '')
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.secondOverview != '')
                  ListTile(
                    title: Text("${widget.secondOverview}"),
                  ),
                if (widget.hadeeth.length > 0)
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
        if (widget.milestoneImage != '')
          Image.asset('${widget.milestoneImage}'),
        SizedBox(
          height: 4,
        ),
        if (widget.packContent.length > 0)
          ListTile(
              contentPadding: EdgeInsets.only(left: 80),
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
                ListTile(subtitle: Text('${widget.packContent[0]}')),
                ListTile(subtitle: Text('${widget.packContent[1]}')),
              ]),
      ],
    );
  }
}
