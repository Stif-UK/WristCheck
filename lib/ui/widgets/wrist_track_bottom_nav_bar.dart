import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wristcheck/model/enums/navbar_alignment.dart';

class WristTrackBottomNavBar extends StatelessWidget {
  const WristTrackBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.navBarAlignment = NavBarAlignment.right,
  }) : super(key: key);

  static const double largeScreenBreakpoint = 600.0;
  static const double largeScreenMaxWidth = 420.0;

  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= largeScreenBreakpoint;

  static bool isRightCutoutPortraitDevice(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return false;
    }
    if (isLargeScreen(context)) {
      return false;
    }
    final MediaQueryData mq = MediaQuery.of(context);
    return mq.orientation == Orientation.portrait && mq.viewPadding.right > 0;
  }

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  final NavBarAlignment navBarAlignment;

  @override
  Widget build(BuildContext context) {
    final bool largeScreen = isLargeScreen(context);

    final Widget navContainer = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            currentIndex: currentIndex,
            onTap: onTap,
            items: items,
          ),
        ),
      ),
    );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
        child: largeScreen
            ? Align(
                alignment: navBarAlignment.toAlignment(),
                heightFactor: 1.0,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: largeScreenMaxWidth),
                  child: navContainer,
                ),
              )
            : navContainer,
      ),
    );
  }
}

class WristTrackRightNavRail extends StatelessWidget {
  const WristTrackRightNavRail({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  static const double minRailWidth = 56.0;
  static const double maxRailWidth = 72.0;
  static const double outerRightMargin = 6.0;
  static const double contentGap = 6.0;

  static double railWidthForContext(BuildContext context) {
    final double rightSafeInset = MediaQuery.viewPaddingOf(context).right;
    return math.max(minRailWidth, rightSafeInset - outerRightMargin * 2).clamp(minRailWidth, maxRailWidth);
  }

  static double reservedContentRightWidth(BuildContext context) {
    final double rightSafeInset = MediaQuery.viewPaddingOf(context).right;
    final double railWidth = railWidthForContext(context);
    return math.max(rightSafeInset, railWidth + outerRightMargin + contentGap);
  }

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final BottomNavigationBarThemeData navTheme = theme.bottomNavigationBarTheme;
    final Color backgroundColor = navTheme.backgroundColor ?? theme.canvasColor;
    final Color selectedColor = navTheme.selectedItemColor ?? theme.colorScheme.primary;
    final Color unselectedColor = navTheme.unselectedItemColor ?? theme.unselectedWidgetColor;
    final double width = railWidthForContext(context);

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(-2, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(items.length, (index) {
              final BottomNavigationBarItem item = items[index];
              final bool isSelected = index == currentIndex;
              final Color itemColor = isSelected ? selectedColor : unselectedColor;
              final String label = item.label ?? '';

              return Semantics(
                button: true,
                selected: isSelected,
                label: label,
                child: Tooltip(
                  message: item.tooltip ?? label,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onTap(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconTheme(
                              data: IconThemeData(color: itemColor, size: 20.0),
                              child: isSelected ? item.activeIcon : item.icon,
                            ),
                            if (label.isNotEmpty) ...[
                              const SizedBox(height: 3.0),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  label,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    color: itemColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class WristTrackRightRailBody extends StatelessWidget {
  const WristTrackRightRailBody({
    Key? key,
    required this.child,
    required this.rightRail,
    this.floatingActionButton,
    this.applyBottomSafeArea = false,
    this.applyHorizontalPadding = true,
  }) : super(key: key);

  final Widget child;
  final Widget rightRail;
  final Widget? floatingActionButton;
  final bool applyBottomSafeArea;
  final bool applyHorizontalPadding;

  @override
  Widget build(BuildContext context) {
    final double leftSafePadding = applyHorizontalPadding ? MediaQuery.paddingOf(context).left : 0.0;
    final double bottomSafePadding = MediaQuery.viewPaddingOf(context).bottom;
    final double rightRailReservedWidth = applyHorizontalPadding
        ? WristTrackRightNavRail.reservedContentRightWidth(context)
        : 0.0;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: leftSafePadding,
            right: rightRailReservedWidth,
            bottom: applyBottomSafeArea ? bottomSafePadding : 0.0,
          ),
          child: MediaQuery.removePadding(
            context: context,
            removeLeft: applyHorizontalPadding,
            removeRight: applyHorizontalPadding,
            removeBottom: applyBottomSafeArea,
            child: floatingActionButton == null
                ? child
                : Stack(
                    children: [
                      child,
                      Positioned(
                        right: 16.0,
                        bottom: math.max(bottomSafePadding, 16.0),
                        child: floatingActionButton!,
                      ),
                    ],
                  ),
          ),
        ),
        Positioned(
          right: WristTrackRightNavRail.outerRightMargin,
          top: 48.0,
          bottom: math.max(bottomSafePadding, 12.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: rightRail,
          ),
        ),
      ],
    );
  }
}
