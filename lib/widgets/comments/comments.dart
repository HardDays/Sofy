import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_profile_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
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
            child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(kAppPinkDarkColor),
                strokeWidth: 2.0),
          );
        });
  }

  final TextEditingController _textController = TextEditingController();

  var _value = 1;

  @override
  Widget build(BuildContext context) {
    double width = SizeConfig.screenWidth;

    List<Sort> sort = [
      Sort(
          name: AppLocalizations.of(context)
              .translate('comments_most_interesting'),
          val: 1),
      Sort(
          name: AppLocalizations.of(context).translate('comments_sort_by_old'),
          val: 2),
      Sort(
          name: AppLocalizations.of(context).translate('comments_sort_by_new'),
          val: 0),
    ];

    return BlocBuilder<CommentsBloc, CommentsState>(
      bloc: BlocProvider.of<CommentsBloc>(context)
        ..add(CommentsEventLoad(articleId: articleId, sortBy: _value)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        // setState(() {
                                        _value = value;
                                        BlocProvider.of<CommentsBloc>(context)
                                          ..add(CommentsEventLoad(
                                              articleId: articleId,
                                              sortBy: _value));
                                        // });
                                      },
                                      elevation: 1,
                                      style: TextStyle(
                                          color: CommentsColors.SelectorText,
                                          fontSize: 13.0),
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
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: state.replies.length,
                                  itemBuilder: (context, index) {
                                    ApiProfileModel profile = state.profiles
                                        .firstWhere((element) =>
                                            element.id.toString() ==
                                            state.replies[index].userId
                                                .toString());
                                    return CommentItem(
                                        reply: state.replies[index],
                                        profile: profile);
                                  }),
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
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: CommentsColors.InputCardShadow1Color,
                        // color: Colors.red,
                        offset: Offset(0, -4),
                        blurRadius: 16,
                      ),
                      BoxShadow(
                        color: CommentsColors.InputCardShadow2Color,
                        offset: Offset(0, -11),
                        blurRadius: 14,
                      ),
                    ],
                    // color: Colors.red,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25))),
                child: Container(
                  padding: EdgeInsets.fromLTRB(21, 0, 21, 38),
                  child: CommentField(
                    textController: _textController,
                    articleId: articleId,
                    parentId: 0,
                    width: SizeConfig.screenWidth - 42 - 12 - 42,
                  ),
                ),
              ),
            ],
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

class Sort {
  Sort({this.name, this.val});

  final String name;
  final int val;
}
