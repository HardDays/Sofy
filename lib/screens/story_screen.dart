import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_model.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/screens/bloc/story_bloc.dart';
import 'package:sofy_new/widgets/story/story_background.dart';
import 'package:sofy_new/widgets/story/story_card.dart';

class StoryScreen extends StatelessWidget {
  StoryScreen({this.article});

  final ApiArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: SofyStoryColors.BgColor,
        body: BlocBuilder<StoryBloc, StoryState>(
            bloc: BlocProvider.of<StoryBloc>(context)..add(StoryEventChangePage(page: 1)),
            builder: (context, state) {
              if (state is StoryStateResult) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Stack(
                      children: [
                        StoryBackground(coverImg: article.coverImg),
                        SafeArea(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Stack(
                              children: [
                                state.answersInfoModel.items.length > 0
                                    ? PageView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: state.answersInfoModel.meta.pageCount,
                                        itemBuilder: (context, int i) {
                                          List<Widget> top = [];
                                          for (int j = 0; j < state.answersInfoModel.meta.pageCount; j++) {
                                            top.add(Container(
                                              width: (SizeConfig.screenWidth - 80) / state.answersInfoModel.meta.pageCount,
                                              height: 2,
                                              color: state.answersInfoModel.meta.currentPage - 1 >= j ? SofyStoryColors.TopPageCounterActiveColor : SofyStoryColors.TopPageCounterNotActiveColor,
                                            ));
                                          }
                                          return Stack(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: top,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: 20),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    state.answersInfoModel.items.length >= 1
                                                        ? StoryCard(
                                                            content: state.answersInfoModel.items[0].content,
                                                            title: article.title,
                                                            height: SizeConfig.screenHeight / 4,
                                                          )
                                                        : Container(),
                                                    state.answersInfoModel.items.length >= 2
                                                        ? Row(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              StoryCard(
                                                                content: state.answersInfoModel.items[1].content,
                                                                title: article.title,
                                                                height: SizeConfig.screenHeight / 4,
                                                              )
                                                            ],
                                                          )
                                                        : Container(),
                                                    state.answersInfoModel.items.length >= 3
                                                        ? StoryCard(
                                                            content: state.answersInfoModel.items[2].content,
                                                            title: article.title,
                                                            height: SizeConfig.screenHeight / 4,
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        })
                                    : Center(
                                        child: Text(
                                          AppLocalizations.of(context).translate('no_stories'),
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Container(
                                color: Color.fromRGBO(255, 255, 255, 0.001),
                                height: SizeConfig.screenHeight,
                                width: SizeConfig.screenWidth / 2,
                              ),
                              onTap: () {
                                if (state.answersInfoModel.meta.currentPage == 1)
                                  Navigator.maybePop(context);
                                else
                                  BlocProvider.of<StoryBloc>(context)..add(StoryEventChangePage(page: state.answersInfoModel.meta.currentPage - 1));
                              },
                              onHorizontalDragEnd: (det) {
                                if (state.answersInfoModel.meta.currentPage == 1)
                                  Navigator.maybePop(context);
                                else
                                  BlocProvider.of<StoryBloc>(context)..add(StoryEventChangePage(page: state.answersInfoModel.meta.currentPage - 1));
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                color: Color.fromRGBO(255, 255, 255, 0.001),
                                height: SizeConfig.screenHeight,
                                width: SizeConfig.screenWidth / 2,
                              ),
                              onTap: () {
                                if (state.answersInfoModel.meta.currentPage < state.answersInfoModel.meta.pageCount) {
                                  BlocProvider.of<StoryBloc>(context)..add(StoryEventChangePage(page: state.answersInfoModel.meta.currentPage + 1));
                                }
                              },
                              onHorizontalDragEnd: (det) {
                                if (state.answersInfoModel.meta.currentPage < state.answersInfoModel.meta.pageCount) {
                                  BlocProvider.of<StoryBloc>(context)..add(StoryEventChangePage(page: state.answersInfoModel.meta.currentPage + 1));
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 82 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical, right: 30 / Layout.height * Layout.multiplier * SizeConfig.blockSizeVertical),
                      child: CloseButtonMaybePop(),
                    )
                  ],
                );
              }
              if (state is StoryStateError) {
                return Stack(
                  alignment: Alignment.center,
                  children: [StoryBackground(coverImg: article.coverImg), Center(child: Text(state.error, textAlign: TextAlign.center))],
                );
              }
              return Stack(
                alignment: Alignment.center,
                children: [
                  StoryBackground(coverImg: article.coverImg),
                  Center(
                    child: Container(
                      child: CircularProgressIndicator(
                        color: SofyStoryColors.ProgressIndicatorColor,
                      ),
                      width: SizeConfig.screenHeight / 10,
                      height: SizeConfig.screenHeight / 10,
                    ),
                  ),
                ],
              );
            }));
  }
}

class CloseButtonMaybePop extends StatelessWidget {
  const CloseButtonMaybePop({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: Colors.pink[50], borderRadius: BorderRadius.all(Radius.circular(100))),
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100)), boxShadow: [
        BoxShadow(offset: Offset(3, 3), color: Color.fromRGBO(236, 209, 232, 0.3), blurRadius: 4),
        BoxShadow(offset: Offset(-3, -3), color: Color.fromRGBO(236, 209, 232, 0.1), blurRadius: 10),
      ]),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
            child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.all(Radius.circular(100))),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                )),
            onTap: () => Navigator.maybePop(context)),
      ),
    );
  }
}
