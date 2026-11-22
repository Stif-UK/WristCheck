import 'package:flutter/material.dart';

class ResponsiveTwoColumnGrid extends StatelessWidget {
  const ResponsiveTwoColumnGrid({
    super.key,
    required this.children,
    this.breakpoint = 500.0,
    this.horizontalSpacing = 12.0,
    this.maxWidth = 960.0,
  });

  final List<Widget> children;
  final double breakpoint;
  final double horizontalSpacing;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useTwoColumns = constraints.maxWidth >= breakpoint;

        if (!useTwoColumns) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
        }

        final List<Widget> rows = [];
        for (int i = 0; i < children.length; i += 2) {
          final Widget left = children[i];
          final Widget right =
              i + 1 < children.length ? children[i + 1] : const SizedBox.shrink();

          rows.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                SizedBox(width: horizontalSpacing),
                Expanded(child: right),
              ],
            ),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rows,
            ),
          ),
        );
      },
    );
  }
}
