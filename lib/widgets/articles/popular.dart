import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sofy_new/app_purchase.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_articles_model.dart';
import 'package:sofy_new/screens/arcticle_details_screen.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Popular extends StatelessWidget {
  const Popular({Key key, this.title, this.listOfArticles, this.textColor = kArticlesHeaderTextColor, this.fontSize = 24, this.cardHeight = 64, this.cardWidth = 64, this.imageRadius = 8})
      : super(key: key);
  final String title;
  final List<ApiArticlesModel> listOfArticles;
  final Color textColor;
  final double fontSize;
  final double cardHeight;
  final double cardWidth;
  final double imageRadius;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(fontFamily: SizeConfig.lang == 'en' ? Fonts.Allerta : Fonts.SFProMedium, color: textColor, fontSize: fontSize, letterSpacing: -0.065 * fontSize, height: 31 / fontSize),
        ),
        SizedBox(height: 14.h),
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listOfArticles.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  index != 0 ? SizedBox(height: 21.h) : Container(),
                  GestureDetector(
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                ExtendedImage.network(
                                  listOfArticles[index].coverImg,
                                  cache: true,
                                  fit: BoxFit.cover,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.all(Radius.circular(imageRadius)),
                                  height: cardHeight.h,
                                  width: cardWidth.h,
                                ),
                                BlocBuilder<AppPurchase, AppPurchaseState>(builder: (context, state) {
                                  if (state is AppPurchaseCurrentStatus)
                                    return Visibility(
                                      visible: listOfArticles[index].isPaid == 1,
                                      child: Visibility(
                                        visible: !state.status,
                                        child: Container(
                                          height: 19.h,
                                          width: 16.w,
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
                            SizedBox(
                              width: 20.w,
                            ),
                            Container(
                              width: SizeConfig.screenWidth - 128.w,
                              child: Container(
                                child: Text(
                                  listOfArticles[index].title,
                                  maxLines: 2,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontFamily: Fonts.HindGunturMedium,
                                    color: textColor,
                                    height: 1.4,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      Analytics().sendEventReports(event: 'article_show', attr: {'id': listOfArticles[index].id, 'name': listOfArticles[index].title});
                      bool isAppPurchase = BlocProvider.of<AppPurchase>(context).isAppPurchase;
                      if (listOfArticles[index].isPaid == 1) {
                        if (isAppPurchase) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ArticleDetailsScreen(
                                articleId: listOfArticles[index].id,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubscribeScreen(isFromSplash: false),
                            ),
                          );
                        }
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ArticleDetailsScreen(
                              articleId: listOfArticles[index].id,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  index != listOfArticles.length - 1 ? SizedBox(height: 19.h) : Container(),
                  index != listOfArticles.length - 1 ? Container(height: 1.h, width: Layout.width.toDouble(), color: kArticlesDividerColor) : Container(),
                ],
              );
            }),
      ],
    );
  }
}
