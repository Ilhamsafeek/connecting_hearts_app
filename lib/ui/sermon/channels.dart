import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:connecting_hearts/model/Gridmodel.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:connecting_hearts/ui/sermon/channel_detail.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Channels extends StatefulWidget {
  final dynamic channelType;
  Channels(this.channelType,{Key key}) : super(key: key);

  _ChannelsState createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  ApiListener mApiListener;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.channelType}'),
      ),
      body: _bodyItem(),
      // backgroundColor: Colors.grey[200],
    );
  }

  Widget _bodyItem() {
    return SingleChildScrollView(
      child: Column(
        
        children: <Widget>[
          
          FutureBuilder<dynamic>(
              future: WebServices(this.mApiListener).getChannelData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List<Widget> children;

                if (snapshot.hasData) {  //channelType
                  dynamic data = snapshot.data;
                  //.where((el)=> el['type']==widget.channelType).toList();
                    
                 
                  children = <Widget>[
                    for (var item in data)
                      Column(children: <Widget>[
                        ListTile(
                          isThreeLine: true,
                          leading: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(item['photo']),
                            radius: 30,
                          ),
                          title: Text(item['channel']),
                          subtitle: Text("Total Jumma: ${item['total_jumma']} \nTotal Special Bayan: ${item['total_special']}"),
                          trailing: Icon(
                            Icons.more_horiz,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, anim1, anim2) =>
                                    ChannelDetail(item,widget.channelType),
                                transitionsBuilder:
                                    (context, anim1, anim2, child) =>
                                        FadeTransition(
                                            opacity: anim1, child: child),
                                transitionDuration: Duration(milliseconds: 100),
                              ),
                            );
                          },
                        ),
                        Divider()
                      ])
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
                ));
              }),
       
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class GridItem extends StatelessWidget {
  GridModel gridModel;

  GridItem(this.gridModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1 / 2),
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 20,
                backgroundImage:  NetworkImage(
                gridModel.imagePath,
                
              ),
              ),
             
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  gridModel.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
