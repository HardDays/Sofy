import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/models/api_article_articles_model.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/PageProvider.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/screens/subscribe_screen.dart';
import 'package:sofy_new/widgets/playlist_lead_widget.dart';

import '../rest_api.dart';
import 'arcticle_details_screen.dart';

class ArticlesCategoriesDetailsScreen extends StatefulWidget {
  final String screenTitle;
  final int categoryId;

  ArticlesCategoriesDetailsScreen(
      {Key key, @required this.screenTitle, @required this.categoryId})
      : super(key: key);

  @override
  _ArticlesCategoriesDetailsScreen createState() =>
      _ArticlesCategoriesDetailsScreen();
}

class _ArticlesCategoriesDetailsScreen
    extends State<ArticlesCategoriesDetailsScreen> {
  List<ApiArticlesModel> articlesList = new List<ApiArticlesModel>();

  @override
  void initState() {
    super.initState();
    /*Analytics().sendEventReports(
      event: settings_screen_show,
    );*/
    getArticles();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    PCProvider pcProvider = Provider.of<PCProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: kLinearGradResultColor,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 0.0, right: 0.0, top: height / 20.83),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: width,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            borderRadius: BorderRadius.circular(60),
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            radius: 25,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 50.0,
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Container(
                                      child: SvgPicture.asset(
                                        'assets/svg/back_vector.svg',
                                        color: kNavigBarInactiveColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(bottom: height / 179.2),
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.screenTitle,
                                    style: TextStyle(
                                        fontFamily: kFontFamilyExo2,
                                        fontWeight: FontWeight.bold,
                                        fontSize: height / 37.3, //24
                                        color: kNavigBarInactiveColor),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            }),
                      )),
                  Expanded(
                    child: GridView.count(
                      childAspectRatio: 0.85,
                      physics: BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: height / 44.8,
                          bottom: height / 44.8),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: List<Widget>.generate(
                        articlesList.length,
                        (index) {
                          return Stack(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    height: height,
                                    width: width,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      child: PlayListLeadWidget(
                                        url: articlesList[index].coverImg,
                                        created:
                                            articlesList[index].dateCreated,
                                        height: height,
                                        width: width,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: height / 12.45,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                        child: Container(
                                          child: BackdropFilter(
                                            child: Container(
                                              color:
                                                  kArticlesWhiteColor.withOpacity(0.0),
                                            ),
                                            filter: ImageFilter.blur(
                                                sigmaX: 2.0, sigmaY: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: height,
                                    width: width,
                                    margin: EdgeInsets.only(bottom: 9),
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: height / 15.67,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13.0),
                                        child: Text(
                                          articlesList[index].title,
                                          textAlign: TextAlign.left,
                                          maxLines: 4,
                                          style: TextStyle(
                                              fontFamily: kFontFamilyGilroyBold,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                              fontSize: height / 64.0,
                                              color: kArticlesWhiteColor,
                                              height: 1.37),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                  // ignore: null_aware_in_logical_operator
                                  visible: articlesList[index].isPaid == 1
                                      ? true
                                      : false,
                                  child: Container(
                                    height: Provider.of<SubscribeData>(context)
                                            .isAppPurchase
                                        ? 0.0
                                        : height,
                                    width: Provider.of<SubscribeData>(context)
                                            .isAppPurchase
                                        ? 0.0
                                        : width,
                                    decoration: BoxDecoration(
                                      //color: Color(0x75C4C4C4),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    alignment: Alignment.topRight,
                                    child: Container(
                                        height: height / 12.6,
                                        width: height / 12.6,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/new_lock.png'),
                                            fit: BoxFit.fill,
                                          ),
                                        )),
                                  )),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    radius: 12,
                                    onTap: () {
                                      bool isAppPurchase =
                                          Provider.of<SubscribeData>(context,
                                                  listen: false)
                                              .isAppPurchase;
                                      if (articlesList[index].isPaid == 1) {
                                        if (isAppPurchase) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      ArticlesDetailsScreen(
                                                          articleId:
                                                              articlesList[
                                                                      index]
                                                                  .id
                                                                  .toString())));
                                          /*Analytics().sendEventReports(
                                              event: vibration_play,
                                              attr: {'vibration_id': playlistData.getCurrentPlaylistModel(context).created,
                                                'playlist_id': Provider.of<PlaylistNameData>(context, listen: false).getCurrentPlaylistName().name,
                                                'source': 'playlist_' + Provider.of<PlaylistNameData>(context, listen: false).getCurrentName() + '_screen',
                                              },
                                            );*/
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SubscribeScreen(
                                                      isFromSplash: false),
                                            ),
                                          );
                                        }
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ArticlesDetailsScreen(
                                              articleId: articlesList[index]
                                                  .id
                                                  .toString(),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getArticles() async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi()
        .getArticles(context, widget.categoryId, token: userToken)
        .then((values) {
      setState(() {
        articlesList = values;
      });
    });
  }
}

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(opacity: animation, child: child);
  }
}
