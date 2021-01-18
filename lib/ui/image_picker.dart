import 'dart:io';

import 'package:connecting_hearts/services/services.dart';
import 'package:connecting_hearts/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  final String id;
  const PickImage(this.id, {Key key}) : super(key: key);
  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  File _image;
  ApiListener mApiListener;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Attach the deposit slip'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 64,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: Container(
                child: _image != null
                    ? ClipRRect(
                        child: Image.file(
                          _image,
                          height: MediaQuery.of(context).size.height *.7,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          ),
          if (_image != null)
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    onPressed: () {
                      showWaitingProgress(context);

                      WebServices(mApiListener)
                          .updateSlip(widget.id, _image.path)
                          .then((value) {
                        // print(imagePath);
                        print("===========>>>>$value");
                        if (value == 200) {
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Slip Updated Successfully"),
                          ));
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: Text(
                      'Submit deposit slip',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
