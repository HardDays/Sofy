import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/providers/app_localizations.dart';

class CurvedNavBarItem extends StatelessWidget {
  const CurvedNavBarItem({Key key, @required this.title, @required this.svgAsset, this.selected =false}) : super(key: key);
  final bool selected;
  final String title;
  final String svgAsset;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: selected ? null : EdgeInsets.only(top: 20),
      //color: Colors.red,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(svgAsset, color: selected ? null : Color(0xFFE1D2D5),),
          if(!selected)
            SizedBox(height: 10,),
          if(!selected)
            Text(
              AppLocalizations.of(context).translate(title),
              style: TextStyle(color: selected ? Color(0XFFFAA3B8) : Color(0xFFE1D2D5),),
            ),
        ],
      ),
    );
  }
}
