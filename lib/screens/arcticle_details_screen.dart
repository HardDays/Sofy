import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/models/api_article_model.dart';
import 'package:sofy_new/models/api_article_poll_model.dart';
import 'package:sofy_new/models/api_article_replies.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:flutter_simple_rating_bar/flutter_simple_rating_bar.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/providers/user.dart';
import 'package:sofy_new/widgets/neumorph_button.dart';
import 'package:sofy_new/widgets/neumorphic/neumorphic_button.dart';

import '../rest_api.dart';
import 'article_answer_screen.dart';
import 'article_answers_stories_screen.dart';
import 'bloc/analytics.dart';
import 'bloc/setting_bloc.dart';

// ignore: must_be_immutable
class ArticlesDetailsScreen extends StatefulWidget {
  final String articleId;

  ArticlesDetailsScreen({Key key, @required this.articleId}) : super(key: key);

  @override
  _ArticlesDetailsScreenState createState() => _ArticlesDetailsScreenState();
}

class _ArticlesDetailsScreenState extends State<ArticlesDetailsScreen> {
  double height, width;

  int pollId;
  bool isVote = false;
  int rating = -1;
  final scroll = ValueNotifier<double>(0);
  int answersCount = 0;

  final dataKeyQuestions = new GlobalKey();
  final dataKeyComments = new GlobalKey();

  final SettingBloc _bloc = SettingBloc();

  Color appBar = Colors.transparent;
  Color shareButton = Colors.white;
  Color backButton = Colors.white;
  Color textColor = Colors.transparent;
  Color dividerColor = Colors.transparent;
  ApiArticlePollModel apiArticlePollModel;

  String answersButtonTitle;

  ApiArticleModel article;
  bool isLoading = true;
  TextEditingController replyController = new TextEditingController();

  List<Reply> articleReplies = new List<Reply>();
  String sortValue;

  @override
  void initState() {
    /*Analytics().sendEventReports(
      event: modes_screen_show,
    );*/
    getArticleDetails(widget.articleId);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    answersButtonTitle = AppLocalizations.of(context).translate('show_answers');
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: kMainScreenScaffoldBackColor,
        body: AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            child: isLoading
                ? Stack(
                    children: [
                      SizedBox(
                          width: width,
                          height: height / 2.16,
                          child: Shimmer.fromColors(
                            baseColor: Color(0xFFE0E0E0),
                            highlightColor: kAppPinkDarkColor,
                            direction: ShimmerDirection.ltr,
                            period: Duration(seconds: 2),
                            child: Container(
                              width: height / 4.1,
                              height: height / 3.65,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                            ),
                          )),
                      Container(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, top: height / 1.905),
                        child: SizedBox(
                            child: Shimmer.fromColors(
                          baseColor: Color(0xFFE0E0E0),
                          highlightColor: kAppPinkDarkColor,
                          direction: ShimmerDirection.ltr,
                          period: Duration(seconds: 2),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      height: 10,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      height: 12,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                      ),
                    ],
                  )
                : Stack(
                    children: <Widget>[
                      NotificationListener<ScrollNotification>(
                        onNotification: scrollListener,
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Stack(children: [
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: height / 2.16,
                                  padding:
                                      EdgeInsets.only(left: 0.0, bottom: 0.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Image.asset(
                                      'assets/player_placeholder.png',
                                      fit: BoxFit.cover,
                                    ),
                                    imageUrl: article.coverImg != null
                                        ? article.coverImg
                                        : 'assets/player_placeholder.png',
                                    fit: BoxFit.cover,
                                  )),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(
                                  top: height / 2.45,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFFDF3FF),
                                        Color(0xffF9EAF7)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(28.0),
                                      topRight: Radius.circular(28.0)),
                                ),
                                child: Column(children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height / 44.8,
                                          left: 20.0,
                                          right: 55.0),
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          article.title != null
                                              ? article.title
                                              : '',
                                          style: TextStyle(
                                              fontFamily: 'Exo 2',
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                              fontSize: height / 37.33,
                                              height: 1.35,
                                              color: Color(0xff38394F)),
                                        ),
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height / 40.72,
                                          left: width / 21,
                                          right: width / 21),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            NeumorphButton(
                                                width: width / 2.35,
                                                height: height,
                                                text:
                                                    AppLocalizations.of(context)
                                                        .translate('questions'),
                                                onTap: () {
                                                  Analytics().sendEventReports(
                                                      event:
                                                          go_to_stories_click,
                                                      attr: {
                                                        'article_name':
                                                            article.title,
                                                      });
                                                  Scrollable.ensureVisible(
                                                      dataKeyQuestions
                                                          .currentContext,
                                                      duration:
                                                          Duration(seconds: 2),
                                                      curve: Curves.ease);
                                                },
                                                iconLeft:
                                                    'assets/svg/article_questions.svg'),
                                            NeumorphButton(
                                                width: width / 2.35,
                                                height: height,
                                                text:
                                                    AppLocalizations.of(context)
                                                        .translate('comments'),
                                                onTap: () {
                                                  Analytics().sendEventReports(
                                                      event:
                                                          go_to_stories_click,
                                                      attr: {
                                                        'article_name':
                                                            article.title,
                                                      });
                                                  Scrollable.ensureVisible(
                                                      dataKeyComments
                                                          .currentContext,
                                                      duration:
                                                          Duration(seconds: 2),
                                                      curve: Curves.ease);
                                                  ;
                                                },
                                                iconLeft:
                                                    'assets/svg/article_comments.svg'),
                                          ])),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height / 37.33,
                                          left: 13.0,
                                          right: 13.0),
                                      child: Html(
                                        style: {
                                          "p": Style(
                                              wordSpacing: 5,
                                              lineHeight:
                                                  LineHeight.number(1.5),
                                              fontFamily: 'Montserrat',
                                              fontStyle: FontStyle.normal,
                                              fontSize:
                                                  FontSize(height / 57.73),
                                              color: Color(0xff2f2e41)),
                                          "strong": Style(
                                              wordSpacing: 5,
                                              lineHeight:
                                                  LineHeight.number(1.6),
                                              fontFamily: 'Montserrat Bold',
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.normal,
                                              fontSize: FontSize(height / 50.7),
                                              color: Color(0xff2f2e41)),
                                          "h1": Style(
                                              wordSpacing: 5,
                                              lineHeight:
                                                  LineHeight.number(1.6),
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.normal,
                                              fontSize: FontSize(height / 50.7),
                                              color: Color(0xff2f2e41)),
                                          "li": Style(
                                              wordSpacing: 5,
                                              lineHeight:
                                                  LineHeight.number(1.5),
                                              fontFamily: 'Montserrat',
                                              fontStyle: FontStyle.normal,
                                              fontSize:
                                                  FontSize(height / 57.73),
                                              color: Color(0xff2f2e41)),
                                          "u": Style(
                                              wordSpacing: 5,
                                              lineHeight:
                                                  LineHeight.number(1.5),
                                              fontFamily: 'Montserrat',
                                              fontStyle: FontStyle.normal,
                                              fontSize:
                                                  FontSize(height / 57.73),
                                              color: Color(0xff2f2e41)),
                                        },
                                        data: article.content != null
                                            ? article.content
                                            : '',
                                      )),
                                  /*Padding(
                      padding:
                          EdgeInsets.only(top: height / 37.33, left: 20.0, right: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                                    height: height / 12.44,
                                    width: 1.5,
                                    color: kAppPinkDarkColor)),
                            Padding(
                                padding: EdgeInsets.only(left: 14.0),
                                child: Container(
                                  width: width - 55.5,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'First of all, I definitely would not have thought\nI’d be a sex and relationship coach, exposing myself in the most intimate ways. Yet here I am.',
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.italic,
                                        fontSize: height / 56,
                                        height: 1.45,
                                        color: Color(0xff2f2e41)),
                                  ),
                                )),
                          ])),
                  Padding(
                      padding:
                          EdgeInsets.only(top: height / 44.8, left: 20.0, right: 20.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'So how did I get here? Well, life happened.',
                          style: TextStyle(
                              fontFamily: 'Gilroy Bold',
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontSize: height / 49.77,
                              height: 1.6,
                              color: Color(0xff2f2e41)),
                        ),
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(top: height / 44.8, left: 20.0, right: 20.0),
                      child: Container(
                        width: width - 40.0,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Along the way, I had quite a few significant experiences – some great, some not so great – all of which shaped who I am today. I reached midlife and wanted the second half to be better than the first, so I worked hard to understand and grow from these experiences.\n\nMy now coaching business began as a blog that served as both cathartic journaling and public service announcement. When I first started writing, I was in a long-term marriage seeing a sex and relationship coach. I was shocked how much sex education I had missed out on and wanted to share what I was learning so others struggling with sex could join me on a journey of self-discovery. ',
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontFamily: 'Gilroy',
                              height: 1.50,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: height / 56,
                              color: Color(0xff2f2e41)),
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: height / 35.84),
                      width: MediaQuery.of(context).size.width,
                      height: height / 3.5,
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Image.asset(
                          'assets/player_placeholder.png',
                          fit: BoxFit.cover,
                        ),
                        imageUrl:
                            'https://theplayroom.eu/wp-content/uploads/2020/05/the-play-room43.jpg',
                        fit: BoxFit.cover,
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(top: height / 29.86, left: 20.0, right: 47.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Along the way, my personal individual and couples therapy journey helped me:',
                          style: TextStyle(
                              fontFamily: 'Gilroy Bold',
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              height: 1.6,
                              fontSize: height / 49.77,
                              color: Color(0xff2f2e41)),
                        ),
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(top: height / 44.8, left: 20.0, right: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: height / 89.6),
                                width: 6.0,
                                height: 6.0,
                                decoration: new BoxDecoration(
                                  color: kAppPinkDarkColor,
                                  shape: BoxShape.circle,
                                )),
                            Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Container(
                                  width: width - 56.0,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Discover more about my physical and emotional needs',
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontSize: height / 56,
                                        height: 1.5,
                                        color: Color(0xff2f2e41)),
                                  ),
                                )),
                          ])),
                  Padding(
                      padding:
                          EdgeInsets.only(top: height / 49.77, left: 20.0, right: 20.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: height / 89.6),
                                width: 6.0,
                                height: 6.0,
                                decoration: new BoxDecoration(
                                  color: kAppPinkDarkColor,
                                  shape: BoxShape.circle,
                                )),
                            Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Container(
                                  width: width - 56.0,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Communicate those needs to my partner in a way that’s most likely to be heard',
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        fontFamily: 'Gilroy',
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontSize: height / 56,
                                        height: 1.5,
                                        color: Color(0xff2f2e41)),
                                  ),
                                )),
                          ])),
                  Padding(
                      padding:
                          EdgeInsets.only(top: height / 40.72, left: 20.0, right: 20.0),
                      child: Container(
                        width: width - 40.0,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ultimately, for me, this resulted in an amicable divorce and a new chapter in my life. So now, it’s time for a new chapter here. In addition to my personal stories about learning to access sexual desire, a topic I am still extremely passionate about, I will be sharing personal stories about exploring the emotional side of things, because this topic is equally as important and extremely fascinating.\n\nThe experiences you are having are normal. And if you want, and only if you want, you can learn and explore ways of having more pleasure, intimacy and connection. I hope this space and the additional services that I offer will be a way for you to get what you are looking for in love and in life.',
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              fontFamily: 'Gilroy',
                              height: 1.50,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: height / 56,
                              color: Color(0xff2f2e41))
                        ),
                      )),*/
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height / 22.4,
                                          left: 20.0,
                                          right: 20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 1.0,
                                                width: width / 3,
                                                color: Color(0x50edc3ed)),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(left: 21.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/article_votes.svg',
                                                color: Color(0xffEDC3ED),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 5.0, left: 5.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/article_votes.svg',
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 21.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/article_votes.svg',
                                                color: Color(0xffEDC3ED),
                                              ),
                                            ),
                                            Container(
                                                height: 1.0,
                                                width: width / 3,
                                                color: Color(0x50edc3ed)),
                                          ])),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height / 23.57,
                                          left: 20.0,
                                          right: 20.0),
                                      child: Container(
                                        width: width - 40.0,
                                        alignment: Alignment.center,
                                        child: Text(
                                          apiArticlePollModel != null
                                              ? article
                                                  .apiArticlePollModel.blockName
                                              : '',
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Montserrat Semi',
                                              height: 1.5,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                              fontSize: height / 52.70,
                                              color: Color(0xff2f2e41)),
                                        ),
                                      )),
                                  Visibility(
                                      visible: !isVote,
                                      child: Column(children: [
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.all(0.0),
                                            itemCount:
                                                apiArticlePollModel != null
                                                    ? apiArticlePollModel
                                                        .variants.length
                                                    : 0,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    top: height / 56,
                                                    left: 20.0,
                                                    right: 20.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    apiArticlePollModel
                                                            .variants[index]
                                                            .selected =
                                                        !article
                                                            .apiArticlePollModel
                                                            .variants[index]
                                                            .selected;
                                                    for (int i = 0;
                                                        i <
                                                            article
                                                                .apiArticlePollModel
                                                                .variants
                                                                .length;
                                                        i++) {
                                                      if (i != index) {
                                                        apiArticlePollModel
                                                            .variants[i]
                                                            .selected = false;
                                                      }
                                                    }
                                                    pollId = article
                                                        .apiArticlePollModel
                                                        .variants[index]
                                                        .id;
                                                    setState(() {});
                                                    //Analytics().sendEventReports(event: subscription_purchase_y_click);
                                                  },
                                                  child: Badge(
                                                    padding: EdgeInsets.all(3),
                                                    elevation: 0.0,
                                                    shape: BadgeShape.square,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                    child: Container(
                                                      height: height / 16,
                                                      padding: EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 16.0),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            kSettingInActiveButtonColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    13.0)),
                                                        border: Border.all(
                                                          color: article
                                                                  .apiArticlePollModel
                                                                  .variants[
                                                                      index]
                                                                  .selected
                                                              ? kAppPinkDarkColor
                                                              : Colors
                                                                  .transparent,
                                                          width: 1.3,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                              width:
                                                                  width / 1.33,
                                                              child: Text(
                                                                article
                                                                    .apiArticlePollModel
                                                                    .variants[
                                                                        index]
                                                                    .content,
                                                                maxLines: 2,
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kWelcomDarkTextColor,
                                                                  fontFamily:
                                                                      'Gilroy Bold',
                                                                  fontSize:
                                                                      height /
                                                                          56,
                                                                  height: 1.343,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                ),
                                                              )),
                                                          CircleAvatar(
                                                            radius: 10.0,
                                                            backgroundColor: article
                                                                    .apiArticlePollModel
                                                                    .variants[
                                                                        index]
                                                                    .selected
                                                                ? kAppPinkDarkColor
                                                                : Colors.white,
                                                            child: Icon(
                                                              Icons.check,
                                                              size: 14,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    showBadge: false,
                                                  ),
                                                ),
                                              );
                                            })
                                      ])),
                                  Visibility(
                                      visible: isVote,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.all(0.0),
                                          itemCount: apiArticlePollModel != null
                                              ? apiArticlePollModel
                                                  .variants.length
                                              : 0,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  top: height / 56,
                                                  left: 20.0,
                                                  right: 20.0),
                                              child: Badge(
                                                padding: EdgeInsets.all(3),
                                                elevation: 0.0,
                                                shape: BadgeShape.square,
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 20.0,
                                                      right: 16.0,
                                                      top: height / 72,
                                                      bottom: height / 72),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        kSettingInActiveButtonColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                13.0)),
                                                    border: Border.all(
                                                      color: Colors.transparent,
                                                      width: 1.3,
                                                    ),
                                                  ),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Container(
                                                              width:
                                                                  width / 1.5,
                                                              child: Text(
                                                                article
                                                                    .apiArticlePollModel
                                                                    .variants[
                                                                        index]
                                                                    .content,
                                                                maxLines: 2,
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kWelcomDarkTextColor,
                                                                  fontFamily:
                                                                      'Gilroy Bold',
                                                                  fontSize:
                                                                      height /
                                                                          56,
                                                                  height: 1.343,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                ),
                                                              ),
                                                            ),
                                                            /*Text(
                                                              article
                                                                      .apiArticlePollModel
                                                                      .variants[
                                                                          index]
                                                                      .answerCount
                                                                      .toString() +
                                                                  " " +
                                                                  AppLocalizations.of(
                                                                          context)
                                                                      .translate(
                                                                          'users'),
                                                              style: TextStyle(
                                                                color:
                                                                    kWelcomDarkTextColor,
                                                                fontFamily:
                                                                    'Gilroy',
                                                                fontSize:
                                                                    height /
                                                                        74.6,
                                                                height: 1.343,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                              ),
                                                            )*/
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            LinearPercentIndicator(
                                                                animation: true,
                                                                animationDuration:
                                                                    1500,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0.0),
                                                                width: height /
                                                                    3.01,
                                                                lineHeight: 5.0,
                                                                percent: article
                                                                        .apiArticlePollModel
                                                                        .variants[
                                                                            index]
                                                                        .percent /
                                                                    100,
                                                                backgroundColor:
                                                                    Color(
                                                                        0xffFFF5F9),
                                                                progressColor:
                                                                    Color(
                                                                        0xffFF96AD)),
                                                            Text(
                                                              article
                                                                      .apiArticlePollModel
                                                                      .variants[
                                                                          index]
                                                                      .percent
                                                                      .toString() +
                                                                  "%",
                                                              style: TextStyle(
                                                                color:
                                                                    kWelcomDarkTextColor,
                                                                fontFamily:
                                                                    'Gilroy',
                                                                fontSize:
                                                                    height /
                                                                        74.6,
                                                                height: 1.343,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ]),
                                                ),
                                                showBadge: false,
                                              ),
                                            );
                                          })),
                                  Container(
                                      decoration: BoxDecoration(boxShadow: [
                                        BoxShadow(
                                          color: Color(0xffC4C4C4),
                                          offset: Offset(3, 3),
                                          blurRadius: 10.0,
                                        ),
                                      ]),
                                      height: height / 18.66,
                                      margin: EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: height / 56),
                                      child: NeumorphicCustomButton(
                                          style: NeumorphicStyle(
                                              depth: !isVote ? 0 : -3,
                                              shape: NeumorphicShape.flat,
                                              intensity: 0.6,
                                              shadowLightColorEmboss:
                                                  Color(0xffFBE5FB),
                                              shadowDarkColor:
                                                  Color(0xffFBE5FB),
                                              shadowDarkColorEmboss:
                                                  Color(0xff663966),
                                              shadowLightColor: Colors.white,
                                              color: Color(0xffFCEFFC)),
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.circular(10)),
                                          provideHapticFeedback: false,
                                          onClick: () {
                                            Analytics().sendEventReports(
                                                event: reply_click,
                                                attr: {
                                                  'article_name': article.title,
                                                });
                                            setPoll(pollId);
                                          },
                                          padding: EdgeInsets.all(0.0),
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                height: height / 18.66,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    gradient:
                                                        new LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        const Color(0xFFFDB0C1),
                                                        const Color(0xFFFF95AC),
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                                child: !isVote
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        4.0),
                                                            child: Text(
                                                              article.apiArticlePollModel !=
                                                                      null
                                                                  ? article
                                                                      .apiArticlePollModel
                                                                      .buttonName
                                                                  : '',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Montserrat Bold',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                fontSize:
                                                                    height / 56,
                                                                //14
                                                                height: 1.7,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        4.0),
                                                            child: Text(
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .translate(
                                                                        'poll_sent'),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Montserrat Bold',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      height /
                                                                          56,
                                                                  //14
                                                                  height: 1.7,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                              ),
                                            ],
                                          ))),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height / 14.93,
                                          left: 20.0,
                                          right: 20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 1.0,
                                                width: width / 3,
                                                color: Color(0x50edc3ed)),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(left: 21.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/article_answers.svg',
                                                color: Color(0xffEDC3ED),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 2.0, left: 2.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/article_answers.svg',
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 21.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/article_answers.svg',
                                                color: Color(0xffEDC3ED),
                                              ),
                                            ),
                                            Container(
                                                height: 1.0,
                                                width: width / 3,
                                                color: Color(0x50edc3ed)),
                                          ])),
                                  article.apiArticleQuestionModel != null
                                      ? Padding(
                                          key: dataKeyQuestions,
                                          padding: EdgeInsets.only(
                                              top: height / 17.23,
                                              left: 62.0,
                                              right: 62.0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              article.apiArticleQuestionModel
                                                  .message,
                                              overflow: TextOverflow.clip,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat Semi',
                                                  height: 1.50,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: height / 52.70,
                                                  color: Color(0xff2f2e41)),
                                            ),
                                          ))
                                      : Container(),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            opaque: false,
                                            pageBuilder: (_, __, ___) =>
                                                ArticleAnswerScreen(
                                              articleId: widget.articleId,
                                              questionId: article
                                                  .apiArticleQuestionModel.id,
                                              articleTitle: article.title,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 15.0),
                                        child: Stack(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.only(
                                                    top: height / 25.6,
                                                    left: 20,
                                                    right: 20),
                                                child: Neumorphic(
                                                    style: NeumorphicStyle(
                                                        boxShape: NeumorphicBoxShape
                                                            .roundRect(
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        depth: 3,
                                                        intensity: 0.65,
                                                        shadowLightColorEmboss:
                                                            Colors.white,
                                                        shadowLightColor:
                                                            Colors.white,
                                                        shadowDarkColor:
                                                            Color(0xffdbc4db),
                                                        shadowDarkColorEmboss:
                                                            Color(0xffdbc4db),
                                                        shape: NeumorphicShape
                                                            .flat,
                                                        color:
                                                            Color(0xffFAEBF8)),
                                                    child: Container(
                                                        width: width,
                                                        height: height / 5.74))),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 0.0),
                                                child: Column(children: [
                                                  Container(
                                                      width: 75.0,
                                                      height: height / 11.94,
                                                      child: Image.asset(
                                                          'assets/answer_title_image.png')),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5.0,
                                                          left: 20.0,
                                                          right: 20.0),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  'share_answer'),
                                                          overflow:
                                                              TextOverflow.clip,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Montserrat Bold',
                                                              height: 1.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize:
                                                                  height / 56,
                                                              color: Color(
                                                                  0xff836771)),
                                                        ),
                                                      )),
                                                  Container(
                                                      height: height / 18.66,
                                                      margin: EdgeInsets.only(
                                                          top: height / 49.77,
                                                          left: 42.0,
                                                          right: 42.0),
                                                      child: Neumorphic(
                                                          style: NeumorphicStyle(
                                                              boxShape: NeumorphicBoxShape.roundRect(
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                              depth: 3,
                                                              intensity: 0.65,
                                                              shadowLightColorEmboss:
                                                                  Colors.white,
                                                              shadowLightColor:
                                                                  Colors.white,
                                                              shadowDarkColor:
                                                                  Color(
                                                                      0xffdbc4db),
                                                              shadowDarkColorEmboss:
                                                                  Color(
                                                                      0xffdbc4db),
                                                              shape:
                                                                  NeumorphicShape
                                                                      .flat,
                                                              color: Color(
                                                                  0xffF9D9F4)),
                                                          child: TextField(
                                                            enabled: false,
                                                            textAlign:
                                                                TextAlign.left,
                                                            textCapitalization:
                                                                TextCapitalization
                                                                    .characters,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Montserrat Semi',
                                                                fontSize:
                                                                    height /
                                                                        48.33,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color(
                                                                    0xff836771)),
                                                            decoration:
                                                                InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      left:
                                                                          16.0,
                                                                      bottom:
                                                                          7.0),
                                                              hintStyle: TextStyle(
                                                                  fontFamily:
                                                                      'Montserrat Semi',
                                                                  fontSize:
                                                                      height /
                                                                          64,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Color(
                                                                      0x50836771)),
                                                              hintText: AppLocalizations
                                                                      .of(
                                                                          context)
                                                                  .translate(
                                                                      'answer_hint'),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                          )))
                                                ])),
                                          ],
                                        ),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: height / 40.72),
                                      child: NeumorphButton(
                                          width: width / 1.11,
                                          height: height,
                                          text: answersButtonTitle,
                                          onTap: () {
                                            Analytics().sendEventReports(
                                                event: show_stories,
                                                attr: {
                                                  'article_name': article.title,
                                                });
                                            if (answersCount > 0) {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      ArticleAnswersStoriesScreen(
                                                          articleId:
                                                              widget.articleId,
                                                          coverUrl: article
                                                              .apiArticleQuestionModel
                                                              .coverImg,
                                                          question: article
                                                              .apiArticleQuestionModel
                                                              .message)));
                                            } else {
                                              setState(() {
                                                answersButtonTitle =
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'no_answers');
                                              });
                                            }
                                          },
                                          iconRight: answersCount > 0
                                              ? 'assets/svg/article_show_answers.svg'
                                              : null)),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height / 14.93,
                                          left: 20.0,
                                          right: 20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 1.0,
                                                width: width / 3,
                                                color: Color(0x50edc3ed)),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(left: 21.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/article_star.svg',
                                                color: Color(0xffEDC3ED),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 5.0, left: 5.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/article_star.svg',
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 21.0),
                                              child: SvgPicture.asset(
                                                'assets/svg/article_star.svg',
                                                color: Color(0xffEDC3ED),
                                              ),
                                            ),
                                            Container(
                                                height: 1.0,
                                                width: width / 3,
                                                color: Color(0x50edc3ed)),
                                          ])),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height / 16.29,
                                          left: 20.0,
                                          right: 20.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppLocalizations.of(context).translate('do_you_like_this_article'),
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Montserrat Semi',
                                              height: 1.5,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                              fontSize: height / 52.7,
                                              color: Color(0xff38394F)),
                                        ),
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height / 44.8,
                                          left: 20.0,
                                          right: 20.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppLocalizations.of(context).translate('please_rate_this_article'),
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              height: 1.5,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FontStyle.normal,
                                              fontSize: height / 59.73,
                                              color: Color(0xff38394F)),
                                        ),
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: height / 29.86,
                                          left: 20.0,
                                          right: 20.0),
                                      child: RatingBar(
                                        rating: rating == -1
                                            ? 0.0
                                            : rating.toDouble(),
                                        icon: Icon(Icons.star_border,
                                            size: height / 40.72,
                                            color: Color(0xffEDC3ED)),
                                        starCount: 10,
                                        spacing: 5.0,
                                        size: height / 40.72,
                                        isIndicator:
                                            rating != -1 ? true : false,
                                        allowHalfRating: false,
                                        onRatingCallback: (double value,
                                            ValueNotifier<bool> isIndicator) {
                                          rating = value.round();
                                        },
                                        color: Color(0xffE0347A),
                                      )),
                                  rating != -1
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              top: height / 29.86,
                                              left: 20.0,
                                              right: 20.0),
                                          child: Badge(
                                            padding: EdgeInsets.all(3),
                                            elevation: 0.0,
                                            shape: BadgeShape.square,
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            child: Container(
                                              height: height / 16,
                                              padding: EdgeInsets.only(
                                                  left: 20.0, right: 16.0),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color:
                                                      kSettingInActiveButtonColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              13.0))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    'Thank you for your answer! It’s important to us 💓', // todo
                                                    style: TextStyle(
                                                      color:
                                                          kWelcomDarkTextColor,
                                                      fontFamily: 'Gilroy Bold',
                                                      fontSize: height / 59.73,
                                                      height: 1.343,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            showBadge: false,
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(
                                              left: 20.0,
                                              right: 20.0,
                                              top: height / 37.33),
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                height: height / 17.23,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 4.0),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate('done'),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat Bold',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: height / 56,
                                                          height: 1.9,
                                                          color:
                                                              Color(0xFFE0347A),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned.fill(
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                      highlightColor:
                                                          Colors.transparent,
                                                      splashColor:
                                                          kAppPinkDarkColor
                                                              .withOpacity(
                                                                  0.20),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                      onTap: () {
                                                        setRating();
                                                        Analytics()
                                                            .sendEventReports(
                                                                event:
                                                                    articles_feedback,
                                                                attr: {
                                                              'article_name':
                                                                  article.title,
                                                            });
                                                      }),
                                                ),
                                              ),
                                            ],
                                          )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        /*top: height / 14.45;*/
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: height / 11.2,
                                              height: height / 23.57,
                                              /*child: Neumorphic(
                                            style: NeumorphicStyle(
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            28)),
                                                depth: 3,
                                                intensity: 0.65,
                                                shadowLightColorEmboss:
                                                    Colors.white,
                                                shadowLightColor: Colors.white,
                                                shadowDarkColor:
                                                    Color(0xffdbc4db),
                                                shadowDarkColorEmboss:
                                                    Color(0xffdbc4db),
                                                shape: NeumorphicShape.flat,
                                                color: Color(0xffFDF3FF)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      right: 7.5),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/article_likes.svg',
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 0.0),
                                                  child: Text(
                                                    '324',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Gilroy',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: height / 68.92,
                                                      height: 1.5,
                                                      color: Color(0xFF2F2E41),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ))*/
                                            ),
                                            /*Container(
                                              width: height / 11.2,
                                              height: height / 23.57,
                                              margin:
                                                  EdgeInsets.only(right: 27.0),
                                              child: Neumorphic(
                                            style: NeumorphicStyle(
                                                boxShape: NeumorphicBoxShape
                                                    .roundRect(
                                                        BorderRadius.circular(
                                                            28)),
                                                depth: 3,
                                                intensity: 0.65,
                                                shadowLightColorEmboss:
                                                    Colors.white,
                                                shadowLightColor: Colors.white,
                                                shadowDarkColor:
                                                    Color(0xffdbc4db),
                                                shadowDarkColorEmboss:
                                                    Color(0xffdbc4db),
                                                shape: NeumorphicShape.flat,
                                                color: Color(0xffFDF3FF)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      right: 7.5),
                                                  child: SvgPicture.asset(
                                                    'assets/svg/article_comments.svg',
                                                    color: Color(0xFF2F2E41),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 0.0),
                                                  child: Text(
                                                    '167',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Gilroy',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: height / 68.92,
                                                      //14
                                                      height: 1.5,
                                                      color: Color(0xFF2F2E41),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ))
                                            ),*/
                                            /*GestureDetector(
                                      child: Container(
                                          width: height / 17.23,
                                          height: height / 23.57,
                                          margin: EdgeInsets.only(bottom: height / 30),
                                          child: Neumorphic(
                                              style: NeumorphicStyle(
                                                  boxShape: NeumorphicBoxShape
                                                      .roundRect(
                                                          BorderRadius.circular(
                                                              28)),
                                                  depth: 3,
                                                  intensity: 0.65,
                                                  shadowLightColorEmboss:
                                                      Colors.white,
                                                  shadowLightColor:
                                                      Colors.white,
                                                  shadowDarkColor:
                                                      Color(0xffdbc4db),
                                                  shadowDarkColorEmboss:
                                                      Color(0xffdbc4db),
                                                  shape: NeumorphicShape.flat,
                                                  color: Color(0xffFDF3FF)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    alignment: Alignment.center,
                                                    child: SvgPicture.asset(
                                                      'assets/svg/article_share.svg',
                                                      color: Color(0xFF2F2E41),
                                                    ),
                                                  ),
                                                ],
                                              ))),
                                      onTap: () {
                                        _bloc.shareArticle(widget.article.title, context: context);
                                      }
                                    )*/
                                          ])),
                                  Container(
                                      key: dataKeyComments,
                                      height: 1.0,
                                      width: width,
                                      margin: EdgeInsets.only(
                                          bottom: height / 35.84,
                                          top: height / 44.8,
                                          right: 20.0,
                                          left: 20.0),
                                      color: Color(0x40fdb0c1)),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 4.0),
                                              child: Text(
                                                articleReplies.length
                                                        .toString() +
                                                    " " +
                                                    AppLocalizations.of(context)
                                                        .translate('comments'),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Gilroy Bold',
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: height / 68.92,
                                                  //14
                                                  height: 1.6,
                                                  color: Color(0xFF2F2E41),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 4.0),
                                              child: DropdownButton<String>(
                                                  icon: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 7.0),
                                                    alignment: Alignment.center,
                                                    child: SvgPicture.asset(
                                                      'assets/svg/article_comments_sort.svg',
                                                    ),
                                                  ),
                                                  hint: Text(
                                                    sortValue == null
                                                        ? AppLocalizations.of(
                                                                context)
                                                            .translate('by_new')
                                                        : sortValue,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Gilroy',
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: height / 68.92,
                                                      //14
                                                      height: 1.5,
                                                      color: Color(0xFF2F2E41),
                                                    ),
                                                  ),
                                                  underline: Container(),
                                                  items: <String>[
                                                    AppLocalizations.of(context)
                                                        .translate('by_new'),
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'by_popular'),
                                                    AppLocalizations.of(context)
                                                        .translate('by_old'),
                                                  ].map((String value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Gilroy',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize:
                                                                height / 68.92,
                                                            //14
                                                            height: 1.5,
                                                            color: Color(
                                                                0xFF2F2E41),
                                                          ),
                                                        ));
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      sortValue = value;
                                                    });
                                                    getArticleReplies(
                                                        widget.articleId, null);
                                                  }),
                                            )
                                          ])),
                                  ListView.builder(
                                      itemCount: articleReplies.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.all(0.0),
                                      itemBuilder: (context, index) => Padding(
                                          padding: EdgeInsets.only(
                                              top: height / 52.7,
                                              left: 20.0,
                                              right: 20.0),
                                          child: Column(children: [
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      width: height / 27.15,
                                                      height: height / 27.15,
                                                      margin: EdgeInsets.only(
                                                          right: 12.0),
                                                      decoration: new BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20.0)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Color(
                                                                  0xffCFB2CD),
                                                              spreadRadius: 4,
                                                              blurRadius: 10,
                                                              offset: Offset(0,
                                                                  3), // changes position of shadow
                                                            ),
                                                          ]),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                          child:
                                                              CachedNetworkImage(
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Image.asset(
                                                              'assets/player_placeholder.png',
                                                              fit: BoxFit.cover,
                                                            ),
                                                            imageUrl: articleReplies[
                                                                        index]
                                                                    .coverImg ??
                                                                '',
                                                            fit: BoxFit.cover,
                                                          ))),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      articleReplies[index]
                                                              .userName
                                                              .contains(
                                                                  'Anonim')
                                                          ? Container()
                                                          : Container(
                                                              child: Text(
                                                                articleReplies[
                                                                        index]
                                                                    .userName,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Gilroy Bold',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      height /
                                                                          81.45,
                                                                  height: 1.305,
                                                                  color: Color(
                                                                      0xFF2F2E41),
                                                                ),
                                                              ),
                                                            ),
                                                      Container(
                                                        child: Text(
                                                          articleReplies[index]
                                                              .content,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Gilroy',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontSize:
                                                                height / 74.66,
                                                            height: 1.305,
                                                            color: Color(
                                                                0xFF2F2E41),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 3.0, left: 37.0),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(children: [
                                                        Container(
                                                          child: Text(
                                                            displayTimeAgoFromTimestamp(
                                                                articleReplies[
                                                                        index]
                                                                    .dateCreated,
                                                                context),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Gilroy',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: height /
                                                                  81.45,
                                                              height: 1.305,
                                                              color: Color(
                                                                  0xFFA9A8C1),
                                                            ),
                                                          ),
                                                        ),
                                                        /*Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 11.0),
                                                          child: Text(
                                                            'Reply',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Gilroy Bold',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: height /
                                                                  81.45,
                                                              height: 1.305,
                                                              color: Color(
                                                                  0xFFE0347A),
                                                            ),
                                                          ),
                                                        ),*/
                                                      ]),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            GestureDetector(
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            6.0),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  articleReplies[index]
                                                                              .isLiked ==
                                                                          '0'
                                                                      ? 'assets/svg/article_likes.svg'
                                                                      : 'assets/svg/article_likes_liked.svg',
                                                                  color: Color(
                                                                      0xff2F2E41),
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                print(articleReplies[
                                                                        index]
                                                                    .isLiked);
                                                                likeReply(int.parse(
                                                                    articleReplies[
                                                                            index]
                                                                        .id));
                                                              },
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          0.0),
                                                              child: Text(
                                                                articleReplies[
                                                                        index]
                                                                    .likesCount,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Gilroy',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                  fontSize:
                                                                      height /
                                                                          68.92,
                                                                  height: 1.5,
                                                                  color: Color(
                                                                      0xFF2F2E41),
                                                                ),
                                                              ),
                                                            ),
                                                          ])
                                                    ]))
                                          ]))),
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xffFAEBF8),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25.0),
                                            topRight: Radius.circular(25.0)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xffFFBFCD)
                                                .withOpacity(0.5),
                                            offset: Offset(7, 7),
                                            blurRadius: 10.0,
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                          top: height / 44.8,
                                          bottom: height / 23.57),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                width: width / 1.3,
                                                height: height / 21.33,
                                                child: Neumorphic(
                                                    style: NeumorphicStyle(
                                                        boxShape:
                                                            NeumorphicBoxShape
                                                                .roundRect(
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                        depth: 3,
                                                        intensity: 0.65,
                                                        shadowLightColorEmboss:
                                                            Colors.white,
                                                        shape: NeumorphicShape
                                                            .flat,
                                                        color:
                                                            Color(0xffF9D9F4)),
                                                    child: TextField(
                                                      controller:
                                                          replyController,
                                                      textAlign: TextAlign.left,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .sentences,
                                                      style: TextStyle(
                                                          fontFamily: 'Gilroy',
                                                          fontSize: height / 64,
                                                          height: 1.4,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Color(
                                                              0xff836771)),
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                left: 15.0,
                                                                bottom: 12.0),
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                'Gilroy',
                                                            fontSize:
                                                                height / 64,
                                                            height: 1.4,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Color(
                                                                0x50836771)),
                                                        hintText:
                                                            AppLocalizations.of(
                                                                    context)
                                                                .translate(
                                                                    'comments'),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                    ))),
                                            GestureDetector(
                                              child: Container(
                                                  color: Color(0xffFAEBF8),
                                                  width: height / 21.33,
                                                  height: height / 21.33,
                                                  child: Neumorphic(
                                                      style: NeumorphicStyle(
                                                          boxShape: NeumorphicBoxShape
                                                              .roundRect(
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          depth: 3,
                                                          intensity: 0.65,
                                                          shadowLightColorEmboss:
                                                              Colors.white,
                                                          shape: NeumorphicShape
                                                              .flat,
                                                          color: Color(
                                                              0xffE0347A)),
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            right: 6.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: SvgPicture.asset(
                                                            'assets/svg/article_send_comment.svg'),
                                                      ))),
                                              onTap: () {
                                                if (replyController
                                                        .text.length >
                                                    0) {
                                                  sendReply(
                                                      replyController.text,
                                                      '0');
                                                  replyController.text = '';
                                                }
                                              },
                                            )
                                          ]))
                                ]),
                              ),
                            ]),
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                          valueListenable: scroll,
                          builder: (_, value, __) => AnimatedContainer(
                              height: height / 9.61,
                              padding: EdgeInsets.only(top: height / 40.66),
                              color: appBar,
                              duration: Duration(milliseconds: 350),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Align(
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  width: 75.0,
                                                  child: SvgPicture.asset(
                                                    'assets/svg/back_vector.svg',
                                                    color: backButton,
                                                    height: height / 40.33,
                                                  ),
                                                ),
                                                Positioned.fill(
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                        focusColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        splashColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60),
                                                        radius: 25,
                                                        onTap: () {
                                                          //Analytics().sendEventReports(event: subscription_splash_close_click);
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            Expanded(
                                                child: AnimatedOpacity(
                                                    duration: Duration(
                                                        milliseconds: 350),
                                                    opacity: textColor ==
                                                            Colors.transparent
                                                        ? 0.0
                                                        : 1.0,
                                                    curve: Curves.fastOutSlowIn,
                                                    child: Container(
                                                        child: Text(
                                                      article.title != null
                                                          ? article.title
                                                          : '',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat Semi',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize:
                                                              height / 59.73,
                                                          color: Color(
                                                              0xff38394F)),
                                                    )))),
                                            Container(
                                                child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  width: 75.0,
                                                  child: SvgPicture.asset(
                                                    'assets/svg/article_share.svg',
                                                    color: shareButton,
                                                    height: height / 37.33,
                                                  ),
                                                ),
                                                Positioned.fill(
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                        focusColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        splashColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60),
                                                        radius: 25,
                                                        onTap: () {
                                                          Analytics()
                                                              .sendEventReports(
                                                                  event:
                                                                      share_article_click,
                                                                  attr: {
                                                                'article_name':
                                                                    article
                                                                        .title,
                                                              });
                                                          _bloc.shareArticle(
                                                              article.title,
                                                              context: context);
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            )),
                                          ]),
                                      alignment: Alignment.center),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: height / 298.6,
                                        color: dividerColor,
                                        child: LinearProgressIndicator(
                                          backgroundColor: dividerColor,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Color(0xffFEA9BC)),
                                          value: scroll.value,
                                        ),
                                      ))
                                ],
                              )))
                    ],
                  )));
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  bool scrollListener(ScrollNotification scrollNotification) {
    scroll.value = scrollNotification.metrics.pixels /
        (height * MediaQuery.of(context).devicePixelRatio);
    //print(scroll);
    if (scrollNotification.metrics.pixels > height / 8.21) {
      if (appBar == Colors.transparent) {
        appBar = Color(0xffFCEFFC);
        shareButton = Color(0xff38394F);
        backButton = Color(0xff38394F);
        dividerColor = Color(0xffFEA9BC).withOpacity(0.15);
        Future.delayed(Duration(milliseconds: 100), () {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        });
      }
    } else {
      if (appBar == Color(0xffFCEFFC)) {
        Future.delayed(Duration(milliseconds: 100), () {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        });
        appBar = Colors.transparent;
        shareButton = Colors.white;
        backButton = Colors.white;
        textColor = Colors.transparent;
        dividerColor = Colors.transparent;
      }
    }
    if (scrollNotification.metrics.pixels > height / 2.61) {
      if (textColor == Colors.transparent) {
        textColor = Color(0xff38394F);
      }
    } else {
      if (textColor == Color(0xff38394F)) {
        textColor = Colors.transparent;
      }
    }
    return true;
  }

  Future<void> checkVote() async {
    for (int i = 0; i < apiArticlePollModel.variants.length; i++) {
      print(i);
      print(apiArticlePollModel.variants[i].selected);
      if (apiArticlePollModel.variants[i].selected == true) {
        isVote = true;
      }
    }
    setState(() {});
  }

  Future<void> setPoll(int id) async {
    String userToken = await PreferencesProvider().getAnonToken();
    print(userToken);
    RestApi().sendPollId(id, token: userToken).then((values) {
      setState(() {
        isVote = true;
      });
      getArticleDetails(widget.articleId);
    });
  }

  Future<void> setRating() async {
    String userToken = await PreferencesProvider().getAnonToken();
    print(userToken);
    RestApi()
        .sendArticleRating(widget.articleId, rating, token: userToken)
        .then((values) {
      setState(() {});
    });
  }

  Future<void> getAnswers(int page) async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi()
        .getAnswers(context, widget.articleId, page, token: userToken)
        .then((values) {
      answersCount = values.info.items.length;
      setState(() {});
    });
  }

  Future<void> getArticleDetails(String articleId) async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi()
        .getArticleDetails(context, articleId, token: userToken)
        .then((values) {
      setState(() {
        article = values.article;
        apiArticlePollModel = article.apiArticlePollModel;
        checkVote();
        getAnswers(1);

        getArticleReplies(articleId, null);
        rating = article.rating;
        //isLoading = false;
      });
      Analytics().sendEventReports(event: article_show, attr: {
        'article_name': article.title,
      });
    });
  }

  Future<void> getArticleReplies(String articleId, String parentId) async {
    int sortBy = 0;
    if (sortValue == AppLocalizations.of(context).translate('by_new')) {
      sortBy = 0;
    }
    if (sortValue == AppLocalizations.of(context).translate('by_popular')) {
      sortBy = 1;
    }
    if (sortValue == AppLocalizations.of(context).translate('by_old')) {
      sortBy = 2;
    }

    String userToken = await PreferencesProvider().getAnonToken();
    RestApi()
        .getArticleReplies(context, articleId, sortBy, parentId,
            token: userToken)
        .then((values) {
      setState(() {
        articleReplies = values.replies;
        isLoading = false;
      });
    });
  }

  Future<void> sendReply(String message, String parentId) async {
    String userToken = await PreferencesProvider().getAnonToken();
    print(userToken);
    RestApi()
        .postReply(context, message, parentId, widget.articleId)
        .then((values) {
      getArticleReplies(widget.articleId, null);
    });
  }

  Future<void> likeReply(int commentId) async {
    String userToken = await PreferencesProvider().getAnonToken();
    print(userToken);
    RestApi().likeReply(context, commentId).then((values) {
      getArticleReplies(widget.articleId, null);
    });
  }

  static String displayTimeAgoFromTimestamp(
      String dateString, BuildContext context) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(int.parse(dateString) * 1000);
    print(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} ' +
          AppLocalizations.of(context).translate('years_ago');
    } else if ((difference.inDays / 365).floor() >= 1) {
      return AppLocalizations.of(context).translate('last_year');
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} ' +
          AppLocalizations.of(context).translate('months_ago');
    } else if ((difference.inDays / 30).floor() >= 1) {
      return AppLocalizations.of(context).translate('last_month');
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} ' +
          AppLocalizations.of(context).translate('weeks_ago');
    } else if ((difference.inDays / 7).floor() >= 1) {
      return AppLocalizations.of(context).translate('last_week');
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} ' +
          AppLocalizations.of(context).translate('days_ago');
    } else if (difference.inDays >= 1) {
      return AppLocalizations.of(context).translate('yesterday');
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} ' +
          AppLocalizations.of(context).translate('hours_ago');
    } else if (difference.inHours >= 1) {
      return AppLocalizations.of(context).translate('one_hour_ago');
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} ' +
          AppLocalizations.of(context).translate('minutes_ago');
    } else if (difference.inMinutes >= 1) {
      return AppLocalizations.of(context).translate('one_minute_ago');
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} ' +
          AppLocalizations.of(context).translate('seconds_ago');
    } else {
      return AppLocalizations.of(context).translate('just_now');
    }
  }
}
