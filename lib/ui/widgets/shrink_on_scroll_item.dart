import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';

/// A wrapper widget that subtly shrinks its child as it scrolls behind and below
/// the floating bottom navigation bar at the bottom of the screen.
class ShrinkOnScrollItem extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;

  /// Optional override for enabling/disabling the shrink animation.
  /// If null, reads from [WristCheckController.enableShrinkOnScroll].
  final bool? enabled;

  /// Distance from the bottom of the screen where shrinking begins.
  final double shrinkStartOffset;

  /// Maximum scale reduction (e.g. 0.18 means item shrinks down to 0.82 scale).
  final double maxShrink;

  /// Maximum opacity reduction (e.g. 0.20 means opacity reduces down to 0.80).
  final double maxOpacityReduction;

  const ShrinkOnScrollItem({
    super.key,
    required this.child,
    required this.scrollController,
    this.enabled,
    this.shrinkStartOffset = 200.0,
    this.maxShrink = 0.18,
    this.maxOpacityReduction = 0.20,
  });

  @override
  State<ShrinkOnScrollItem> createState() => _ShrinkOnScrollItemState();
}

class _ShrinkOnScrollItemState extends State<ShrinkOnScrollItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<WristCheckController>()
        ? Get.find<WristCheckController>()
        : Get.put(WristCheckController());

    return Obx(() {
      final isEnabled = widget.enabled ?? controller.enableShrinkOnScroll.value;
      if (!isEnabled) {
        return widget.child;
      }

      return AnimatedBuilder(
        animation: widget.scrollController,
        builder: (context, child) {
          double scale = 1.0;
          double opacity = 1.0;

          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null && renderBox.hasSize && renderBox.attached) {
            final position = renderBox.localToGlobal(Offset.zero);
            final screenHeight = MediaQuery.of(context).size.height;

            final itemTop = position.dy;
            final itemHeight = renderBox.size.height;
            final itemCenter = itemTop + itemHeight / 2;

            final startThreshold = screenHeight - widget.shrinkStartOffset;
            final endThreshold = screenHeight - 20.0;

            if (itemCenter > startThreshold && endThreshold > startThreshold) {
              final rawProgress = ((itemCenter - startThreshold) / (endThreshold - startThreshold)).clamp(0.0, 1.0);
              final curveProgress = Curves.easeOut.transform(rawProgress);
              scale = 1.0 - (curveProgress * widget.maxShrink);
              opacity = 1.0 - (curveProgress * widget.maxOpacityReduction);
            }
          }

          return Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: Opacity(
              opacity: opacity,
              child: child,
            ),
          );
        },
        child: widget.child,
      );
    });
  }
}
