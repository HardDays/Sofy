import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/widgets/neumorphic/neumorphic_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  TextEditingController textController = TextEditingController(text: '');
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
                    Material(
                      color: kArticlesTransparentColor,
                      child: InkWell(
                          borderRadius: BorderRadius.circular(60.r),
                          focusColor: kArticlesTransparentColor,
                          highlightColor: kArticlesTransparentColor,
                          splashColor: kArticlesTransparentColor,
                          hoverColor: kArticlesTransparentColor,
                          radius: 25.r,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 50.0,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                                      fontFamily: Fonts.Exo2Bold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.sp, //24
                                      color: kNavigBarInactiveColor),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            if (!isAnswerSent) Analytics().sendEventReports(event: EventsOfAnalytics.cancel_answer_story_screen, attr: {"name": widget.articleTitle, 'id': widget.articleId});
                            Navigator.pop(context);
                          }),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 21.w),
                      child: Stack(alignment: Alignment.topCenter, children: [
                        Padding(
                          padding: EdgeInsets.only(top: 24.h),
                          child: Container(
                            decoration: BoxDecoration(
                              color: SofyQuestionColors.FormBgColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white70,
                                  offset: Offset(-5, -5),
                                  blurRadius: 15.0,
                                ),
                                BoxShadow(
                                  color: SofyQuestionColors.FormShadowColor,
                                  offset: Offset(5, 5),
                                  blurRadius: 15.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(9.r),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(46.w - 21.w, 40.h, 8.w, 0
                                      ),
                                  child: Text(
                                    AppLocalizations.of(context).translate('share_answer'),
                                    style: TextStyle(
                                        color: SofyQuestionColors.QText, fontSize: 16.sp, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal, fontFamily: Fonts.HindGunturBold, height: 1.5),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: SofyQuestionColors.FormBgColor,
                                    borderRadius: BorderRadius.circular(9.r),
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    21.w,
                                    16.h,
                                    21.w,
                                    0,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.6),
                                          offset: Offset(-4, -4),
                                          blurRadius: 10,
                                        ),
                                        BoxShadow(
                                          color: Color.fromRGBO(236, 209, 232, 1),
                                          offset: Offset(4, 4),
                                          blurRadius: 10.0,
                                        ),
                                      ],
                                    ),
                                    child: TextField(
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontFamily: Fonts.Gilroy1, fontSize: 14.sp, fontWeight: FontWeight.w600, color: CommentsColors.Text, height: 1.4),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: SofyQuestionColors.InputBgColor,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: SofyQuestionColors.InputBgColor),
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: SofyQuestionColors.InputBgColor),
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: SofyQuestionColors.InputBgColor),
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        contentPadding: EdgeInsets.only(left: 16.w),
                                        hintStyle: TextStyle(
                                          fontFamily: Fonts.HindGuntur,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: SofyQuestionColors.InputHintColor,
                                          height: 1.5,
                                        ),
                                        hintText: AppLocalizations.of(context).translate('answer_hint'),
                                        counterText: '',
                                      ),
                                      maxLength: 100,
                                      maxLines: 1,
                                      enabled: !isAnswerSent,
                                      autofocus: true,
                                      controller: textController,
                                    ),
                                  ),
                                ),
                                /////////////////
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    21.w,
                                    0,
                                    21.w,
                                    24.h,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        color: kArticlesAnsShadow,
                                        offset: Offset(3, 3),
                                        blurRadius: 10.0,
                                      ),
                                    ]),
                                    height: 52.h,
                                    margin: EdgeInsets.only(top: 21.h),
                                    child: NeumorphicCustomButton(
                                      margin: EdgeInsets.zero,
                                      style: NeumorphicStyle(
                                          depth: !isAnswerSent ? 0 : -3,
                                          shape: NeumorphicShape.flat,
                                          intensity: 0.6,
                                          shadowLightColorEmboss: kADNeumorphicShadowLightColorEmboss,
                                          shadowDarkColor: kADNeumorphicShadowDarkColor,
                                          shadowDarkColorEmboss: kADNeumorphicShadowDarkColorEmboss,
                                          shadowLightColor: kArticlesWhiteColor,
                                          color: kADNeumorphicColor),
                                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10.r)),
                                      provideHapticFeedback: false,
                                      onClick: () {
                                        if (isAnswerSent) return;
                                        if (textController.text.length > 0 || textController.text.length < 255) {
                                          // аналитика уходит в функции
                                          sendAnswer(widget.articleId, widget.questionId, textController.text.toString());
                                        }
                                      },
                                      padding: EdgeInsets.zero,
                                      child: Container(
                                        height: 52.h,
                                        decoration: BoxDecoration(
                                          gradient: new LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: kLinearGrad2Color,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.r),
                                          ),
                                        ),
                                        child: !isAnswerSent && !isLoading
                                            ? Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                SvgPicture.asset(
                                                  'assets/svg/article_send_comment.svg',
                                                ),
                                                SizedBox(width: 9.w),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 3.5.h),
                                                  child: Text(
                                                    AppLocalizations.of(context).translate('send'),
                                                    style: TextStyle(
                                                      fontFamily: Fonts.HindGunturSemiBold,
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 14.sp,
                                                      color: kArticlesWhiteColor,
                                                    ),
                                                  ),
                                                )
                                              ])
                                            : isLoading
                                                ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 14.w,
                                                          height: 14.h,
                                                          child: CircularProgressIndicator(
                                                            color: SofyVoteProgressColors.BgColor,
                                                          )),
                                                    ],
                                                  )
                                                : Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                    Icon(
                                                      FontAwesomeIcons.solidCheckCircle,
                                                      size: 14.sp,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 9.h),
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 7.h),
                                                      child: Text(
                                                        AppLocalizations.of(context).translate('answer_sent'),
                                                        style: TextStyle(
                                                          fontFamily: Fonts.HindGunturSemiBold,
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 14.sp,
                                                          color: kArticlesWhiteColor,
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(color: Color.fromRGBO(255, 255, 255, 0.6), offset: Offset(-4, -4), blurRadius: 10),
                                BoxShadow(color: Color.fromRGBO(219, 196, 219, 0.41), offset: Offset(4, 4), blurRadius: 10)
                              ], borderRadius: BorderRadius.all(Radius.circular(1000)), color: Color.fromRGBO(252, 239, 252, 1)),
                            ),
                            Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(1000))),
                              child: Image.asset('assets/answer_title_image_cut.png'),
                            ),
                          ],
                        ),
                      ]),
                    ),
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
