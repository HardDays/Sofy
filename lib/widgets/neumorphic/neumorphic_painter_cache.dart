import 'dart:ui';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'neumorphic_emboss_painteer_cache.dart';

class NeumorphicPainterCache extends AbstractNeumorphicEmbossPainterCache {
  @override
  Color generateShadowDarkColor({Color color, double intensity}) {
    return NeumorphicColors.decorationDarkColor(color, intensity: intensity);
  }

  @override
  Color generateShadowLightColor({Color color, double intensity}) {
    return NeumorphicColors.decorationWhiteColor(color, intensity: intensity);
  }

  @override
  void updateTranslations() {
    //no-op, used only for emboss
  }

  @override
  Rect updateLayerRect({Offset newOffset, Size newSize}) {
    return Rect.fromLTRB(
      originOffset.dx - newSize.width,
      originOffset.dy - newSize.height,
      originOffset.dx + 2 * newSize.width,
      originOffset.dy + 2 * newSize.height,
    );
  }
}
