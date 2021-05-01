import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:connecting_hearts/services/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:connecting_hearts/ui/screens/media/update_detail.dart';

class Updates extends StatefulWidget {
  Updates({Key key}) : super(key: key);

  _UpdatesState createState() => _UpdatesState();
}

Future<dynamic> _zamzamUpdates;

class _UpdatesState extends State<Updates> {
  ApiListener mApiListener;

  @override
  void initState() {
    super.initState();
    _zamzamUpdates = WebServices(this.mApiListener).getZamzamUpdateData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: new RefreshIndicator(
        child: SingleChildScrollView(child: Container(child: buildData())),
        onRefresh: _handleRefresh,
      ),
    );
  }

  Widget buildData() {
    return FutureBuilder<dynamic>(
      future: _zamzamUpdates,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          var data = snapshot.data;

          children = <Widget>[
            for (var item in data) 
             if(item['status']=='active')
               updatesCard(item),
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
              child: Text('${snapshot.error}'), //Error: ${snapshot.error}
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

  Card updatesCard(dynamic data) {
    return Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Stack(children: <Widget>[
        InkWell(
          // borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
          child: ListTile(
            leading: CachedNetworkImage(
              width: 100,
            imageUrl: data['image_url'],
            placeholder: (context, url) =>
                Image.asset('assets/placeholder.png', width: 100,),
          ),
          title: Text(data['tag_line']),
          subtitle: Text(data['date_time']),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UpdateDetail(data)),
            );
          },
        ),
      ])
    ]));
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 2));

    setState(() {});

    return null;
  }
}
