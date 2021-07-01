import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sofy_new/constants/app_colors.dart';

class PlayerScreenV2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        _BackgroundLinearColor(),
        _BackgroundImages(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              SizedBox(
                height: 55,
              ),
              _SelectableButtons(),
              SizedBox(
                height: 15,
              ),
              _CustomSlider(),
              _VibrationList(),
              _EqualizeLines(),
              _PowerAndFireButton(),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _BackgroundImages extends StatelessWidget {
  const _BackgroundImages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          left: 0,
          bottom: 120,
          child: SvgPicture.asset(
            'assets/svg/background1.svg',
          ),
        ),
        Positioned(
          right: 0,
          top: height / 4 * 2.6,
          child: SvgPicture.asset('assets/svg/background2.svg', ),
        ),
        Positioned(
          right: 0,
          child: SvgPicture.asset('assets/svg/background3.svg'),
        ),
        Positioned(
          left: 0,
          top: height / 3.3,
          child: SvgPicture.asset('assets/svg/background4.svg'),
        ),
      ],
    );
  }
}

class _EqualizeLines extends StatelessWidget {
  const _EqualizeLines({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.15,
      child: SvgPicture.asset('assets/svg/equalize_lines.svg'),
    );
  }
}

class _CustomSlider extends StatelessWidget {
  const _CustomSlider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height / 20 * 1.6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: kPlayerScrV2ButtonThemeColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 14.0,
                  width: 4.0,
                  child: SvgPicture.asset(
                    'assets/svg/vibration_vector.svg',
                    color: kPlayerScrV2MeleePinkColor,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 6,
                  height: 22,
                  child: SvgPicture.asset('assets/svg/vibration_vector.svg'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      8,
                      (index) => Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          height: 8.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: kPlayerScrV2SliderBoxColor[index]),
                        ),
                      ),
                    ),
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    trackShape: CustomTrackShape(),
                    thumbColor: Colors.redAccent,
                    //thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                    //overlayColor: Colors.red.withAlpha(32),
                    //overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                    thumbShape: CustomThumbShape(),
                    activeTrackColor: Colors.white.withOpacity(0),
                    inactiveTrackColor: Colors.white.withOpacity(0),
                    activeTickMarkColor: Colors.white.withOpacity(0),
                    inactiveTickMarkColor: Colors.white.withOpacity(0),
                  ),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeLeft: true,
                    removeRight: true,
                    child: Slider(
                      divisions: 40,
                      min: 0,
                      max: 100,
                      value: 20,
                      onChanged: (value) {
                        value = value;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 6,
                  height: 22,
                  child: SvgPicture.asset('assets/svg/vibration_vector.svg'),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  height: 30.0,
                  width: 10,
                  child: SvgPicture.asset(
                    'assets/svg/vibration_vector.svg',
                    color: kPlayerScrV2PinkColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(15);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
      Animation<double> enableAnimation,
      bool isDiscrete,
      TextPainter labelPainter,
      RenderBox parentBox,
      SliderThemeData sliderTheme,
      TextDirection textDirection,
      double value,
      double textScaleFactor,
      Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: kPlayerScrV2SliderColor,
      ).createShader(Rect.fromCircle(
        center: center,
        radius: 15,
      ));
    canvas.drawCircle(center, 12, paint);
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class _BackgroundLinearColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: kPlayerScrV2LinearGradientColor,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
        ),
      ),
    );
  }
}

class _SelectableButtons extends StatelessWidget {
  const _SelectableButtons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height / 20 * 1.3,
      decoration: BoxDecoration(
        color: kPlayerScrV2ButtonThemeColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _SelectableButtonsItem(
            text: 'Soft',
            selected: true,
            id: 0,
          ),
          _SelectableButtonsItem(
            text: 'Strong',
            selected: false,
            id: 1,
          ),
          _SelectableButtonsItem(
            text: 'Hard',
            selected: false,
            id: 2,
          ),
        ],
      ),
    );
  }
}

class _SelectableButtonsItem extends StatelessWidget {
  final int id;
  final String text;
  final Function onTap;
  final bool selected;

  const _SelectableButtonsItem(
      {Key key, this.id, this.text, this.onTap, this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(4),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: selected
                      ? kPlayerScrV2SelectedTextColor
                      : kPlayerScrV2UnselectedTextColor),
            ),
          ),
          decoration: selected
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: kPlayerScrV2ButtonGradientColor,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      offset: Offset(0, 1.5),
                      color: kPlayerScrV2ShadowColor.withOpacity(0.5),
                      blurRadius: 3,
                    ),
                  ],
                )
              : BoxDecoration(),
        ),
      ),
    );
  }
}

class CircleSelectableButton extends StatelessWidget {
  const CircleSelectableButton(
      {Key key,
      this.selected = false,
      @required this.id,
      @required this.iconPath,
      @required this.text})
      : super(key: key);
  final bool selected;
  final int id;
  final String iconPath;
  final String text;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
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
              borderRadius: BorderRadius.circular(width / 12),
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
                    stops: [0.45, 0.65],
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
            text,
            style: TextStyle(color: Color(0xFFFDAABC)),
          )
        ],
      ),
    );
  }
}

class _VibrationList extends StatelessWidget {
  const _VibrationList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleSelectableButton(
                text: 'Starfall',
                iconPath: 'assets/vibration_icons/Starfall.png',
                id: 0,
              ),
              CircleSelectableButton(
                selected: true,
                text: 'Wave',
                iconPath: 'assets/vibration_icons/Wave.png',
                id: 1,
              ),
              CircleSelectableButton(
                text: 'Tornado',
                iconPath: 'assets/vibration_icons/Tornado.png',
                id: 1,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleSelectableButton(
                text: 'Firework',
                iconPath: 'assets/vibration_icons/Firework.png',
                id: 0,
              ),
              CircleSelectableButton(
                text: 'Mild pulse',
                iconPath: 'assets/vibration_icons/Mild pulse.png',
                id: 1,
              ),
              CircleSelectableButton(
                text: 'Waterfall',
                iconPath: 'assets/vibration_icons/Waterfall.png',
                id: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PowerAndFireButton extends StatelessWidget {
  const _PowerAndFireButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
            flex: 3,
            child: PowerButton(),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment(-1, 0),
              child: FireButton(),
            ),
          ),
        ],
      ),
    );
  }
}

class PowerButton extends StatelessWidget {
  const PowerButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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

class FireButton extends StatelessWidget {
  const FireButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
        width: 40,
        height: 40,
        child: Image.asset(
          'assets/fire.png',
          scale: 3,
        ),
      ),
    );
  }
}
