import 'package:flutter/material.dart';

class IconGridModel {
  Icon _icon;
  String _title;
  Color _color;

  IconGridModel(this._icon, this._title, this._color);

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

  Icon get icon => _icon;

  set imagePath(Icon value) {
    _icon = value;
  }


}