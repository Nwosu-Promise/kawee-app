import 'package:flutter/material.dart';
import 'package:kiwee/provider/loading_provider.dart';
import 'package:kiwee/utility/colours.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import 'register.dart';

class AppForm extends StatefulWidget {
  final int val;

  AppForm({@required this.val});

  @override
  _AppFormState createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.animateTo(widget.val);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (_, lp, child) => Stack(
        children: [
          Opacity(
            opacity: lp.opacity,
            child: IgnorePointer(
              ignoring: lp.ignoreTouch,
              child: Scaffold(
                body: SafeArea(
                  child: NestedScrollView(
                      headerSliverBuilder: (context, isScrolling) => <Widget>[
                            SliverAppBar(
                              elevation: 8,
                              leading: Center(),
                              backgroundColor: bgWhite,
                              expandedHeight: 100,
                              flexibleSpace: Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                    child: Text(
                                  "KAWEE",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColour),
                                )),
                              ),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              floating: true,
                              delegate: _SliverAppBarDelegate(TabBar(
                                controller: _tabController,
                                tabs: <Tab>[
                                  Tab(
                                    child: Text('Sign up'),
                                  ),
                                  Tab(
                                    child: Text('Sign in'),
                                  )
                                ],
                              )),
                            )
                          ],
                      body: Container(
                        alignment: Alignment.center,
                        child: TabBarView(
                            controller: _tabController,
                            children: <Widget>[Register(), Login()]),
                      )),
                ),
              ),
            ),
          ),
          Visibility(
              visible: lp.visibility,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: primaryColour,
                ),
              ))
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: bgWhite,
      child: Container(margin: EdgeInsets.all(5), child: _tabBar),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
