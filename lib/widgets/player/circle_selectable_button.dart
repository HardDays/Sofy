import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/models/api_vibration_model.dart';
import 'package:sofy_new/models/subscribe_data.dart';
import 'package:sofy_new/providers/app_localizations.dart';

class CircleSelectableButton extends StatelessWidget {
  const CircleSelectableButton(
      {Key key,
        this.selected = false,
        @required this.iconPath,
        @required this.model,
        this.onTap})
      : super(key: key);

  final ApiVibrationModel model;
  final bool selected;
  final String iconPath;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final bool isAppPurchase =
        Provider.of<SubscribeData>(context).isAppPurchase;
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                height: width / 6,
                width: width / 6,
                decoration: BoxDecoration(
                  gradient: selected
                      ? RadialGradient(
                    center: Alignment(0.07, 0.12),
                    stops: [0.0, 0.7, 1],
                    colors: [
                      Color(0xFFffe1e8),
                      Color(0xFFffe1e8),
                      Color(0xFFffcfda)
                    ],
                  )
                      : null,
                  color: selected ? Color(0xFFFFE1E8) : Color(0xFFFFFFFF),
                  //borderRadius: BorderRadius.circular(width / 12),
                  shape: BoxShape.circle,
                  boxShadow: selected
                      ? null
                      : [
                    BoxShadow(
                      offset: Offset(1, 4),
                      color: Color(0xFFE2BED8),
                      blurRadius: 8,
                      //spreadRadius: 0.1,
                    ),
                  ],
                ),
                child: ShaderMask(
                  shaderCallback: (Rect image) {
                    if (selected) {
                      return LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFD2DC), Color(0xFFF95C8F)],
                        stops: [0.3, 1],
                      ).createShader(image);
                    }
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFBBCA).withOpacity(0.5),
                        Color(0xFFFFBBCA).withOpacity(0.5)
                      ],
                    ).createShader(image);
                  },
                  child: Image.asset(
                    iconPath,
                    scale: 1.5,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                //model.titleEn,
                AppLocalizations.of(context).translate(model.titleEn),
                style: TextStyle(color:selected ? Color(0xFFCD2059) : Color(0xFFFDAABC)),
              )
            ],
          ),
          // Visibility(
          //   // ignore: null_aware_in_logical_operator
          //   visible: model.isTrial ? false : true,
          //   child: Positioned(
          //     right: 15,
          //     top: 0,
          //     child: Container(
          //         height: isAppPurchase
          //             ? 0.0
          //             : 50,
          //         width: isAppPurchase
          //             ? 0.0
          //             : 50,
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           image: DecorationImage(
          //             image: AssetImage('assets/new_lock.png'),
          //             fit: BoxFit.fill,
          //           ),
          //         )),
          //   ),
          // )
        ],
      ),
    );
  }
}
