import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ResponsiveTwoColumnGrid extends StatelessWidget {
  const ResponsiveTwoColumnGrid({
    super.key,
    required this.children,
    this.breakpoint = 500.0,
    this.horizontalSpacing = 12.0,
    this.maxWidth = 960.0,
    this.packColumns = false,
  });

  final List<Widget> children;
  final double breakpoint;
  final double horizontalSpacing;
  final double maxWidth;
  final bool packColumns;

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

        if (packColumns) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: _MasonryTwoColumnLayout(
                horizontalSpacing: horizontalSpacing,
                children: children,
              ),
            ),
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

class _MasonryTwoColumnLayout extends MultiChildRenderObjectWidget {
  const _MasonryTwoColumnLayout({
    required this.horizontalSpacing,
    required super.children,
  });

  final double horizontalSpacing;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMasonryTwoColumnLayout(horizontalSpacing: horizontalSpacing);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMasonryTwoColumnLayout renderObject,
  ) {
    renderObject.horizontalSpacing = horizontalSpacing;
  }
}

class _MasonryParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderMasonryTwoColumnLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _MasonryParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _MasonryParentData> {
  _RenderMasonryTwoColumnLayout({required double horizontalSpacing})
      : _horizontalSpacing = horizontalSpacing;

  double _horizontalSpacing;
  double get horizontalSpacing => _horizontalSpacing;
  set horizontalSpacing(double value) {
    if (_horizontalSpacing == value) return;
    _horizontalSpacing = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _MasonryParentData) {
      child.parentData = _MasonryParentData();
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final double totalWidth = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : 0.0;
    final double columnWidth =
        ((totalWidth - _horizontalSpacing) / 2).clamp(0.0, double.infinity);
    final BoxConstraints childConstraints = BoxConstraints(
      minWidth: columnWidth,
      maxWidth: columnWidth,
    );

    double leftY = 0.0;
    double rightY = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      final Size childSize = child.getDryLayout(childConstraints);
      if (leftY <= rightY) {
        leftY += childSize.height;
      } else {
        rightY += childSize.height;
      }
      child = childAfter(child);
    }

    return constraints.constrain(
      Size(totalWidth, math.max(leftY, rightY)),
    );
  }

  @override
  void performLayout() {
    final double totalWidth = constraints.maxWidth.isFinite
        ? constraints.maxWidth
        : constraints.minWidth;
    final double columnWidth =
        ((totalWidth - _horizontalSpacing) / 2).clamp(0.0, double.infinity);
    final BoxConstraints childConstraints = BoxConstraints(
      minWidth: columnWidth,
      maxWidth: columnWidth,
    );

    double leftY = 0.0;
    double rightY = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      child.layout(childConstraints, parentUsesSize: true);
      final _MasonryParentData childParentData =
          child.parentData! as _MasonryParentData;
      if (leftY <= rightY) {
        childParentData.offset = Offset(0.0, leftY);
        leftY += child.size.height;
      } else {
        childParentData.offset = Offset(columnWidth + _horizontalSpacing, rightY);
        rightY += child.size.height;
      }
      child = childParentData.nextSibling;
    }

    size = constraints.constrain(
      Size(totalWidth, math.max(leftY, rightY)),
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
