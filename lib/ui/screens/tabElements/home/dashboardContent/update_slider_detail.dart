import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class UpdateSliderDetail extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();

  UpdateSliderDetail({Key key}) : super(key: key);
}

class _CategoriesState extends State<UpdateSliderDetail> {
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
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Update Details',
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
        ListTile(
            title: Text(
              "\nYou can donate your supermarket / shopping points towards Zam Zam Foundation’s Administrative / Project expenses by quoting our registered phone number\n",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
                '(Accumulated Points Usage will be separately audited annually)\n'),
             tileColor: Color.fromRGBO(80, 172, 225, 1)),
              ListTile(
                contentPadding: EdgeInsets.only(left: 20),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('077XXXXXXX', style: TextStyle(fontSize: 20),),
                  ],
                ),
                tileColor: Colors.orange
                ,onTap: (){
                  _launchURL("tel://077777777777");
                },),
            
           
        _buildMerchants(),
        InkWell(
            child: ListTile(
                contentPadding: EdgeInsets.only(left: 20),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton.icon(
                      icon: Icon(
                        Icons.share,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        // Share.share('check out my website https://example.com',
                        //     subject: 'Look what I made!');
                //              Navigator.of(context).push(
                //     CupertinoPageRoute<Null>(builder: (BuildContext context) {
                //   return new Test();
                // }));
                      },
                      label: Text('Share'),
                    ),
                  ],
                ),
                tileColor: Colors.white),
            onTap: () {}),
      ],
    );
  }

  Widget _buildMerchants() {
    return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: <Widget>[
          _dashboardPanel('assets/merchant3.png'),
           _dashboardPanel('assets/merchant5.png'),
          _dashboardPanel('assets/merchant1.png'),
          _dashboardPanel('assets/merchant2.png'),          
          _dashboardPanel('assets/merchant4.png'),         
          _dashboardPanel('assets/merchant6.png'),
          _dashboardPanel('assets/merchant7.png')
        ]);
  }

  Widget _dashboardPanel(dynamic image) {
    return Card(
        child: Image.asset(
      image,
      width: 65,
    ));
  }

   _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
