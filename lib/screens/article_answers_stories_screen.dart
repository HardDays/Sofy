import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/models/api_answers_model.dart';
import 'package:sofy_new/models/stories_model.dart';
import 'package:sofy_new/providers/preferences_provider.dart';

import '../rest_api.dart';

class ArticleAnswersStoriesScreen extends StatefulWidget {
  final String articleId;
  final String coverUrl;
  final String question;

  ArticleAnswersStoriesScreen({Key key,
    @required this.articleId,
    @required this.coverUrl,
    @required this.question})
      : super(key: key);

  @override
  _ArticleAnswersStoriesScreenState createState() =>
      _ArticleAnswersStoriesScreenState();
}

class _ArticleAnswersStoriesScreenState
    extends State<ArticleAnswersStoriesScreen>
    with SingleTickerProviderStateMixin {
  List<Story> stories = new List<Story>();
  List<ApiAnswersModel> answers = new List<ApiAnswersModel>();

  PageController _pageController;
  AnimationController _animController;
  int _currentIndex = 0;
  double height;
  double width;

  @override
  void initState() {
    super.initState();

    getAnswers(1);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    //Analytics().sendEventReports(event: subscription_splash_show);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
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

    final Story story = stories[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, story),
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: stories.length,
              itemBuilder: (context, i) {
                final Story story = stories[i];
                switch (story.media) {
                  case MediaType.image:
                    return CachedNetworkImage(
                      imageUrl: story.url,
                      fit: BoxFit.cover,
                    );
                }
                return const SizedBox.shrink();
              },
            ),
            BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                    color: kArticlesAnsStoriesBackdropFilterColor,
                    height: double.infinity,
                    width: double.infinity)),
            Padding(
              padding: EdgeInsets.only(top: height / 9.95),
              child: Column(children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(0.0),
                    itemCount: answers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          Container(
                              width: width / 1.5,
                              margin: EdgeInsets.only(
                                  top: height / 12.6,
                                  left: index == 1 ? width / 3.6 : 20,
                                  right: 20),
                              child: Neumorphic(
                                  style: NeumorphicStyle(
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(15)),
                                      depth: 3,
                                      intensity: 0.65,
                                      shadowLightColorEmboss: kArticlesWhiteColor,
                                      shadowLightColor: kArticlesWhiteColor,
                                      shadowDarkColor: kNeumorphicShadowDarkColor,
                                      shadowDarkColorEmboss: kNeumorphicShadowDarkColor,
                                      shape: NeumorphicShape.flat,
                                      color: kNeumorphicColor2),
                                  child: Container(
                                      width: width,
                                      child: Column(children: [
                                        Container(
                                          color: kArticlesAnsStoriesColor,
                                          width: double.infinity,
                                          height: height / 14.45,
                                          padding: EdgeInsets.only(
                                              left: 15.0, right: 15.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            widget.question,
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: kFontFamilyGilroyBold,
                                                height: 1.40,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                fontSize: height / 59.7,
                                                color: kArticlesWhiteColor),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                              left: 16.0,
                                              right: 16.0,
                                              top: height / 44.65,
                                              bottom: height / 44.65),
                                          child: Text(
                                            answers[index].content,
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: kFontFamilyGilroy,
                                                height: 1.50,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal,
                                                fontSize: height / 59.7,
                                                color: kArticlesAnsStories2Color),
                                          ),
                                        ),
                                      ])))),
                        ],
                      );
                    })
              ]),
            ),
            Positioned(
              top: height / 15.45,
              left: 10.0,
              right: 10.0,
              child: Column(
                children: <Widget>[
                  Row(
                    children: stories
                        .asMap()
                        .map((i, e) {
                      return MapEntry(
                        i,
                        AnimatedBar(
                          animController: _animController,
                          position: i,
                          currentIndex: _currentIndex,
                        ),
                      );
                    })
                        .values
                        .toList(),
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: Container(
                    padding: EdgeInsets.only(right: 22.0, top: height / 11.2),
                    width: 50.0,
                    alignment: Alignment.topRight,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: SvgPicture.asset(
                            'assets/svg/article_close.svg',
                            width: 30.0,
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                borderRadius: BorderRadius.circular(60),
                                radius: 25,
                                onTap: () {
                                  //Analytics().sendEventReports(event: subscription_splash_close_click);
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
                      ],
                    ))),
          ],
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(story: stories[_currentIndex]);
          getAnswers(_currentIndex + 1);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < stories.length) {
          _currentIndex += 1;
          _loadStory(story: stories[_currentIndex]);
          getAnswers(_currentIndex + 1);
        } else {
          _currentIndex = 0;
          _loadStory(story: stories[_currentIndex]);
          getAnswers(1);
        }
      });
    }
  }

  void _loadStory({Story story, bool animateToPage = true}) {
    _animController.stop();
    _animController.reset();
    switch (story.media) {
      case MediaType.image:
        _animController.duration = story.duration;
        _animController.forward();
        break;
    }
    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> getAnswers(int page) async {
    String userToken = await PreferencesProvider().getAnonToken();
    RestApi()
        .getAnswers(context, widget.articleId, page, token: userToken)
        .then((values) {
      answers = values.info.items;
      if (stories.length == 0) {
        for (int i = 0; i < values.info.meta.pageCount; i++) {
          stories.add(Story(
            url: widget.coverUrl,
            media: MediaType.image,
            duration: const Duration(hours: 7),
          ));
        }
      }

      _pageController = PageController();
      _animController = AnimationController(vsync: this);

      final Story firstStory = stories.first;
      _loadStory(story: firstStory, animateToPage: false);

      _animController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animController.stop();
          _animController.reset();
          setState(() {
            if (_currentIndex + 1 < stories.length) {
              _currentIndex += 1;
              _loadStory(story: stories[_currentIndex]);
            } else {
              // Out of bounds - loop story
              // You can also Navigator.of(context).pop() here
              _currentIndex = 0;
              _loadStory(story: stories[_currentIndex]);
            }
          });
        }
      });
      setState(() {});
    });
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    Key key,
    @required this.animController,
    @required this.position,
    @required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? kArticlesWhiteColor
                      : kArticlesWhiteColor.withOpacity(0.3),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                  animation: animController,
                  builder: (context, child) {
                    return _buildContainer(
                      constraints.maxWidth * animController.value,
                      kArticlesWhiteColor,
                    );
                  },
                )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 2.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black26,
          width: 0.1,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
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
