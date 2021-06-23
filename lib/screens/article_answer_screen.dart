import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/widgets/neumorphic/neumorphic_button.dart';

import '../rest_api.dart';
import 'bloc/analytics.dart';

class ArticleAnswerScreen extends StatefulWidget {
  final String articleId;
  final String articleTitle;
  final int questionId;

  ArticleAnswerScreen(
      {Key key, @required this.articleId, @required this.questionId, @required this.articleTitle})
      : super(key: key);

  @override
  _ArticleAnswerScreenState createState() => _ArticleAnswerScreenState();
}

class _ArticleAnswerScreenState extends State<ArticleAnswerScreen> {
  double height;
  double width;
  bool isAnswerSent = false;
  TextEditingController textController = TextEditingController();
  Color backColor = Color(0xffdbc4db);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    textController.addListener(() {
      if (textController.text.length > 255) {
        backColor = Color(0xFFFF95AC);
        setState(() {});
      } else {
        backColor = Color(0xffdbc4db);
        setState(() {});
      }
    });
    //Analytics().sendEventReports(event: subscription_splash_show);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery
        .of(context)
        .size
        .height;
    width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      backgroundColor: Color(0x752F2E41),
      body: BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Container(
            child: Container(
              height: height,
              child: Column(
                  children: <Widget>[
              SizedBox(height: height / 16.69),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: width / 3,
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
                                  padding: EdgeInsets.only(
                                      bottom: height / 179.2),
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('back'),
                                    style: TextStyle(
                                        fontFamily: 'Exo 2',
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
                  Padding(
                      padding: EdgeInsets.only(top: height / 9),
                      child: Stack(
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                    top: height / 25.6, left: 20, right: 20),
                                child: Neumorphic(
                                    style: NeumorphicStyle(
                                        boxShape:
                                        NeumorphicBoxShape.roundRect(
                                            BorderRadius.circular(15)),
                                        depth: 3,
                                        intensity: 0.65,
                                        shadowLightColorEmboss:
                                        Colors.white.withOpacity(0.5),
                                        shadowLightColor:
                                        Colors.white.withOpacity(0.5),
                                        shadowDarkColor: Color(0xffdbc4db),
                                        shadowDarkColorEmboss:
                                        Color(0xffdbc4db),
                                        shape: NeumorphicShape.flat,
                                        color: Color(0xffFAEBF8)),
                                    child: Container(
                                        width: width, height: height / 4.0))),
                            Padding(
                                padding: EdgeInsets.only(top: 0.0),
                                child: Column(children: [
                                    Container(
                                    width: 75.0,
                                    height: 75.0,
                                    child: Image.asset(
                                        'assets/answer_title_image.png')),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 5.0, left: 20.0, right: 20.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('share_answer'),
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Gilroy Bold',
                                            height: 1.5,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.0,
                                            color: Color(0xff836771)),
                                      ),
                                    )),
                                Container(
                                    height: height / 18.66,
                                    margin: EdgeInsets.only(
                                        top: height / 42.66,
                                        left: 42.0,
                                        right: 42.0),
                                    child: Neumorphic(
                                        style: NeumorphicStyle(
                                            boxShape: NeumorphicBoxShape
                                                .roundRect(
                                                BorderRadius.circular(
                                                    10)),
                                            depth: 3,
                                            intensity: 0.65,
                                            shadowLightColorEmboss:
                                            backColor == Color(0xFFFF95AC)
                                                ? backColor
                                                : Colors.white,
                                            shadowLightColor:
                                            backColor == Color(0xFFFF95AC)
                                                ? backColor
                                                : Colors.white,
                                            shadowDarkColor:
                                            backColor,
                                            shadowDarkColorEmboss:
                                            backColor,
                                            shape: NeumorphicShape.flat,
                                            color: Color(0xffF9D9F4)),
                                    child: TextField(
                                      enabled: true,
                                      autofocus: true,
                                      textAlign: TextAlign.left,
                                      textCapitalization:
                                      TextCapitalization.sentences,
                                      controller: textController,
                                      style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          fontSize: height / 64.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff836771)),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 16.0, bottom: 7.0),
                                        hintStyle: TextStyle(
                                            fontFamily: 'Gilroy',
                                            fontSize: height / 64.0,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0x50836771)),
                                        hintText: AppLocalizations.of(
                                            context)
                                            .translate('answer_hint'),
                                        border: InputBorder.none,
                                      ),
                                    ))),
                            Container(
                                decoration:
                                BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffC4C4C4),
                                    offset: Offset(3, 3),
                                    blurRadius: 10.0,
                                  ),
                                ]),
                                height: height / 18.66,
                                margin: EdgeInsets.only(
                                    left: 40.0,
                                    right: 40.0,
                                    top: height / 56),
                                child: NeumorphicCustomButton(
                                    style: NeumorphicStyle(
                                        depth: !isAnswerSent ? 0 : -3,
                                        shape: NeumorphicShape.flat,
                                        intensity: 0.6,
                                        shadowLightColorEmboss:
                                        Color(0xffFBE5FB),
                                        shadowDarkColor:
                                        Color(0xffFBE5FB),
                                        shadowDarkColorEmboss:
                                        Color(0xff663966),
                                        shadowLightColor:
                                        Colors.white,
                                        color: Color(0xffFCEFFC)),
                                    boxShape: NeumorphicBoxShape
                                        .roundRect(
                                        BorderRadius.circular(
                                            10)),
                                    provideHapticFeedback: false,
                                    onClick: () {
                                      if (textController
                                          .text.length >
                                          0 || textController
                                          .text.length <
                                          255) {
                                        sendAnswer(
                                            widget.articleId,
                                            widget.questionId,
                                            textController.text
                                                .toString());
                                      }
                                      /*Analytics().sendEventReports(
                            event: banner_click,
                          );*/
                                    },
                                    padding: EdgeInsets.all(0.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          height: height / 18.66,
                                          alignment:
                                          Alignment.center,
                                          decoration: BoxDecoration(
                                              gradient:
                                              new LinearGradient(
                                                begin: Alignment
                                                    .topCenter,
                                                end: Alignment
                                                    .bottomCenter,
                                                colors: [
                                                  const Color(
                                                      0xFFFDB0C1),
                                                  const Color(
                                                      0xFFFF95AC),
                                                ],
                                              ),
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(
                                                      10.0))),
                                          child: !isAnswerSent
                                              ? Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                            children: <
                                                Widget>[
                                              Container(
                                                alignment:
                                                Alignment
                                                    .center,
                                                margin: EdgeInsets
                                                    .only(
                                                    right:
                                                    9.0),
                                                child:
                                                SvgPicture
                                                    .asset(
                                                  'assets/svg/article_send_comment.svg',
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets
                                                    .only(
                                                    bottom:
                                                    4.0),
                                                child: Text(
                                                  AppLocalizations.of(
                                                      context)
                                                      .translate(
                                                      'send'),
                                                  overflow:
                                                  TextOverflow
                                                      .ellipsis,
                                                  style:
                                                  TextStyle(
                                                    fontFamily: 'Montserrat Bold',
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: height / 56,
                                                    //14
                                                    height: 1.7,
                                                    color: Colors.white,
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
                                            children: <
                                                Widget>[
                                              Container(
                                                alignment:
                                                Alignment
                                                    .center,
                                                margin: EdgeInsets
                                                    .only(
                                                    right:
                                                    9.0),
                                                child:
                                                SvgPicture
                                                    .asset(
                                                  'assets/svg/sent.svg',
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets
                                                    .only(
                                                    bottom:
                                                    4.0),
                                                child: Text(
                                                  AppLocalizations.of(
                                                      context)
                                                      .translate(
                                                      'answer_sent'),
                                                  overflow:
                                                  TextOverflow
                                                      .ellipsis,
                                                  style:
                                                  TextStyle(
                                                    fontFamily: 'Montserrat Bold',
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: height / 56,
                                                    //14
                                                    height: 1.7,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ))),
                          ])),
                ],
              ),
            )
            ]),
        ],
      ),
    ),)
    )
    ,
    );
  }

  Future<void> sendAnswer(String id, int questionId, String text) async {
    String userToken = await PreferencesProvider().getAnonToken();
    print(userToken);
    Analytics().sendEventReports(event: send_stories, attr: {
      'article_name': widget.articleTitle,
    });
    RestApi().sendAnswer(id, questionId, text, token: userToken).then((values) {
      setState(() {
        isAnswerSent = true;
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
