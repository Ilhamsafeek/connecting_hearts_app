import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connecting_hearts/ui/job/edit_appeal.dart';
import 'package:connecting_hearts/ui/job/edit_vacancy.dart';
import 'package:connecting_hearts/ui/job/job_detail.dart';
import 'package:connecting_hearts/ui/job/appeal_job.dart';
import 'package:connecting_hearts/ui/job/post_vacancy.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connecting_hearts/services/services.dart';
import 'package:connecting_hearts/constant/Constant.dart';
import 'package:connecting_hearts/utils/dialogs.dart';

class Jobs extends StatefulWidget {
  Jobs({Key key}) : super(key: key);

  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  ApiListener mApiListener;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Job Bank')),
        body: SingleChildScrollView(

            // child: AnimationLimiter(
            child: Column(
                children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 50.0,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: <Widget>[
            ExpansionTile(
              title: Text("Post New vacancy"),
              subtitle: Text('or Request for Job'),
              leading: Icon(Icons.add_circle),
              children: <Widget>[
                // Image.network(
                //     'https://cdn.dribbble.com/users/30476/screenshots/6138614/interview.png'),
                ExpansionTile(
                  title: Text('My Appeals and vacancies'),
                  children: <Widget>[
                    FutureBuilder<dynamic>(
                        future: WebServices(mApiListener).getJobData(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          List<Widget> children;

                          if (snapshot.hasData) {
                            var data = snapshot.data
                                .where((el) => el['posted_by'] == CURRENT_USER)
                                .toList();
                            print(data);
                            children = <Widget>[
                              for (var item in data)
                                Container(
                                    child: Column(children: <Widget>[
                                  _buildJobListTile(item, 'my'),
                                  Divider()
                                ]))
                            ];

                            return Center(
                              child: Column(
                                children: children,
                              ),
                            );
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
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: FlatButton.icon(
                      icon: Icon(
                        Icons.flash_on,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute<Null>(
                            builder: (BuildContext context) {
                          return new PostVacancy();
                        }));
                      },
                      label: Text(
                        'Post a Vacancy',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
                    Expanded(
                        child: FlatButton.icon(
                      color: Colors.blue[900],
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute<Null>(
                            builder: (BuildContext context) {
                          return new AppealJob();
                        }));
                      },
                      label: Text(
                        'Appeal a Job',
                        style: TextStyle(color: Colors.white),
                      ),
                    ))
                  ],
                ),
              ],
              initiallyExpanded: false,
            ),
            ListTile(
              title: Text(
                'All vacancies and appeals',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              height: 0,
            ),
            // DefaultTabController(
            //   initialIndex: 0,
            //   length: 2,
            //   child: TabBar(
            //     labelColor: Colors.black,
            //     tabs: [
            //       Tab(
            //         text: 'Vacancies',
            //       ),
            //       Tab(
            //         text: 'Appeals',
            //       ),
            //     ],
            //   ),
            // ),
            _tabSection(context),
           
          ],
        ))));
  }

  Widget _buildJobListTile(item, category) {
    if (item['type'] == 'appeal') {
      return ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text(item['title']),
        subtitle: Text(
            'Experience: ${item['min_experience']}\n\n${item['date_time']}'),
        trailing: category == 'my'
            ? PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == "edit") {
                    Navigator.of(context).push(CupertinoPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new EditAppeal(item);
                    }));
                  } else {
                    _deleteModalBottomSheet(context, item['id']);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text("Edit"),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text("Delete"),
                  ),
                ],
              )
            : null,
        onTap: () {
          Navigator.of(context)
              .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
            return new JobDetail(item);
          }));
        },
      );
    } else {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal,
          child: Text(
            '${item['organization'][0]}',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        isThreeLine: true,
        title: Text(item['title']),
        subtitle: Text('${item['organization']}\n\n${item['date_time']}'),
        trailing: category == 'my'
            ? PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'edit') {
                    Navigator.of(context).push(CupertinoPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new EditVacancy(item);
                    }));
                  } else {
                    _deleteModalBottomSheet(context, item['id']);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text("Edit"),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text("Delete"),
                  ),
                ],
              )
            : Icon(
                Icons.turned_in_not,
                color: Colors.grey,
              ),
        onTap: () {
          Navigator.of(context)
              .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
            return new JobDetail(item);
          }));
        },
      );
    }
  }

  Widget _tabSection(BuildContext context) {
  return DefaultTabController(
    length: 2,
    
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: TabBar(tabs: [
            Tab(text: "Vacancies"),
            Tab(text: "Appeals"),
          ], labelColor: Colors.black,),
        ),
        Container( 
          //Add this to give height
          height: MediaQuery.of(context).size.height,
          child: TabBarView(children: [
            Container(
              child:  FutureBuilder<dynamic>(
                future: WebServices(mApiListener).getJobData(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  List<Widget> children;

                  if (snapshot.hasData) {
                    children = <Widget>[
                      for (var item in snapshot.data.where((el) => el['type'] == 'vacancy'))
                        Container(
                            child: Column(children: <Widget>[
                          _buildJobListTile(item, 'all'),
                          Divider()
                        ]))
                    ];

                    return Center(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: children,
                        ),
                      ),
                    );
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
          
            ),
            Container(
              child:  FutureBuilder<dynamic>(
                future: WebServices(mApiListener).getJobData(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  List<Widget> children;

                  if (snapshot.hasData) {
                    children = <Widget>[
                      for (var item in snapshot.data.where((el) => el['type'] == 'appeal'))
                        Container(
                            child: Column(children: <Widget>[
                          _buildJobListTile(item, 'all'),
                          Divider()
                        ]))
                    ];

                    return Center(
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: children,
                        ),
                      ),
                    );
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
          
            ),
           
          ]),
        ),
      ],
    ),
  );
}

  Future<bool> _deleteModalBottomSheet(context, id) {
    return showModalBottomSheet(
        enableDrag: false,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              child: new Wrap(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Do you really want to delete?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: RaisedButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(
                              child: RaisedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              showWaitingProgress(context);
                              await WebServices(mApiListener)
                                  .deleteJob(id)
                                  .then((value) => {
                                        if (value == 200)
                                          {
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text("Deleted Successfully."),
                                            ))
                                          }
                                        else
                                          {
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text("Something went wrong!"),
                                            ))
                                          }
                                      });
                              Navigator.pop(context);
                            },
                            child: Text("Yes"),
                            color: Colors.black,
                            textColor: Colors.white,
                          )),
                        ],
                      )
                    ]),
                  )
                ],
              ),
            );
          });
        });
  }
}
