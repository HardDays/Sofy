import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/helper/time_ago.dart';
import 'package:sofy_new/models/api_article_replies.dart';
import 'package:sofy_new/models/api_profile_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/screens/bloc/comments_bloc.dart';
import 'package:sofy_new/widgets/avatar.dart';
import 'package:sofy_new/widgets/comments/comment_field.dart';

class CommentItem extends StatefulWidget {
  CommentItem({Key key, @required this.reply, @required this.profile})
      : super(key: key);
  final Reply reply;
  final ApiProfileModel profile;

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  final TextEditingController _textController = TextEditingController();

bool _visivble = false;

  @override
  Widget build(BuildContext context) {
    double space = 12;
    double side = 33;
    double commentFieldWidth =  SizeConfig.screenWidth - space - side - 96;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(right: space),
            child: Avatar(
              coverImgUrl: widget.profile.coverImg,
              side: side,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: space + side),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.reply.userName.contains('Anonim') ? 'Anonim' : widget.reply.userName,
                  style: TextStyle(
                      fontFamily: kFontFamilyGilroy,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
                Text(
                  widget.reply.content,
                  style: TextStyle(
                      fontFamily: kFontFamilyGilroy,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          TimeAgo.timeAgoSinceDate(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(widget.reply.dateCreated) * 1000)),
                          style: TextStyle(
                              fontFamily: kFontFamilyGilroy,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: CommentsColors.DateColor),
                        ),
                        SizedBox(width: 5),
                        InkWell(
                          child: Text(
                            AppLocalizations.of(context).translate('reply'),
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: CommentsColors.ReplyColor),
                          ),
                          onTap: () {
                            setState(() {
                              _visivble = !_visivble;
                            });
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            int.parse(widget.reply.isLiked) > 0
                                ? BlocProvider.of<CommentsBloc>(context).add(
                                    CommentsEventDislike(
                                        id: int.parse(widget.reply.id),
                                        articleId: int.parse(widget.reply.articleId),
                                        parentId: int.parse(widget.reply.parentId)))
                                : BlocProvider.of<CommentsBloc>(context).add(
                                    CommentsEventLike(
                                        id: int.parse(widget.reply.id),
                                        articleId: int.parse(widget.reply.articleId),
                                        parentId: int.parse(widget.reply.parentId)));
                          },
                          child: int.parse(widget.reply.isLiked) > 0
                              ? Icon(CupertinoIcons.heart_fill,
                                  color: CommentsColors.ReplyColor)
                              : Icon(CupertinoIcons.heart,
                                  color: CommentsColors.PreloaderColor)
                          // SvgPicture.asset(
                          //                         'assets/svg/article_likes.svg',
                          //                         color: CommentsColors.ReplyColor,
                          //                       )
                          ,
                        ),
                        SizedBox(width: 6),
                        Text('${widget.reply.likesCount}',
                            style: TextStyle(
                                fontFamily: kFontFamilyGilroy,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                fontSize: 13)),
                      ],
                    )
                  ],
                ),
                Visibility(
                  visible: _visivble,
                  child: CommentField(
                    textController: _textController,
                    articleId: int.parse(widget.reply.articleId),
                    parentId: int.parse(widget.reply.parentId),
                    width: commentFieldWidth,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
