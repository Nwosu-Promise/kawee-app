import 'package:flutter/material.dart';

class FrontProvider with ChangeNotifier{
  Widget _page;
  Widget get page => _page;
  setPage(Widget page){
    _page = page;
    notifyListeners();
  }
}