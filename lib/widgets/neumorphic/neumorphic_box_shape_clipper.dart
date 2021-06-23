import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeumorphicBoxShapeClipper extends StatelessWidget {
  final NeumorphicBoxShape shape;
  final Widget child;

  NeumorphicBoxShapeClipper({this.shape, this.child});

  CustomClipper _getClipper(NeumorphicBoxShape shape) {
    return shape.customShapePathProvider;
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _getClipper(this.shape),
      child: child,
    );
  }
}
