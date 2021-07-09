
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';

class SendButton extends StatelessWidget {
  const SendButton({Key key, this.callback}) : super(key: key);
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: CommentsColors.SendShadowColor,
              offset: Offset(4, 4),
              blurRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          color: CommentsColors.ReplyColor,
        ),
        padding: EdgeInsets.all(12),
        child: SvgPicture.asset(
          'assets/svg/article_send_comment.svg',
        ),
      ),
    );
  }
}

