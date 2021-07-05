import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';

class ArticleSkeletion extends StatelessWidget {
  const ArticleSkeletion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        child: CircularProgressIndicator(
          color: kAppPinkDarkColor,
        ),
        height: height / 10,
        width: height / 10,
      ),
    );
    return SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 200),
                Center(child: Text('I INSERT SHIMMER HERE')),
              ],
            )
          ],
        ));
  }
}