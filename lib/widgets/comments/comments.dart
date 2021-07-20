import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_profile_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/bloc/comments_bloc.dart';
import 'package:sofy_new/widgets/comments/comment_field.dart';
import 'package:sofy_new/widgets/comments/comment_item.dart';

class Comments extends StatelessWidget {
  Comments({Key key, this.articleId = 1}) : super(key: key);
  final int articleId;

  showLoaderDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(kAppPinkDarkColor), strokeWidth: 2.0),
          );
        });
  }

  final TextEditingController _textController = TextEditingController();

  var _value = 1;

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;

    List<Sort> sort = [
      Sort(name: AppLocalizations.of(context).translate('comments_most_interesting'), val: 1),
      Sort(name: AppLocalizations.of(context).translate('comments_sort_by_old'), val: 2),
      Sort(name: AppLocalizations.of(context).translate('comments_sort_by_new'), val: 0),
    ];

    return BlocBuilder<CommentsBloc, CommentsState>(
      bloc: BlocProvider.of<CommentsBloc>(context)..add(CommentsEventLoad(articleId: articleId, sortBy: _value)),
      builder: (context, state) {
        if (state is CommentsStateResult) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(21),
                child: Container(
                  height: 1,
                  color: CommentsColors.DividerColor,
                ),
              ),
              state.replies.length > 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(21, 0, 21, 0),
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
                                    DropdownButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: CommentsColors.DividerColor,
                                      ),
                                      value: _value,
                                      items: sort
                                          .map((e) => DropdownMenuItem(
                                                child: Text(e.name),
                                                value: e.val,
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        Analytics().sendEventReports(
                                          event: EventsOfAnalytics.comment_order_click,
                                          attr: {
                                            'name': sort.firstWhere((element) => element.val == value).name,
                                          },
                                        );
                                        _value = value;
                                        BlocProvider.of<CommentsBloc>(context)..add(CommentsEventLoad(articleId: articleId, sortBy: _value));
                                      },
                                      elevation: 1,
                                      style: TextStyle(color: CommentsColors.SelectorText, fontSize: 13.0),
                                      underline: Container(
                                        height: 1,
                                        color: ArticleDetailsColors.BgColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state.replies.length,
                                  itemBuilder: (context, index) {
                                    ApiProfileModel profile = state.profiles.firstWhere((element) => element.id.toString() == state.replies[index].userId.toString());
                                    return CommentItem(reply: state.replies[index], profile: profile);
                                  }),
                              Visibility(
                                  visible: state.sending,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(AppLocalizations.of(context).translate('comment_sending')),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(
                      child: Center(
                        child: Text(
                          '${AppLocalizations.of(context).translate('no_comments')}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      padding: EdgeInsets.only(bottom: 21),
                    ),
              Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                          color: CommentsColors.InputCardShadow1Color,
                          // color: Colors.red,
                          offset: Offset(0, -4),
                          blurRadius: 16,
                        ),
                        BoxShadow(
                          color: CommentsColors.InputCardShadow2Color,
                          // color: Colors.red,

                          offset: Offset(0, -11),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                      child: Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(21, 21, 21, 38),
                        child: CommentField(
                          textController: _textController,
                          articleId: articleId,
                          parentId: 0,
                          width: SizeConfig.screenWidth - 42 - 12 - 42,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        }
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

class Sort {
  Sort({this.name, this.val});

  final String name;
  final int val;
}
