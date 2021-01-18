class ImageSliderModel{
  String _path;
   String _tagline;

  ImageSliderModel(this._path,this._tagline);

  dynamic get path => _path;
  String get tagline => _tagline;

  set path(String value) {
    _path = value;
  }

  set tagline(String value) {
    _tagline = value;
  }

}