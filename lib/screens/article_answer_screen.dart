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

  ArticleAnswerScreen({Key key, @required this.articleId, @required this.questionId, @required this.articleTitle}) : super(key: key);

  @override
  _ArticleAnswerScreenState createState() => _ArticleAnswerScreenState();
}

class _ArticleAnswerScreenState extends State<ArticleAnswerScreen> {
  double height;
  double width;
  bool isAnswerSent = false;
  bool isLoading = false;
  TextEditingController textController = TextEditingController();
  Color backColor = kArticlesBackColor;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    textController.addListener(() {
      if (textController.text.length > 255) {
        backColor = kArticlesBackTextColor;
        setState(() {});
      } else {
        backColor = kArticlesBackColor;
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kArticlesBackgroundColorColor,
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
                          color: kArticlesTransparentColor,
                          child: InkWell(
                              borderRadius: BorderRadius.circular(60),
                              focusColor: kArticlesTransparentColor,
                              highlightColor: kArticlesTransparentColor,
                              splashColor: kArticlesTransparentColor,
                              hoverColor: kArticlesTransparentColor,
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
                                    padding: EdgeInsets.only(bottom: height / 179.2),
                                    alignment: Alignment.center,
                                    child: Text(
                                      isAnswerSent ? AppLocalizations.of(context).translate('back') : AppLocalizations.of(context).translate('cancel'),
                                      style: TextStyle(
                                          fontFamily: Fonts.Exo2,
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
                            margin: EdgeInsets.only(top: height / 25.6, left: 20, right: 20),
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                                  depth: 3,
                                  intensity: 0.65,
                                  shadowLightColorEmboss: kArticlesWhiteColor.withOpacity(0.5),
                                  shadowLightColor: kArticlesWhiteColor.withOpacity(0.5),
                                  shadowDarkColor: kArticlesBackColor,
                                  shadowDarkColorEmboss: kArticlesBackColor,
                                  shape: NeumorphicShape.flat,
                                  color: kNeumorphicColor2),
                              child: Container(width: width, height: height / 4.0),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 75.0,
                                  height: 75.0,
                                  child: Image.asset('assets/answer_title_image.png'),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        AppLocalizations.of(context).translate('share_answer'),
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(fontFamily: Fonts.GilroyBold, height: 1.5, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal, fontSize: 16.0, color: kWelcomDarkTextColor),
                                      ),
                                    )),
                                Container(
                                  height: height / 18.66,
                                  margin: EdgeInsets.only(top: height / 42.66, left: 42.0, right: 42.0),
                                  child: Neumorphic(
                                    style: NeumorphicStyle(
                                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                                        depth: 3,
                                        intensity: 0.65,
                                        shadowLightColorEmboss: backColor == kArticlesBackTextColor ? backColor : kArticlesWhiteColor,
                                        shadowLightColor: backColor == kArticlesBackTextColor ? backColor : kArticlesWhiteColor,
                                        shadowDarkColor: backColor,
                                        shadowDarkColorEmboss: backColor,
                                        shape: NeumorphicShape.flat,
                                        color: kNeumorphicColor),
                                    child: TextField(
                                      enabled: !isAnswerSent,
                                      autofocus: true,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontFamily: Fonts.HindGuntur, fontSize: height / 48.33, fontWeight: FontWeight.w600, color: SofyQuestionColors.Text),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: SofyQuestionColors.InputBgColor,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: SofyQuestionColors.InputBgColor),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: SofyQuestionColors.InputBgColor),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: SofyQuestionColors.InputBgColor),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        contentPadding: EdgeInsets.only(left: 16.0, bottom: 7.0),
                                        hintStyle: TextStyle(fontFamily: Fonts.Gilroy, fontSize: height / 64, fontWeight: FontWeight.w600, color: SofyQuestionColors.Text),
                                        hintText: AppLocalizations.of(context).translate('answer_hint'),
                                      ),
                                      controller: textController,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: kArticlesAnsShadow,
                                      offset: Offset(3, 3),
                                      blurRadius: 10.0,
                                    ),
                                  ]),
                                  height: height / 18.66,
                                  margin: EdgeInsets.only(left: 40.0, right: 40.0, top: height / 56),
                                  child: NeumorphicCustomButton(
                                    style: NeumorphicStyle(
                                        depth: !isAnswerSent ? 0 : -3,
                                        shape: NeumorphicShape.flat,
                                        intensity: 0.6,
                                        shadowLightColorEmboss: kADNeumorphicShadowLightColorEmboss,
                                        shadowDarkColor: kADNeumorphicShadowDarkColor,
                                        shadowDarkColorEmboss: kADNeumorphicShadowDarkColorEmboss,
                                        shadowLightColor: kArticlesWhiteColor,
                                        color: kADNeumorphicColor),
                                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                                    provideHapticFeedback: false,
                                    onClick: () {
                                      if (isAnswerSent) return;
                                      if (textController.text.length > 0 || textController.text.length < 255) {
                                        sendAnswer(widget.articleId, widget.questionId, textController.text.toString());
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
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            gradient: new LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: kLinearGrad2Color,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          child: !isAnswerSent && !isLoading
                                              ? Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      alignment: Alignment.center,
                                                      margin: EdgeInsets.only(right: 9.0),
                                                      child: SvgPicture.asset(
                                                        'assets/svg/article_send_comment.svg',
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(bottom: 4.0),
                                                      child: Text(
                                                        AppLocalizations.of(context).translate('send'),
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: Fonts.MontserratBold,
                                                          fontWeight: FontWeight.bold,
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: height / 56,
                                                          //14
                                                          height: 1.7,
                                                          color: kArticlesWhiteColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : isLoading
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                            margin: EdgeInsets.only(bottom: 4.0),
                                                            width: height / 56,
                                                            height: height / 56,
                                                            child: CircularProgressIndicator(
                                                              color: SofyVoteProgressColors.BgColor,
                                                            )),
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                          alignment: Alignment.center,
                                                          margin: EdgeInsets.only(right: 9.0),
                                                          child: SvgPicture.asset(
                                                            'assets/svg/sent.svg',
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(bottom: 4.0),
                                                          child: Text(
                                                            AppLocalizations.of(context).translate('answer_sent'),
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              fontFamily: Fonts.MontserratBold,
                                                              fontWeight: FontWeight.bold,
                                                              fontStyle: FontStyle.normal,
                                                              fontSize: height / 56,
                                                              //14
                                                              height: 1.7,
                                                              color: kArticlesWhiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendAnswer(String id, int questionId, String text) async {
    setState(() {
      isLoading = true;
    });
    String userToken = await PreferencesProvider().getAnonToken();
    Analytics().sendEventReports(event: EventsOfAnalytics.send_stories, attr: {'article_name': widget.articleTitle, 'id': widget.articleId});
    RestApi().sendAnswer(id, questionId, text, token: userToken).then((values) {
      setState(() {
        isAnswerSent = true;
        isLoading = false;
      });
    });
  }
}

class FadeRoute<T> extends MaterialPageRoute<T> {
  FadeRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(opacity: animation, child: child);
  }
}
