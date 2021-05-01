import 'package:flutter/material.dart';

class GridModel {
  String _imagePath;
  String _title;
  Color _color;

  GridModel(this._imagePath, this._title, this._color);

  // ignore: unnecessary_getters_setters
  Color get color => _color;

  // ignore: unnecessary_getters_setters
  set color(Color value) {
    _color = value;
  }

  // ignore: unnecessary_getters_setters
  String get title => _title;

  // ignore: unnecessary_getters_setters
  set title(String value) {
    _title = value;
  }

  // ignore: unnecessary_getters_setters
  String get imagePath => _imagePath;

  // ignore: unnecessary_getters_setters
  set imagePath(String value) {
    _imagePath = value;
  }


}