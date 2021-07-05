import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HeaderButton extends StatelessWidget {
  const HeaderButton(
      {Key key, this.text, this.callback, this.fontSize, this.textColor})
      : super(key: key);
  final String text;
  final VoidCallback callback;
  final Color textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            letterSpacing: -0.065 * fontSize,
          ),
        ),
        // InkWell(
        //   child: Icon(Icons.arrow_forward_ios),
        //   onTap: callback,
        // ),

        Container(
            child: Stack(
          children: <Widget>[
            Container(
              child: SvgPicture.asset(
                'assets/svg/arrow_next_vector.svg',
                color: textColor,
                height: fontSize,
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
                    radius: fontSize * 2,
                    onTap: callback),
              ),
            ),
          ],
        )),
      ],
    );
  }
}