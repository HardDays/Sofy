import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/rest_api.dart';
import 'package:sofy_new/screens/user_recovery_pass.dart';
import 'package:sofy_new/widgets/user_text_field.dart';

class UserAuthScreen extends StatefulWidget {
  @override
  _UserAuthScreen createState() => _UserAuthScreen();
}

class _UserAuthScreen extends State<UserAuthScreen> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  double isButtonActive = 0.5;

  @override
  void initState() {
    super.initState();
    /*Analytics().sendEventReports(
      event: settings_screen_show,
    );*/
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (mailController.text.length > 0 && passController.text.length > 0) {
      isButtonActive = 1;
    } else {
      isButtonActive = 0.5;
    }

    return Scaffold(
        body: Container(
          width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: kUserAuthLinearGradColor,
              ),
            ),
            child: Padding(
                padding:
                    EdgeInsets.only(left: 0.0, right: 0.0, top: height / 14.50),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: width / 3.5,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(60),
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
                                        AppLocalizations.of(context)
                                            .translate('back'),
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
                      Container(
                        margin: EdgeInsets.only(
                            top: height / 89.6, bottom: height / 44.8),
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context).translate('welcome_back'),
                          style: TextStyle(
                              fontFamily: Fonts.Exo2,
                              fontWeight: FontWeight.bold,
                              fontSize: height / 37.33,
                              color: onBoardingTitleColor),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            right: height / 24.88, left: height / 24.88),
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('create_an_account_sub'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: Fonts.Gilroy,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontSize: height / 64,
                              height: 1.4,
                              color: kUserAuthTextColor),
                        ),
                      ),
                      SizedBox(height: height / 40.72),
                      UserTextField(
                        iconUrl: 'assets/svg/user_mail.svg',
                        height: 1,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        text: AppLocalizations.of(context)
                            .translate('mail_auth_hint'),
                        isPass: false,
                        controller: mailController,
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: height / 42.66),
                      UserTextField(
                        iconUrl: 'assets/svg/user_pass.svg',
                        height: 1,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        text: AppLocalizations.of(context)
                            .translate('pass_auth_hint'),
                        isPass: true,
                        controller: passController,
                        textInputType: TextInputType.name,
                      ),
                      SizedBox(height: height / 42.66),
                      SizedBox(height: height / 42.66),
                      SizedBox(height: height / 14.45),
                      Opacity(
                          opacity: isButtonActive,
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: height / 40.72),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: height / 17.23,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      gradient: new LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: kUserAuthLinearGrad2Color,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: kUserAuthShadowColor,
                                          offset: Offset(7, 7),
                                          blurRadius: 10.0,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate('sign_in'),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: Fonts.GilroyBold,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                fontSize: height / 64,
                                                height: 1.44,
                                                color: kArticlesWhiteColor,
                                              ),
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
                                              kAppPinkDarkColor.withOpacity(0.20),
                                          splashColor:
                                              kAppPinkDarkColor.withOpacity(0.20),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10.0),
                                          ),
                                          onTap: () {
                                            if (isButtonActive == 1) {
                                              RestApi().userAuth(
                                                  context,
                                                  mailController.text.toString(),
                                                  passController.text.toString(), false);
                                              /*Analytics().sendEventReports(
                              event: banner_click,
                            );*/
                                            }
                                          }),
                                    ),
                                  ),
                                ],
                              ))),
                      SizedBox(height: height / 42.66),
                      Center(child: RichText(
                        text: TextSpan(
                            text: AppLocalizations.of(context)
                                .translate('forgot_pass'),
                            style: TextStyle(
                              fontFamily: Fonts.GilroyBold,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              fontSize: height / 74.66,
                              height: 1.20,
                              color: onBoardingTitleColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserRecoveryPassScreen(),
                                  ),
                                );
                              }),
                      ))
                    ],
                  ),
                ))));
  }
}
