import 'package:flutter/material.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';

class FireButton extends StatelessWidget {
  const FireButton({Key key, this.onTap}) : super(key: key);
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffFCEFFC),
            boxShadow: [
              BoxShadow(
                offset: Offset(3, 3),
                color: Color(0xFFdbbfd5),
                blurRadius: 4,
                //spreadRadius: 0.1,
              )
            ]),
        width: 42 / Layout.width *
            Layout.multiplier *
            SizeConfig.blockSizeHorizontal,
        height: 42 / Layout.width *
            Layout.multiplier *
            SizeConfig.blockSizeHorizontal,
        child: Image.asset(
          'assets/fire.png',
          scale: 4,
        ),
      ),
    );
  }
}
