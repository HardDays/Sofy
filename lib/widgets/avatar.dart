import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key key, this.coverImgUrl = '', this.side = 38})
      : super(key: key);

  final String coverImgUrl;
  final double side;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(38)),
        boxShadow: [
          BoxShadow(
            color: Color(0xffCFB2CD),
            offset: Offset(4, 4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Color(0xffffffff),
            offset: Offset(-4, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(38)),
        child: Stack(
          children: [
            Container(
              height: side,
              width: side,
              color: Colors.white,
              child: coverImgUrl != ''
                  ? ExtendedImage.network(
                      coverImgUrl,
                      fit: BoxFit.cover,
                      cache: true,
                    )
                  : Container(),
              // ExtendedImage.network(
              //                       'https://www.wikihow.com/images/thumb/4/45/Install-Windows-XP-on-an-ASUS-Eee-PC-Using-a-USB-Drive-Step-2-Version-2.jpg/v4-728px-Install-Windows-XP-on-an-ASUS-Eee-PC-Using-a-USB-Drive-Step-2-Version-2.jpg.webp',
              //                       fit: BoxFit.cover,
              //                       cache: true,
              //                     ),
            ),
          ],
        ),
      ),
    );
  }
}
