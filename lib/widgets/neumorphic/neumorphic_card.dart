import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sofy_new/constants/constants.dart';
import 'package:sofy_new/widgets/neumorphic/neumorphic_decoration.dart';

import 'neumorphic_box_shape_clipper.dart';

@immutable
class NeumorphicCard extends Neumorphic {
  final Widget child;

  final NeumorphicStyle style;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final NeumorphicBoxShape boxShape;
  final Curve curve;
  final Duration duration;
  final bool
  drawSurfaceAboveChild; //if true => boxDecoration & foreground decoration, else => boxDecoration does all the work

  NeumorphicCard({
    Key key,
    this.child,
    this.duration = DEFAULT_DURATION,
    this.curve = DEFAULT_CURVE,
    this.style,
    this.boxShape,
    this.textStyle,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.drawSurfaceAboveChild = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boxShape = this.boxShape ?? NeumorphicBoxShape.rect();
    final theme = NeumorphicTheme.currentTheme(context);
    final NeumorphicStyle style = (this.style ?? NeumorphicStyle())
        .copyWithThemeIfNull(theme)
        .applyDisableDepth();

    return _NeumorphicContainer(
      padding: this.padding,
      textStyle: this.textStyle,
      boxShape: boxShape,
      drawSurfaceAboveChild: this.drawSurfaceAboveChild,
      duration: this.duration,
      style: style,
      curve: this.curve,
      margin: this.margin,
      child: this.child,
    );
  }
}

class _NeumorphicContainer extends StatelessWidget {
  final NeumorphicStyle style;
  final TextStyle textStyle;
  final NeumorphicBoxShape boxShape;
  final Widget child;
  final EdgeInsets margin;
  final Duration duration;
  final Curve curve;
  final bool drawSurfaceAboveChild;
  final EdgeInsets padding;

  _NeumorphicContainer({
    Key key,
    @required this.child,
    @required this.padding,
    @required this.margin,
    @required this.duration,
    @required this.curve,
    @required this.style,
    @required this.textStyle,
    @required this.drawSurfaceAboveChild,
    @required this.boxShape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: this.textStyle ?? material.Theme.of(context).textTheme.bodyText2,
      child: AnimatedContainer(
        margin: this.margin,
        duration: this.duration,
        curve: this.curve,
        child: NeumorphicBoxShapeClipper(
          shape: this.boxShape,
          child: Padding(
            padding: this.padding,
            child: this.child,
          ),
        ),
        foregroundDecoration: NeumorphicDecorationCard(
          isForeground: true,
          renderingByPath:
          this.boxShape.customShapePathProvider.oneGradientPerPath,
          splitBackgroundForeground: this.drawSurfaceAboveChild,
          style: this.style,
          shape: this.boxShape,
        ),
        decoration: NeumorphicDecorationCard(
          isForeground: false,
          renderingByPath:
          this.boxShape.customShapePathProvider.oneGradientPerPath,
          splitBackgroundForeground: this.drawSurfaceAboveChild,
          style: this.style,
          shape: this.boxShape,
        ),
      ),
    );
  }
}
