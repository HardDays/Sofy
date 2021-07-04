import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sofy_new/constants/app_colors.dart';
import 'package:sofy_new/providers/player.dart';
import 'package:sofy_new/widgets/playlist_playing_lead_widget.dart';

class PlayListLeadWidget extends StatelessWidget {
  final String url;
  final int created;
  final double width;
  final double height;

  PlayListLeadWidget({this.url, this.created, @required this.width, @required this.height});

  @override
  Widget build(BuildContext context) {
    return url != null ? Stack(
      children: <Widget>[
        SizedBox(
          height: height,
          width: width,
          child: Container(
            child: ClipRRect(
              borderRadius:
              BorderRadius.all(Radius.circular(15)),
              child: CachedNetworkImage(
                fadeInDuration: Duration(milliseconds: 0),
                fadeOutDuration: Duration(milliseconds: 0),
                placeholder: (context, url) => SizedBox(
                    width: height / 4.42,
                    height: height / 3.82,
                    child: Shimmer.fromColors(
                      baseColor: kShimmerBaseColor,
                      highlightColor: kAppPinkDarkColor,
                      direction: ShimmerDirection.ltr,
                      period: Duration(seconds: 2),
                      child: Container(
                        width: height / 4.1,
                        height: height / 3.65,
                        decoration: BoxDecoration(
                          color: kArticlesWhiteColor,
                          borderRadius:
                          BorderRadius.all(
                              Radius.circular(
                                  25.0)),
                        ),
                      ),
                    )),
//                                    errorWidget: (context, url, error) =>
//                                        Container(),
                imageUrl: url,
                fit: BoxFit.cover,
              ),
//              child: FadeInImage.assetNetwork(
//                placeholder:
//                'assets/player_placeholder.png',
//                image: url,
//                fit: BoxFit.cover,
//              ),
            ),
          ),
        ),
        Positioned.fill(child: _getPlayingMaskWidget(context)),
      ],
    ) :
    SizedBox(
      height: 56.0,
      width: 56.0,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kWelcomButtonDarkColor,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: SvgPicture.asset(
          'assets/svg/heart_filled.svg',
          width: MediaQuery.of(context).size.width/16.56,
          fit: BoxFit.fitWidth,
        ),
      ),
    ) ;
  }

  Widget _getPlayingMaskWidget(BuildContext context) {
    return AnimatedOpacity(
      opacity: Provider.of<Player>(context).isPlaying &&
          created == Provider.of<Player>(context).currentPlayListModel.dateCreated ? 1 : 0 ,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 500),
      child: PlayingLeadWidget(),
    );
  }
}
