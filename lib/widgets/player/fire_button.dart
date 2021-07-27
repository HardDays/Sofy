import 'package:flutter/material.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';

class FireButton extends StatelessWidget {
  const FireButton({Key key, this.onTap, this.selected}) : super(key: key);
  final Function onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            gradient: selected
                ? RadialGradient(
                    center: Alignment(0.10, 0.00),
                    stops: [0.0, 0.7, 1],
                    colors: [
                      Color(0xFFffe1e8),
                      Color(0xFFffe1e8),
                      Color(0xFFffcfda)
                    ],
                  )
                : null,
            shape: BoxShape.circle,
            color: selected ? Color(0xFFFFE1E8) : Color(0xffFCEFFC),
            //color: Color(0xffFCEFFC),
            boxShadow: selected
                ? null
                : [
                    BoxShadow(
                      offset: Offset(3, 3),
                      color: Color(0xFFdbbfd5),
                      blurRadius: 4,
                    )
                  ]),
        width: 42 /
            Layout.width *
            Layout.multiplier *
            SizeConfig.blockSizeHorizontal,
        height: 42 /
            Layout.width *
            Layout.multiplier *
            SizeConfig.blockSizeHorizontal,
        child: selected
            ? ShaderMask(
                shaderCallback: (Rect image) {
                  if (selected) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFD2DC).withOpacity(0.8),
                        Color(0xFFFFD2DC),
                        Color(0xFFF95C8F).withOpacity(0.93)
                      ],
                      stops: [0.37, 0.43, 0.65],
                    ).createShader(image);
                  }
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF38CA4).withOpacity(0.5),
                      Color(0xFFE0347A).withOpacity(0.5)
                    ],
                  ).createShader(image);
                },
                child: Image.asset(
                  'assets/fire.png',
                  scale: 4,
                ),
              )
            : Image.asset(
                'assets/fire.png',
                scale: 4,
              ),
      ),
    );
  }
}
