import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'animated_scale.dart';

typedef void NeumorphicButtonClickListener();

@immutable
class NeumorphicCustomButton extends StatefulWidget {
  static const double PRESSED_SCALE = 0.99;
  static const double UNPRESSED_SCALE = 1.0;

  final Widget child;
  final NeumorphicStyle style;
  final double minDistance;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool pressed; //null, true, false
  final Duration duration;
  final Curve curve;
  final NeumorphicButtonClickListener onClick;
  final bool drawSurfaceAboveChild;
  final bool isEnabled;
  final bool provideHapticFeedback;

  final NeumorphicBoxShape _boxShape; //private
  NeumorphicBoxShape get boxShape => _boxShape;

   NeumorphicCustomButton({
    Key key,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
    this.margin = EdgeInsets.zero,
    this.child,
    this.drawSurfaceAboveChild = true,
    this.pressed,
    NeumorphicBoxShape boxShape,
    this.duration = Neumorphic.DEFAULT_DURATION,
    this.curve = Neumorphic.DEFAULT_CURVE,
    //this.accent,
    this.onClick,
    this.minDistance = -3,
    this.style = const NeumorphicStyle(),
    this.isEnabled = true,
    this.provideHapticFeedback = true,
  })  : _boxShape = boxShape ??
      NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(8))),
        super(key: key);

  @override
  _NeumorphicButtonState createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicCustomButton> {
  NeumorphicStyle initialStyle;

  double depth;
  bool pressed = false;

  void updateInitialStyle() {
    if (widget.style != initialStyle) {
      setState(() {
        this.initialStyle = widget.style;
        depth = widget.style.depth;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updateInitialStyle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateInitialStyle();
  }

  @override
  void didUpdateWidget(NeumorphicCustomButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateInitialStyle();
  }

  Future<void> _handlePress() async {
    hasFinishedAnimationDown = false;
    setState(() {
      pressed = true;
      depth = widget.minDistance;
    });

    await Future.delayed(widget.duration);
    hasFinishedAnimationDown = true;

    //haptic vibration
    if (widget.provideHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    _resetIfTapUp();
  }

  bool hasDisposed = false;

  @override
  void dispose() {
    super.dispose();
    hasDisposed = true;
  }

  void _resetIfTapUp() {
    if (hasFinishedAnimationDown == true && hasTapUp == true && !hasDisposed) {
      setState(() {
        pressed = false;
        depth = initialStyle.depth;

        hasFinishedAnimationDown = false;
        hasTapUp = false;
      });
    }
  }

  bool get clickable {
    return widget.isEnabled && widget.onClick != null;
  }

  bool hasFinishedAnimationDown = false;
  bool hasTapUp = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (detail) {
        hasTapUp = false;
        if (clickable && !pressed) {
          _handlePress();
        }
      },
      onTapUp: (details) {
        if (clickable) {
          widget.onClick();
        }
        hasTapUp = true;
        _resetIfTapUp();
      },
      onTapCancel: () {
        hasTapUp = true;
        _resetIfTapUp();
      },
      child: AnimatedScale(
        scale: _getScale(),
        child: Neumorphic(
          margin: widget.margin,
          drawSurfaceAboveChild: widget.drawSurfaceAboveChild,
          duration: widget.duration,
          curve: widget.curve,
          padding: widget.padding,
          style: initialStyle.copyWith(depth: _getDepth(),
            boxShape: widget.boxShape),
          child: widget.child,
        ),
      ),
    );
  }

  double _getDepth() {
    if (widget.isEnabled) {
      return this.depth;
    } else {
      return 0;
    }
  }

  double _getScale() {
    if (widget.pressed != null) {
      return widget.pressed
          ? NeumorphicCustomButton.PRESSED_SCALE
          : NeumorphicCustomButton.UNPRESSED_SCALE;
    } else {
      return this.pressed
          ? NeumorphicCustomButton.PRESSED_SCALE
          : NeumorphicCustomButton.UNPRESSED_SCALE;
    }
  }
}
