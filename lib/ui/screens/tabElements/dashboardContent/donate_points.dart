import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';


class DonatePoints extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();

  DonatePoints({Key key}) : super(key: key);
}

class _CategoriesState extends State<DonatePoints> {
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
                'Loyality Points',
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
              "\nYou can donate your Loyality points towards Zam Zam Foundation’s Administrative / Project expenses\n",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
                '(Points Usage will be separately audited annually)\n'),
             tileColor: Color.fromRGBO(80, 172, 225, 1)),
              ListTile(
                contentPadding: EdgeInsets.only(left: 20),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('\nQuote our registered Phone Number\n',style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),),
                    Text('076 665 7799\n', style: TextStyle(fontSize: 20, color: Colors.white),),
                  ],
                ),
                tileColor: Colors.green
                ,onTap: (){
                  _launchURL("tel://076 665 7799");
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
                        Share.share('You can now donate your Loyalty Point to Zam Zam Foundation by producing below number to outlets that we are registered with in Sri Lanka:\n076 665 7799\nThank You for your valuable contribution.',
                        );                            
                      },
                      label: Text('Share'),
                    ),
                  ],
                ),
                tileColor: Colors.white),
            onTap: () {
               Share.share('You can now donate your Loyalty Point to Zam Zam Foundation by producing below number to outlets that we are registered with in Sri Lanka:\n076 665 7799\nThank You for your valuable contribution.',
                        ); 
            }),
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
