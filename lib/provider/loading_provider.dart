import 'package:flutter/material.dart';

class LoaderProvider with ChangeNotifier{

  double _opacity = 1;
  double get opacity => _opacity;
  setOpacity(double opacity) {
    _opacity = opacity;
    notifyListeners();
  }

  bool _visibility = false;
  bool get visibility => _visibility;
  setVisibility(bool visibility) {
    _visibility = visibility;
    notifyListeners();
  }

  bool _ignoreTouch = false;
  bool get ignoreTouch => _ignoreTouch;
  setIgnoreTouch(bool ignoreTouch){
    _ignoreTouch = ignoreTouch;
    notifyListeners();
  }
}