import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:sofy_new/models/api_profile_model.dart';

class ArticleAuthorDescription extends StatelessWidget {
  const ArticleAuthorDescription({Key key, this.author}) : super(key: key);
  final ApiProfileModel author;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      child: Row(
        children: [
          author.coverImg != null
              ? Row(
                  children: [
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(38)),
                        child: Stack(
                          children: [
                            Container(
                              height: 38,
                              width: 38,
                              child: ExtendedImage.network(
                                author.coverImg,
                                fit: BoxFit.cover,
                                cache: true,
                              ),
                              // ExtendedImage.network(
                              //                       'https://www.wikihow.com/images/thumb/4/45/Install-Windows-XP-on-an-ASUS-Eee-PC-Using-a-USB-Drive-Step-2-Version-2.jpg/v4-728px-Install-Windows-XP-on-an-ASUS-Eee-PC-Using-a-USB-Drive-Step-2-Version-2.jpg.webp',
                              //                       fit: BoxFit.cover,
                              //                       cache: true,
                              //                     ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                )
              : Container(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              author.username != null
                  ? Text(
                      author.username,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ExtendedImage.network(icon) : Container(), // todo insta logo
                  author.role != null
                      ? Text(
                          author.role,
                          style: TextStyle(fontSize: 13),
                        )
                      : Container(),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
