import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';
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
          Positioned(
            top: 0,
            child: Container(
              width: 101 / Layout.width *
                  Layout.multiplier *
                  SizeConfig.blockSizeHorizontal,
              height: 107 / Layout.height *
                  Layout.multiplier *
                  SizeConfig.blockSizeVertical,
              child: Column(
                children: [
                  Container(
                    height: 67 /  Layout.height *
                        Layout.multiplier *
                        SizeConfig.blockSizeVertical,
                    width: 67 / Layout.width *
                        Layout.multiplier *
                        SizeConfig.blockSizeHorizontal,
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
                      color: selected ? Color(0xFFFFE1E8) : Color(0xFFFFFFFF),
                      shape: BoxShape.circle,
                      boxShadow: selected
                          ? null
                          : [
                        BoxShadow(
                          offset: Offset(1, 4),
                          color: Color(0xFFE2BED8),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ShaderMask(
                      shaderCallback: (Rect image) {
                        if (selected) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFfef6f9),Color(0xFFfca5be).withOpacity(0.5), Color(0xFFF95C8F)],
                            stops: [0.2, 0.37, 0.7],
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
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Image.asset(
                          iconPath,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    //model.titleEn,
                    AppLocalizations.of(context).translate(model.titleEn),
                    style: TextStyle(color:selected ? Color(0xFFCD2059) : Color(0xFFFDAABC), fontWeight: selected ? FontWeight.bold : FontWeight.normal),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
