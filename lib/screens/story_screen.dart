import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/helper/size_config.dart';
import 'package:sofy_new/models/api_article_model.dart';
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
            bloc: BlocProvider.of<StoryBloc>(context)
              ..add(StoryEventChangePage(page: 1)),
            builder: (context, state) {
              if (state is StoryStateResult) {
                return Stack(
                  children: [
                    StoryBackground(coverImg: article.coverImg),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
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
                                      color: state.answersInfoModel.meta.currentPage-1 >= j ? SofyStoryColors.TopPageCounterActiveColor : SofyStoryColors.TopPageCounterNotActiveColor,
                                    ));
                                  }
                                  return Stack(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: top,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    ],
                                  );
                                })
                                : Center(
                              child: Text('nothing to show'),
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
                              BlocProvider.of<StoryBloc>(context)
                                ..add(StoryEventChangePage(page: state.answersInfoModel.meta.currentPage - 1));
                          },
                          onHorizontalDragEnd: (det) {
                            if (state.answersInfoModel.meta.currentPage == 1)
                              Navigator.maybePop(context);
                            else
                              BlocProvider.of<StoryBloc>(context)
                                ..add(StoryEventChangePage(page: state.answersInfoModel.meta.currentPage - 1));
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
                              BlocProvider.of<StoryBloc>(context)
                                ..add(StoryEventChangePage(page: state.answersInfoModel.meta.currentPage + 1));
                            }
                          },
                          onHorizontalDragEnd: (det) {
                            if (state.answersInfoModel.meta.currentPage < state.answersInfoModel.meta.pageCount) {
                              BlocProvider.of<StoryBloc>(context)
                                ..add(StoryEventChangePage(page: state.answersInfoModel.meta.currentPage + 1));
                            }
                          },
                        ),
                      ],
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
