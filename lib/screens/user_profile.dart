import 'dart:io';
import 'dart:ui';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/providers/preferences_provider.dart';
import 'package:sofy_new/providers/user.dart';
import 'package:sofy_new/rest_api.dart';
import 'package:sofy_new/widgets/user_text_field.dart';
import 'package:dio/dio.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreen createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  User user;
  File image;
  final picker = ImagePicker();
  List<int> avasColorList = [
    0xffFFA3B8,
    0xffE3C2CE,
    0xffEA6C96,
    0xffF6D4F6,
    0xffFAD5DE
  ];
  String avaPath;
  int avaColor;

  @override
  void initState() {
    super.initState();
    /*Analytics().sendEventReports(
      event: settings_screen_show,
    );*/
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    user = Provider.of<User>(context, listen: false);

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffFDF3FF),
                  Color(0xffF9EAF7),
                ],
              ),
            ),
            child: Padding(
                padding:
                    EdgeInsets.only(left: 0.0, right: 0.0, top: height / 14.50),
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
                    InkWell(
                        onTap: () {
                          getImage();
                        },
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        radius: 100,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: height / 89.6, bottom: height / 44.8),
                          alignment: Alignment.center,
                          child: Stack(children: [
                            Align(
                                alignment: Alignment.center,
                                child: avaPath != null ? avaPath.contains('http')
                                    ? Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: onBoardingTitleColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        height: height / 7.11,
                                        width: height / 7.11,
                                        alignment: Alignment.center,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          child: Image.network(
                                            avaPath,
                                            height: height / 7.11,
                                            width: height / 7.11,
                                            fit: BoxFit.cover,
                                          ),
                                        ))
                                    : Container(
                                        height: height / 7.11,
                                        width: height / 7.11,
                                        decoration: BoxDecoration(
                                            color: avaPath != null
                                                ? Color(avaColor != null ? avaColor : 0xffffff)
                                                : Colors.transparent,
                                            image: DecorationImage(
                                              image: AssetImage(avaPath != null
                                                  ? avaPath
                                                  : 'assets/add_photo.png'),
                                              fit: BoxFit.cover,
                                            ),
                                            border: Border.all(
                                                color: onBoardingTitleColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        child: image != null
                                            ? ClipRRect(
                                                child: Image.file(image,
                                                    fit: BoxFit.cover),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100)))
                                            : Container()) : Container(
                                    height: height / 7.11,
                                    width: height / 7.11,
                                    decoration: BoxDecoration(
                                        color: avaPath != null
                                            ? Color(avaColor)
                                            : Colors.transparent,
                                        image: DecorationImage(
                                          image: AssetImage(avaPath != null
                                              ? avaPath
                                              : 'assets/add_photo.png'),
                                          fit: BoxFit.cover,
                                        ),
                                        border: Border.all(
                                            color: onBoardingTitleColor),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100))),
                                    child: image != null
                                        ? ClipRRect(
                                        child: Image.file(image,
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)))
                                        : Container())),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    margin: EdgeInsets.only(top: height / 8.0),
                                    height: height / 37.33,
                                    width: height / 37.33,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: AssetImage(
                                          'assets/add_photo_button.png'),
                                      fit: BoxFit.cover,
                                    ))))
                          ]),
                        )),
                    UserTextField(
                      enable: false,
                      iconUrl: 'assets/svg/user_name.svg',
                      height: 1,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      text: AppLocalizations.of(context).translate('your_name'),
                      isPass: false,
                      controller: nameController,
                      textInputType: TextInputType.name,
                    ),
                    SizedBox(height: height / 42.66),
                    UserTextField(
                      enable: false,
                      iconUrl: 'assets/svg/user_mail.svg',
                      height: 1,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      text: AppLocalizations.of(context).translate('mail_hint'),
                      isPass: false,
                      controller: mailController,
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: height / 42.66),
                    SizedBox(height: height / 14.45),
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: height / 40.72),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: height / 17.23,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: new LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xFFFDB0C1),
                                    const Color(0xFFFF95AC),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xffFFBFCD),
                                    offset: Offset(7, 7),
                                    blurRadius: 10.0,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate('logout'),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: kFontFamilyGilroyBold,
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
                                      /*Analytics().sendEventReports(
                            event: banner_click,
                          );*/
                                      userLogout();
                                    }),
                              ),
                            ),
                          ],
                        )),
                  ],
                ))));
  }

  Future<void> getUsersData() async {
    nameController.text = await PreferencesProvider().getUserName();
    mailController.text = await PreferencesProvider().getUserMail();
    if (await PreferencesProvider().getUserPhoto() == '' &&
        await PreferencesProvider().getAvaNumber() != '') {
      getAva();
    }
    if (await PreferencesProvider().getUserPhoto() == '' &&
        await PreferencesProvider().getAvaNumber() == '') {
      generateAva();
    }
    String userPhoto = await PreferencesProvider().getUserPhoto();
    if (userPhoto.contains('http')) {
      avaPath = await PreferencesProvider().getUserPhoto();
      //avaColor = await PreferencesProvider().getAvaBackground();
      setState(() {});
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 480,
        maxWidth: 640);
    String token = await PreferencesProvider().getUserToken();

    if (pickedFile != null) {
      FormData data = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          pickedFile.path,
        ),
      });
      RestApi().setUserProfile(context, data, token);
      await PreferencesProvider().saveAvaBackground(0);
      await PreferencesProvider().saveAvaNumber('');
      avaPath = '';
      image = null;

    }
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future generateAva() async {
    Random random = new Random();
    int avaNumber = random.nextInt(39);
    String imagePath = 'assets/ava/' + avaNumber.toString() + '.png';

    print('avaNumber = ' + avaNumber.toString());
    print('imagePath = ' + imagePath);

    int avaColor = random.nextInt(3);

    await PreferencesProvider().saveAvaNumber(imagePath);
    await PreferencesProvider().saveAvaBackground(avasColorList[avaColor]);
    setState(() {});
  }

  Future<void> getUserProfile() async {
    String userId = await PreferencesProvider().getUserId();
    String token = await PreferencesProvider().getUserToken();
    if (userId != '' && token != '') {
      RestApi().userProfile(context, userId, token).then((values) async {
        image = null;
        avaPath = values;
        await PreferencesProvider().saveUserPhoto(avaPath);
        setState(() {});
      });
      getUsersData();
    }
  }

  Future getAva() async {
    avaPath = await PreferencesProvider().getAvaNumber();
    avaColor = await PreferencesProvider().getAvaBackground();
    setState(() {});
    print('avaColor = ' + avaColor.toString());
    print('imagePath = ' + avaPath);
  }

  Future<void> userLogout() async {
    await PreferencesProvider().logout();
    user.updateIsAuth(flag: false);
    Navigator.of(context).pop();
  }
}
