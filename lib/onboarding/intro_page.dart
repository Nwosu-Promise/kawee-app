import 'package:flutter/material.dart';

import 'page_view_model.dart';
import 'intro_content.dart';


import '../utility/exports/exports_utilities.dart';

class IntroPage extends StatelessWidget {
  final PageViewModel page;

  const IntroPage({Key key, @required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: page.decoration.pageColor,
        decoration: page.decoration.boxDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (page.image != null)
//              Container(
//                height: 100,
//                decoration: BoxDecoration(
//                  color: surfaceWhite,
//                    shape: BoxShape.rectangle,
//                    borderRadius: BorderRadius.circular(20)
////                    borderRadius: BorderRadius.only(
////                        topLeft: Radius.circular(25.0),
////                        bottomRight: Radius.circular(25.0)
////                    )
//                    ),
////                child: Padding(
////                  padding: EdgeInsets.all(10),
////                  child:
////                      SvgPicture.asset('assets/svg/shopkite_logo_coloured.svg'),
////                ),
//              ),

              Expanded(
                flex: page.decoration.imageFlex,
                child: Padding(
                  // padding: page.decoration.imagePadding,
                  padding: EdgeInsets.all(0),
                  //   child: page.image,
                  child: Stack(
                    children: <Widget>[
                      Container(
                          // padding: EdgeInsets.all(10),
                          height: height,
                          width: width,
                          child: page.image

////                  color: Colors.red,
//                      child: ClipRRect(
//                          borderRadius: BorderRadius.circular(20.0),
//                          child: page.image),
                          ),
                      Positioned(
                        bottom: 100.0,
                        left: 0.0,
                        right: 0.0,
                        child: IntroContent(page: page),
                      )
                    ],
                  ),
                ),
              ),
//            Expanded(
//              flex: page.decoration.bodyFlex,
//              child: Padding(
//                padding: const EdgeInsets.only(bottom: 70.0),
//                child: SingleChildScrollView(
//                  physics: const BouncingScrollPhysics(),
//                  //child: IntroContent(page: page),
//                  child: Text("oo"),
//                ),
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}
