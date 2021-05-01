
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:connecting_hearts/services/services.dart';
import 'package:connecting_hearts/ui/screens/media/channel.dart';
import 'package:connecting_hearts/ui/screens/media/updates.dart';

class Media extends StatefulWidget {
  Media({Key key}) : super(key: key);

  _MediaState createState() => _MediaState();
}

class _MediaState extends State<Media> {
  @override
  void initState() {
    super.initState();
  }

  ApiListener mApiListener;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverAppBar(
                  expandedHeight: 180,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      'assets/zamzam_media_thumbnail.png',
                      fit: BoxFit.fill,
                    ),
                  ),
               
                ),
              ];
            },
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _tabSection(context),
                ],
              ),
            )),
      ),
    );
  }


  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(tabs: [
              Tab(text: "Media"),
              Tab(text: "Updates"),
            ],labelColor: Colors.black,
            indicatorWeight:4),
          ),
          Container(
            //Add this to give height
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [
              Channel(),
              Updates(),
            ]),
          ),
        ],
      ),
    );
  }
}
