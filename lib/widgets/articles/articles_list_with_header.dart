import 'package:auto_size_text/auto_size_text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/config_const.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_articles_model.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/screens/arcticle_details_screen.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';

class ArticlesListWithHeader extends StatelessWidget {
  const ArticlesListWithHeader(
      {Key key, this.title, this.listOfArticles, this.textColor = kArticlesHeaderTextColor, this.fontSize = 24, this.cardHeight = 50, this.cardWidth = 50, this.imageRadius = 8})
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
    double width = SizeConfig.screenWidth;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: Fonts.AllertaRegular,
            color: textColor,
            fontSize: fontSize / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
            letterSpacing: -0.065 * fontSize / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
          ),
        ),
        SizedBox(height: 14),
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: listOfArticles.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  index != 0 ? SizedBox(height: 21 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical) : Container(),
                  InkWell(
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            // index == 0 ? SizedBox(width: 22) : SizedBox(width: 7.5),
                            Container(
                              height: cardHeight / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                              child: Row(
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
                                      ),
                                      Visibility(
                                        // ignore: null_aware_in_logical_operator
                                        visible: listOfArticles[index].isPaid == 1 ? true : false,
                                        child: Container(
                                            height: SizeConfig.blockSizeVertical * 5,
                                            width: SizeConfig.blockSizeVertical * 5,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('assets/new_lock.png'),
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          child: AutoSizeText(listOfArticles[index].title.length < 60 ? listOfArticles[index].title : '${listOfArticles[index].title.substring(0, 60)}...',
                                              style: TextStyle(
                                                fontFamily: Fonts.HindGuntur,
                                                color: textColor,
                                                height: 1.4 * 14 / Layout.width * Layout.multiplier * SizeConfig.blockSizeHorizontal > 20 ? 1.4 : 1,
                                                fontSize: 14 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          width: SizeConfig.screenWidth * 0.7),
                                      Visibility(
                                        child: Text('${listOfArticles[index].repliesCount} ${AppLocalizations.of(context).translate('comments')}',
                                            style: TextStyle(
                                              color: ArticlesColors.GreyColor,
                                              fontSize: 12 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical,
                                            )),
                                        visible: isCommentsEnabled,
                                      ),
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      Analytics().sendEventReports(event: 'article_show', attr: {'id': listOfArticles[index].id, 'name': listOfArticles[index].title});
                      bool isAppPurchase = Provider.of<SubscribeData>(context, listen: false).isAppPurchase;
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
                  index != listOfArticles.length - 1 ? SizedBox(height: 19 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical) : Container(),
                  index != listOfArticles.length - 1 ? Container(height: 1, width: width, color: kArticlesDividerColor) : Container(),
                ],
              );
            }),
      ],
    );
  }
}
