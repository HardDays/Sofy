import 'package:flutter/material.dart';

class SalomonBottomBar extends StatelessWidget {
  /// A bottom bar that faithfully follows the design by Aurélien Salomon
  ///
  /// https://dribbble.com/shots/5925052-Google-Bottom-Bar-Navigation-Pattern/
  SalomonBottomBar({
    Key key,
    @required this.items,
    this.currentIndex = 0,
    this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.margin = const EdgeInsets.all(8),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutQuint,
  }) : super(key: key);

  /// A list of tabs to display, ie `Home`, `Likes`, etc
  final List<SalomonBottomBarItem> items;

  /// The tab to display.
  final int currentIndex;

  /// Returns the index of the tab that was tapped.
  final Function(int) onTap;

  /// The color of the icon and text when the item is selected.
  final Color selectedItemColor;

  /// The color of the icon and text when the item is not selected.
  final Color unselectedItemColor;

  /// A convenience field for the margin surrounding the entire widget.
  final EdgeInsets margin;

  /// The padding of each item.
  final EdgeInsets itemPadding;

  /// The transition duration
  final Duration duration;

  /// The transition curve
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final item in items)
            TweenAnimationBuilder<double>(
              tween: Tween(
                end: items.indexOf(item) == currentIndex ? 1.0 : 0.0,
              ),
              curve: curve,
              duration: duration,
              builder: (context, t, _) {
                final _selectedColor = item.selectedColor ??
                    selectedItemColor ??
                    theme.primaryColor;

                final _unselectedColor = item.unselectedColor ??
                    unselectedItemColor ??
                    theme.iconTheme.color;

                return Material(
                  color: Color.lerp(_selectedColor.withOpacity(0.0),
                      _selectedColor, t),
                  shape: StadiumBorder(),
                  child: InkWell(
                    onTap: () => onTap?.call(items.indexOf(item)),
                    customBorder: StadiumBorder(),
                    focusColor: _selectedColor,
                    highlightColor: _selectedColor,
                    //splashColor: _selectedColor,
                    //hoverColor: _selectedColor,
                    child: Padding(
                      padding: itemPadding -
                          EdgeInsets.only(right: itemPadding.right * t),
                      child: Row(
                        children: [
                          IconTheme(
                            data: IconThemeData(
                              color: Color.lerp(
                                  _unselectedColor, _selectedColor, t),
                              size: 24,
                            ),
                            child: item.icon ?? SizedBox.shrink(),
                          ),
                          ClipRect(
                            child: SizedBox(
                              /// TODO: Constrain item height without a fixed value
                              ///
                              /// The Align property appears to make these full height, would be
                              /// best to find a way to make it respond only to padding.
                              height: MediaQuery.of(context).size.height / 34.97,
                              child: Align(
                                alignment: Alignment(-0.2, 0.0),
                                widthFactor: t,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: itemPadding.right / 2,
                                      right: itemPadding.right),
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                      color: Color.lerp(
                                          _selectedColor.withOpacity(0.0),
                                          _selectedColor,
                                          t),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    child: item.title ?? SizedBox.shrink(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// A tab to display in a [SalomonBottomBar]
class SalomonBottomBarItem {
  /// An icon to display.
  final Widget icon;

  /// Text to display, ie `Home`
  final Widget title;

  /// A primary color to use for this tab.
  final Color selectedColor;

  /// The color to display when this tab is not selected.
  final Color unselectedColor;

  SalomonBottomBarItem({
    @required this.icon,
    @required this.title,
    this.selectedColor,
    this.unselectedColor,
  })  : assert(icon != null, "Every SalomonBottomBarItem requires an icon."),
        assert(title != null, "Every SalomonBottomBarItem requires a title.");
}
