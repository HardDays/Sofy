
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/providers/app_localizations.dart';
import 'package:sofy_new/screens/bloc/comments_bloc.dart';
import 'package:sofy_new/widgets/comments/send_button.dart';

class CommentField extends StatelessWidget {
  const CommentField({
    Key key,
    @required TextEditingController textController,
    @required this.articleId,
    @required this.parentId,
    this.width = 100,
  }) : _textController = textController, super(key: key);

  final TextEditingController _textController;
  final int articleId;
  final int parentId;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 42,
          width: width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: CommentsColors.NegativeInputShadowColor,
                offset: Offset(-4, -4),
                blurRadius: 10,
              ),
            ],
          ),
          child: TextField(
            controller: _textController,
            textAlign: TextAlign.left,
            textCapitalization: TextCapitalization.characters,
            style: TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 14,
                color: CommentsColors.Text),
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: CommentsColors.InputBgColor,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: CommentsColors.InputBgColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: CommentsColors.InputBgColor),
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
              EdgeInsets.only(left: 16.0, bottom: 7.0),
              hintStyle: TextStyle(
                  fontFamily: 'Gilroy',
                  fontSize: 14,
                  color: CommentsColors.HintText),
              hintText: AppLocalizations.of(context)
                  .translate('add_comment'),
            ),
          ),
        ),
        SendButton(callback: () {
          if (_textController.value.text != '' &&
              articleId > 0)
            BlocProvider.of<CommentsBloc>(context)
              ..add(CommentsEventSend(
                  text: _textController.value.text,
                  articleId: articleId,
                  parentId: parentId));
        }),
      ],
    );
  }
}