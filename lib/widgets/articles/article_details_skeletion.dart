import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';

class ArticleDetailsSkeletion extends StatelessWidget {
  const ArticleDetailsSkeletion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      color: ArticleDetailsColors.BgColor,
      child: Center(
        child: Container(
          child: CircularProgressIndicator(
            color: kAppPinkDarkColor,
          ),
          height: height / 10,
          width: height / 10,
        ),
      ),
    );
    // return SingleChildScrollView(
    //     physics: NeverScrollableScrollPhysics(),
    //     child: Stack(
    //       children: [
    //         Column(
    //           children: [
    //             SizedBox(height: 200),
    //             Center(child: Text('I INSERT SHIMMER HERE')),
    //           ],
    //         )
    //       ],
    //     ));
  }
}
