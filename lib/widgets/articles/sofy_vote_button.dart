import 'package:flutter/material.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/helper/size_config.dart';

class SofyVoteButton extends StatelessWidget {
  const SofyVoteButton({Key key, this.callback, this.label = 'btn with ctar', this.isBordered = false}) : super(key: key);

  final bool isBordered;
  final VoidCallback callback;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            color: isBordered ? SofyVoteButtonColors.SelectedBgColor : SofyVoteButtonColors.BgColor,
            borderRadius: BorderRadius.circular(13),
            border: isBordered
                ? Border.all(width: 1.5, color: SofyVoteButtonColors.BorderColor)
                : Border.all(
                    width: 1.5,
                    color: SofyVoteButtonColors.BgColor,
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                  constraints: new BoxConstraints(minWidth: 0.5 * Layout.width, maxWidth: 0.7 * Layout.width, minHeight: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(color: SofyVoteButtonColors.TextColor, fontSize: 16, fontFamily: Fonts.HindGuntur, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: isBordered ? SofyVoteButtonColors.SelectedRoundedColor : SofyVoteButtonColors.NotSelectedRoundedColor),
                      child: isBordered
                          ? Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : Container(),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        onTap: callback,
      ),
    );
  }
}
