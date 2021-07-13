import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PowerButton extends StatelessWidget {
  const PowerButton({Key key, this.onTap}) : super(key: key);
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 125,
        height: 125,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(3, 4),
                color: Color(0xFFdbbfd5),
                blurRadius: 8,
                //spreadRadius: 0.1,
              )
            ],
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFD8E1),
                Color(0xFFFDB0C1),
                Color(0xFFE5356F),
              ],
              stops: [0.0, 0.3, 0.8],
            )),
        padding: const EdgeInsets.all(40),
        child: SvgPicture.asset(
          'assets/svg/power.svg',
          width: 40,
          height: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
