import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/models/api_article_poll_model.dart';
import 'package:sofy_new/models/api_article_variants_model.dart';
import 'package:sofy_new/widgets/articles/sofy_button.dart';
import 'package:sofy_new/widgets/articles/sofy_vote_button.dart';
import 'package:sofy_new/widgets/articles/vote_divider.dart';

class ArticleVote extends StatelessWidget {
  const ArticleVote({Key key, this.poll}) : super(key: key);
  final ApiArticlePollModel poll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            color: ArticleDetailsColors.BgColor,
            child: SofyDivider(icon: Icons.done)),
        Container(
          padding: EdgeInsets.only(bottom: 100, left: 21, right: 21),
          color: ArticleDetailsColors.BgColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 23.0),
                child: Text(
                  poll.blockName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: SofyVoteColors.Text,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(0.0),
                itemCount: poll.variants.length,
                itemBuilder: (BuildContext context, int index) {
                  ApiArticleVariantsModel variant = poll.variants[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: SofyVoteButton(
                      label: variant.content,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: SofyButton(
                  label: poll.buttonName,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
