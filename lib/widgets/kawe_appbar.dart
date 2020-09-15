import 'package:flutter/material.dart';

class KaweAppbar extends StatefulWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;

  KaweAppbar({this.title, this.actions});

  @override
  _KaweAppbarState createState() => _KaweAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}

class _KaweAppbarState extends State<KaweAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: widget.title,
      actions: widget.actions,
    );
  }
}
