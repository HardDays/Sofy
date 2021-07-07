import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/models/api_article_variants_model.dart';

class SofyVoteResult extends StatelessWidget {
  const SofyVoteResult({Key key,
    this.label = 'btn with ctar',
    this.isBordered = false,
    this.variant})
      : super(key: key);

  final bool isBordered;
  final String label;
  final ApiArticleVariantsModel variant;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width - 42 - 76 - 30;
    return Container(
      decoration: BoxDecoration(
          color: SofyVoteProgressColors.CardBgColor,
          borderRadius: BorderRadius.all(Radius.circular(13)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                variant.content,
                style: TextStyle(
                    color: SofyVoteProgressColors.TextColor, fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Container(
                        color: SofyVoteProgressColors.BgColor,
                        height: 4,
                        width: width,
                      ),
                      Container(
                        color: SofyVoteProgressColors.ActiveColor,
                        height: 4,
                        width: variant.percent / 100 * width,
                      ),
                    ],
                  ),
                  Text('${variant.percent.toString()}%'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}