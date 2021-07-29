import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sofy_new/app_purchase.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/models/api_article_articles_model.dart';
import 'package:sofy_new/screens/arcticle_details_screen.dart';
import 'package:sofy_new/screens/bloc/analytics.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:sofy_new/widgets/articles/article_card.dart';
import 'package:sofy_new/widgets/articles/header_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardsHorizontalList extends StatefulWidget {
  CardsHorizontalList(
      {Key key,
      this.lineHeight = 1,
      this.frozenCardTextColor,
      this.listOfArticles,
      this.callback,
      this.title = '',
      this.cardHeight,
      this.cardRadius,
      this.cardWidth,
      this.frozenCardFontSize,
      this.frozenCardHeight,
      this.titleFontSize,this.l,this.t,this.r,this.b,})
      : super(key: key);
  final List<ApiArticlesModel> listOfArticles;
  final double cardHeight;
  final double cardWidth;
  final double frozenCardHeight;
  final double frozenCardFontSize;
  final double l;
  final double t;
  final double r;
  final double b;
  final Color frozenCardTextColor;
  final double lineHeight;
  final double cardRadius;
  final String title;
  final VoidCallback callback;
  final double titleFontSize;

  @override
  _CardsHorizontalListState createState() => _CardsHorizontalListState();
}

class _CardsHorizontalListState extends State<CardsHorizontalList>  with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        widget.title == ''
            ? Container()
            : Container(
                padding: EdgeInsets.fromLTRB(
                  widget.l,widget.t,widget.r,widget.b
                ),
                child: HeaderButton(
                  text: widget.title,
                  callback: widget.callback,
                  fontSize: widget.titleFontSize,
                  textColor: kArticlesHeaderTextColor,
                ),
              ),
        Container(
          height: widget.cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.listOfArticles.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  index == 0
                      ? SizedBox(width: 22.w)
                      : SizedBox(width: 7.5.w),
                  ArticleCard(
                    title: widget.listOfArticles[index].title,
                    path: widget.listOfArticles[index].coverImg,
                    height: widget.cardHeight,
                    width: widget.cardWidth,
                    frozenHeight: widget.frozenCardHeight,
                    fontSize: widget.frozenCardFontSize,
                    textColor: widget.frozenCardTextColor,
                    radius: widget.cardRadius,
                    isPaid: widget.listOfArticles[index].isPaid,
                    lineHeight: widget.lineHeight,
                    callback: () async {
                      bool isAppPurchase = BlocProvider.of<AppPurchase>(context).isAppPurchase;
                      if (widget.listOfArticles[index].isPaid == 1) {
                        if (isAppPurchase) {
                          Analytics().sendEventReports(
                            event: EventsOfAnalytics.article_show,
                            attr: {"name": widget.listOfArticles[index].title, 'id': widget.listOfArticles[index].id},
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ArticleDetailsScreen(
                                articleId: widget.listOfArticles[index].id,
                              ),
                            ),
                          );
                        } else {
                          Analytics().sendEventReports(event: EventsOfAnalytics.splash_show, attr: {
                            "name": widget.listOfArticles[index].title,
                            'id': widget.listOfArticles[index].id,
                            'source': 'onboarding/speed_change/modes_screen/settings_screen',
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubscribeScreen(isFromSplash: false),
                            ),
                          );
                        }
                      } else {
                        Analytics().sendEventReports(event: EventsOfAnalytics.article_show, attr: {
                          "name": widget.listOfArticles[index].title,
                          'id': widget.listOfArticles[index].id,
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => ArticleDetailsScreen(
                              articleId: widget.listOfArticles[index].id,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  index == widget.listOfArticles.length - 1
                      ? SizedBox(width: 22.w)
                      : SizedBox(width: 7.5.w),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
