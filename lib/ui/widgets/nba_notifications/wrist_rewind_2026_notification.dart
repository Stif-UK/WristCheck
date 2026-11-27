import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/ui/widgets/icons/wt_static_icon.dart';
import 'package:wristcheck/ui/wrist_recap/animated_recap_preview_page.dart';

class WristRewind2026Notification extends StatefulWidget {
  const WristRewind2026Notification({
    super.key,
    this.animationOverride,
  });

  final Widget? animationOverride;

  @override
  State<WristRewind2026Notification> createState() =>
      _WristRewind2026NotificationState();
}

class _WristRewind2026NotificationState
    extends State<WristRewind2026Notification> {
  final WristCheckController wristCheckController =
      Get.find<WristCheckController>();
  FileLoader? _fileLoader;
  ViewModelInstance? _vmi;

  @override
  void initState() {
    super.initState();
    if (widget.animationOverride == null) {
      _fileLoader = FileLoader.fromAsset(
        'assets/animation/wristtrack_rewind_notification.riv',
        riveFactory: Factory.flutter,
      );
    }
  }

  @override
  void dispose() {
    _vmi?.dispose();
    _fileLoader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _navigateAndDismiss,
      child: widget.animationOverride ?? _buildRiveAnimation(),
    );
  }

  Widget _buildRiveAnimation() {
    return RiveWidgetBuilder(
      fileLoader: _fileLoader!,
      onLoaded: (state) {
        _vmi?.dispose();
        _vmi = null;
        try {
          _vmi = state.controller.dataBind(const AutoBind());
        } catch (e) {
          debugPrint('WristRewind2026Notification AutoBind skipped: $e');
        }
      },
      builder: (context, state) {
        return switch (state) {
          RiveLoading() => const SizedBox(
              width: double.infinity,
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            ),
          RiveFailed() => const SizedBox(
              width: double.infinity,
              height: 120,
              child: Center(child: WtStaticIcon(dimensions: 48)),
            ),
          RiveLoaded(:final controller) => _buildLoadedAnimation(controller),
        };
      },
    );
  }

  Widget _buildLoadedAnimation(RiveWidgetController controller) {
    final bounds = controller.artboard.bounds;
    final double aspectRatio =
        (bounds.width > 0 && bounds.height > 0)
            ? bounds.width / bounds.height
            : 3.0;

    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 50, maxHeight: 120),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: RiveWidget(
            controller: controller,
            fit: Fit.contain,
            hitTestBehavior: RiveHitTestBehavior.translucent,
          ),
        ),
      ),
    );
  }

  void _navigateAndDismiss() {
    // Perform navigation BEFORE dismissing the notification.
    // Calling dismissWristRewind2026Notification immediately removes this widget from the tree (via Obx in WristCheckHome/Watchbox),
    // which can interrupt the navigation process or invalidate the context.
    Get.to(() => const AnimatedRecapPreviewPage());
    wristCheckController.dismissWristRewind2026Notification();
  }
}
