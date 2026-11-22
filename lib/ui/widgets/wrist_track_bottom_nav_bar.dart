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

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  final NavBarAlignment navBarAlignment;

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.sizeOf(context).width >= largeScreenBreakpoint;

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
        child: isLargeScreen
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
