import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/models/api_profile_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/rest_api.dart';
import 'package:sofy_new/screens/bloc/comments_bloc.dart';
import 'package:sofy_new/widgets/comment_item.dart';

class Comments extends StatelessWidget {
  const Comments({Key key, this.articleId = 1}) : super(key: key);
  final int articleId;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<CommentsBloc, CommentsState>(
      bloc: CommentsBloc(
          restApi: RestApi(
              systemLang: AppLocalizations.of(context).locale.languageCode))
        ..add(CommentsEventLoad(articleId: articleId)),
      builder: (context, state) {
        if (state is CommentsStateResult) {
          return state.replies.length > 0
              ? Padding(
                  padding: const EdgeInsets.all(21),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${state.replies.length} ${AppLocalizations.of(context).translate('comments')}',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Abhaya Libre ExtraBold',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                print('like pressed');
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context).translate('most_interesting')}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Abhaya Libre ExtraBold',
                                    ),
                                  ),
                                  SizedBox(width: 9),
                                  SvgPicture.asset(
                                    'assets/svg/article_comments_sort.svg',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.replies.length,
                          itemBuilder: (context, index) {
                            ApiProfileModel profile = state.profiles.firstWhere(
                                (element) =>
                                    element.id.toString() ==
                                    state.replies[index].userId.toString());
                            return CommentItem(
                                reply: state.replies[index], profile: profile);
                          }),
                    ],
                  ),
                )
              : Container(
                  child: Center(
                    child: Text(
                      '${AppLocalizations.of(context).translate('no_comments')}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  width: width,
                  height: width / 4,
                );
        }
        if (state is CommentsStateLoading)
          return Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: CircularProgressIndicator(
                color: CommentsColors.PreloaderColor,
              ),
            ),
          );
        if (state is CommentsStateError)
          return Container(
            child: Center(
              child: Text(state.error, textAlign: TextAlign.center),
            ),
            width: width,
          );
        return Container();
      },
    );
  }
}
