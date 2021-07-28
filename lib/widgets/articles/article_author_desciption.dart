import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/models/api_profile_model.dart';
import 'package:sofy_new/widgets/avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticleAuthorDescription extends StatelessWidget {
  const ArticleAuthorDescription({Key key, this.author}) : super(key: key);
  final ApiProfileModel author;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.h,
      child: Row(
        children: [
          author.coverImg != null
              ? Row(
                  children: [
                    Avatar(coverImgUrl: author.coverImg),
                    SizedBox(width: 12.w),
                  ],
                )
              : Container(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              author.username != null
                  ? Text(
                      author.username,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                    )
                  : Container(),
              author.role != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('assets/svg/instagram.svg'),
                        SizedBox(width: 4.w),
                        Text(
                          author.role,
                          style: TextStyle(fontSize: 13.sp),
                        )
                      ],
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }
}