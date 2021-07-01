// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:sofy_new/constants/app_colors.dart';
// import 'package:sofy_new/constants/constants.dart';
// import 'package:sofy_new/models/api_article_topic_model.dart';
// import 'package:sofy_new/providers/app_localizations.dart';
// import 'package:sofy_new/providers/preferences_provider.dart';
// import 'package:sofy_new/widgets/articles_screen_button.dart';
//
// import '../rest_api.dart';
// import 'articles_categories_details_screen.dart';
//
// class ArticlesCategoriesScreen extends StatefulWidget {
//   @override
//   _ArticlesCategoriesScreen createState() => _ArticlesCategoriesScreen();
// }
//
// class _ArticlesCategoriesScreen extends State<ArticlesCategoriesScreen> {
//   List<ApiArticleTopicModel> topicsList = new List<ApiArticleTopicModel>();
//
//   @override
//   void initState() {
//     super.initState();
//     /*Analytics().sendEventReports(
//       event: settings_screen_show,
//     );*/
//     getArticleTopics();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//         backgroundColor: kMainScreenScaffoldBackColor,
//         body: Padding(
//             padding: EdgeInsets.only(left: 0.0, right: 0.0, top: height / 20.8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   width: width / 2,
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                         borderRadius: BorderRadius.circular(60),
//                         focusColor: Colors.transparent,
//                         highlightColor: Colors.transparent,
//                         splashColor: Colors.transparent,
//                         hoverColor: Colors.transparent,
//                         radius: 25,
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               width: 50.0,
//                               alignment: Alignment.center,
//                               child: Padding(
//                                 padding: EdgeInsets.all(12.0),
//                                 child: Container(
//                                   child: SvgPicture.asset(
//                                     'assets/svg/back_vector.svg',
//                                     color: kNavigBarInactiveColor,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               padding: EdgeInsets.only(bottom: height / 179.2),
//                               alignment: Alignment.center,
//                               child: Text(
//                                 AppLocalizations.of(context)
//                                     .translate('all_categories'),
//                                 style: TextStyle(
//                                     fontFamily: kFontFamilyExo2,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: height / 37.3, //24
//                                     color: kNavigBarInactiveColor),
//                               ),
//                             ),
//                           ],
//                         ),
//                         onTap: () {
//                           Navigator.pop(context);
//                         }),
//                   )
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                       left: 21.0, right: 21.0, top: height / 50.29),
//                   child: ListView.builder(
//                     itemCount: topicsList.length,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                       padding: EdgeInsets.all(0.0),
//                     itemBuilder: (context, index) =>
//                         ArticlesCategoryScreenButton(
//                           iconUrl: topicsList[index].coverImg,
//                           height: 1,
//                           borderRadius: BorderRadius.only(
//                               topLeft: topicsList.first.id == topicsList[index].id
//                                   ? Radius.circular(10.0)
//                                   : Radius.circular(0.0),
//                               topRight: topicsList.first.id == topicsList[index].id
//                                   ? Radius.circular(10.0)
//                                   : Radius.circular(0.0),
//                               bottomLeft: topicsList.last.id == topicsList[index].id
//                                   ? Radius.circular(10.0)
//                                   : Radius.circular(0.0),
//                               bottomRight:
//                               topicsList.last.id == topicsList[index].id
//                                   ? Radius.circular(10.0)
//                                   : Radius.circular(0.0)),
//                           text: topicsList[index].name,
//                           onTap: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (BuildContext context) =>
//                                     ArticlesCategoriesDetailsScreen(
//                                         screenTitle: topicsList[index].name,
//                                         categoryId: topicsList[index].id)));
//                             /*Analytics().sendEventReports(
//                             event: not_vibrating_click,
//                           );*/
//                           },
//                         ),
//                   ),
//                 ),
//               ],
//             )));
//   }
//
//   Future<void> getArticleTopics() async {
//     String userToken = await PreferencesProvider().getAnonToken();
//     RestApi().getTopicsList(context, token: userToken).then((values) {
//       setState(() {
//         topicsList = values;
//       });
//     });
//   }
// }
//
// class FadeRoute<T> extends MaterialPageRoute<T> {
//   FadeRoute({WidgetBuilder builder, RouteSettings settings})
//       : super(builder: builder, settings: settings);
//
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     return new FadeTransition(opacity: animation, child: child);
//   }
// }
