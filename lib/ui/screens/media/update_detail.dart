import 'package:cached_network_image/cached_network_image.dart';
import 'package:connecting_hearts/ui/screens/tabElements/dashboardContent/echarity/echarity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';


class UpdateDetail extends StatefulWidget {
  final dynamic detail;
  UpdateDetail(this.detail, {Key key}) : super(key: key);

  _UpdatesState createState() => _UpdatesState();
}

class _UpdatesState extends State<UpdateDetail> {
  Future _updateImages;
  ApiListener mApiListener;
  VideoPlayerController _controller;
  Icon _playStatusIcon = Icon(
    Icons.play_arrow,
    size: 70,
    color: Colors.white,
  );
  @override
  void initState() {
    _updateImages = WebServices(this.mApiListener)
        .getImageFromFolder(widget.detail['updates_folder'], 'updates');
    super.initState();
    _controller = VideoPlayerController.network(widget.detail['local_video'])
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Updates'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                AspectRatio(
                  child: Image(
                    width: 30,
                    image: NetworkImage(widget.detail['image_url']),
                    centerSlice: Rect.largest,
                  ),
                  aspectRatio: 320 / 180,
                ),
                Positioned(
                  child: Text(
                    widget.detail['date_time'],
                    style: TextStyle(color: Colors.white),
                  ),
                  bottom: 2,
                  left: 5,
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                      title: Text(
                        widget.detail['tag_line'] + "\n",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      subtitle: Text(widget.detail['description']),
                      tileColor: Colors.grey[100]),
                  Divider(height: 0),
                  SizedBox(
                    height: 8,
                  ),

                  // Video
                  if (widget.detail['video_url'] != '')
                    Center(
                      child: AspectRatio(
                        child: YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: YoutubePlayer.convertUrlToId(
                                widget.detail['video_url']),
                            flags: YoutubePlayerFlags(
                              autoPlay: true,
                              mute: false,
                              hideThumbnail: false,
                              disableDragSeek: false,
                            ),
                          ),
                        ),
                        aspectRatio: 16 / 9,
                      ),
                    ),
                   SizedBox(
                    height: 8,
                  ),
                  if (widget.detail['local_video'] != '')
                    Container(
                      child: _controller.value.initialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: InkWell(
                                child: Stack(
                                  children: [
                                    VideoPlayer(_controller),
                                    Align(
                                      alignment: Alignment.center,
                                      child: _playStatusIcon,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                    _controller.value.isPlaying
                                        ? _playStatusIcon = Icon(
                                            Icons.pause,
                                            size: 70,
                                            color: Colors.white,
                                          )
                                        : _playStatusIcon = Icon(
                                            Icons.play_arrow,
                                            size: 70,
                                            color: Colors.white,
                                          );
                                  });
                                },
                              ))
                          : Container(
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: SizedBox(
                                  child: SpinKitPulse(
                                    color: Colors.grey,
                                    size: 120.0,
                                  ),
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                            ),
                    ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            Container(
              child: FutureBuilder<dynamic>(
                future: _updateImages,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  List<Widget> children;

                  if (snapshot.hasData) {
                    dynamic data = snapshot.data;
                    children = <Widget>[
                      GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          children: <Widget>[
                            for (var item in data)
                              CachedNetworkImage(
                                imageUrl: item,
                                placeholder: (context, url) =>
                                    Image.asset('assets/placeholder.png'),
                              ),
                          ]),
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
                      Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 16 / 10,
                                child: Container(color: Colors.black),
                              ),
                            ],
                          )))
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
              ),
            ),
            Container(
                child: Row(children: <Widget>[
              Expanded(
                child: FlatButton.icon(
                  icon: Icon(
                    Icons.share,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    // Share.share('check out my website https://example.com',
                    //     subject: 'Look what I made!');
                  },
                  label: Text('Share'),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).push(CupertinoPageRoute<Null>(
                              builder: (BuildContext context) {
                            return new Charity();
                          }));
                        },
                        child:
                            Text("Donate Now", style: TextStyle(fontSize: 16)),
                        color: Colors.amber,
                      )),
                    ],
                  ),
                ),
              ),
            ]))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
