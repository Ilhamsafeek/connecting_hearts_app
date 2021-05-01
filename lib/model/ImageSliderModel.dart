class ImageSliderModel{
  String _path;
   String _tagline;

  ImageSliderModel(this._path,this._tagline);

  // ignore: unnecessary_getters_setters
  dynamic get path => _path;
  // ignore: unnecessary_getters_setters
  String get tagline => _tagline;

  // ignore: unnecessary_getters_setters
  set path(String value) {
    _path = value;
  }

  // ignore: unnecessary_getters_setters
  set tagline(String value) {
    _tagline = value;
  }

}