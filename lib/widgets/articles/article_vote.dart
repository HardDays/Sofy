import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/models/api_article_poll_model.dart';
import 'package:sofy_new/models/api_article_variants_model.dart';
import 'package:sofy_new/rest_api.dart';
import 'package:sofy_new/screens/bloc/article_vote_bloc.dart';
import 'package:sofy_new/widgets/articles/sofy_button.dart';
import 'package:sofy_new/widgets/articles/sofy_vote_button.dart';
import 'package:sofy_new/widgets/articles/sofy_vote_result.dart';
import 'package:sofy_new/widgets/articles/vote_divider.dart';

class ArticleVote extends StatelessWidget {
  const ArticleVote({Key key, this.poll}) : super(key: key);
  final ApiArticlePollModel poll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SofyDivider(icon: Icons.done),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 21),
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
              BlocProvider<ArticleVoteBloc>(
                create: (BuildContext context) =>
                    ArticleVoteBloc(restApi: RestApi(), variants: poll.variants)
                      ..add(ArticleVoteEventInit()),
                child: BlocBuilder<ArticleVoteBloc, ArticleVoteState>(
                  builder: (context, state) {
                    bool isResult = state.variants
                            .where((element) => !element.selected)
                            .length !=
                        state.variants.length;
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(0.0),
                          itemCount: state.variants.length,
                          itemBuilder: (BuildContext context, int index) {
                            ApiArticleVariantsModel variant =
                                state.variants[index];
                            // результаты
                            return isResult
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: SofyVoteResult(
                                      variant: variant,
                                    ),
                                  )
                                :
                                // варианты
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: SofyVoteButton(
                                        label: variant.content,
                                        callback: () {
                                          BlocProvider.of<ArticleVoteBloc>(
                                                  context)
                                              .add(ArticleVoteEventSetVote(
                                                  variantId: variant.id));
                                        },
                                        isBordered: variant.selected),
                                  );
                          },
                        ),
                        isResult
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 14, bottom: 30),
                                child: SofyButton(
                                    label: poll.buttonName,
                                    callback: () {
                                      BlocProvider.of<ArticleVoteBloc>(context)
                                          .add(ArticleVoteEventVote());
                                    }),
                              ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
