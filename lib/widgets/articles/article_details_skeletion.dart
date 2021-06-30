import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sofy_new/constants/app_colors.dart';

class ArticleDetailsSkeletion extends StatelessWidget {
  ArticleDetailsSkeletion({this.height, this.width});

  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            width: width,
            height: height / 2.16,
            child: Shimmer.fromColors(
              baseColor: kShimmerBaseColor,
              highlightColor: kAppPinkDarkColor,
              direction: ShimmerDirection.ltr,
              period: Duration(seconds: 2),
              child: Container(
                width: height / 4.1,
                height: height / 3.65,
                decoration: BoxDecoration(
                  color: kArticlesWhiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            )),
        Container(
          padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: height / 1.905),
          child: SizedBox(
              child: Shimmer.fromColors(
                baseColor: kShimmerBaseColor,
                highlightColor: kAppPinkDarkColor,
                direction: ShimmerDirection.ltr,
                period: Duration(seconds: 2),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: List.generate(
                          30,
                              (index) => index % 2 != 0
                              ? Container(
                            width: double.infinity,
                            height: 10,
                            color: kArticlesWhiteColor,
                          )
                              : SizedBox(height: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );;
  }
}
