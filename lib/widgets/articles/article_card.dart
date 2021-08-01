import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/app_purchase.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard(
      {Key key,
      this.title = 'Title',
      this.path = 'assets/articles/card_1.png',
      this.width = 242,
      this.height = 293,
      this.frozenHeight = 81,
      this.fontSize = 17,
      this.textColor = const Color(0x725E5C),
      this.radius = 27,
      this.isPaid = 1,
      this.callback,
      this.lineHeight = 1})
      : super(key: key);
  final double radius;
  final double height;
  final double width;
  final double frozenHeight;
  final double lineHeight;
  final Color textColor;
  final double fontSize;
  final String title;
  final String path;
  final int isPaid;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: kArticleCardBgColor,
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              fit: StackFit.expand,
              children: [
                Image(image: CachedNetworkImageProvider(path,), fit: BoxFit.cover,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 32.0,
                          sigmaY: 32.0,
                        ),
                        child: Container(
                          height: frozenHeight,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(5, 255, 255, 255),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Center(
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: TextStyle(
                                color: textColor,
                                fontSize: fontSize,
                                fontFamily: Fonts.HindGuntur,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                height: lineHeight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                BlocBuilder<AppPurchase, AppPurchaseState>(builder: (context, state) {
                  if (state is AppPurchaseCurrentStatus)
                    return Visibility(
                      visible: isPaid == 1,
                      child: Visibility(
                        visible: !state.status,
                        child: Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(
                            top: 11.h,
                            right: 10.w,
                          ),
                          height: (19 + 11).h,
                          width: (16 + 10).w,
                          child: SvgPicture.asset(
                            'assets/lock.svg',
                          ),
                        ),
                      ),
                    );
                  return Container();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
