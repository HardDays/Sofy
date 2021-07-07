import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/time_ago.dart';
import 'package:sofy_new/models/api_article_replies.dart';
import 'package:sofy_new/models/api_profile_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/widgets/avatar.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({Key key, @required this.reply, @required this.profile})
      : super(key: key);
  final Reply reply;
  final ApiProfileModel profile;

  @override
  Widget build(BuildContext context) {
    double space = 12;
    double side = 33;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(right: space),
            child: Avatar(
              coverImgUrl: profile.coverImg,
              side: side,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: space + side),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reply.userName,
                  style: TextStyle(
                      fontFamily: kFontFamilyGilroy,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
                Text(
                  reply.content,
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
                                  int.parse(reply.dateCreated) * 1000)),
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
                          onTap: (){
                            print('replreplrepl');
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            print('like pressed');
                          },
                          child: SvgPicture.asset(
                            'assets/svg/article_likes.svg',
                          ),
                        ),
                        SizedBox(width: 6),
                        Text('${reply.likesCount}',
                            style: TextStyle(
                                fontFamily: kFontFamilyGilroy,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.normal,
                                fontSize: 13)),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
