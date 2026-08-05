import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:wristcheck/ui/widgets/icons/wt_static_icon.dart';

class WTBannerIcon extends StatefulWidget {
  const WTBannerIcon({super.key, required this.fallbackIconDimensions});
  final double fallbackIconDimensions;

  @override
  State<WTBannerIcon> createState() => _WTBannerIconState();
}

class _WTBannerIconState extends State<WTBannerIcon> {
  // 1. Create an Asset FileLoader
  late final _fileLoader = FileLoader.fromAsset('assets/animation/wt_banner_icon.riv', riveFactory: Factory.rive);

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: _fileLoader,
      builder: (context, state) {
        // 2. Match the sealed loader states
        return switch (state) {
          RiveLoading() => const CircularProgressIndicator(),
          RiveFailed(:final error) => WtStaticIcon(dimensions: widget.fallbackIconDimensions,),
          RiveLoaded(:final controller) => RiveWidget(
            controller: controller,
            fit: Fit.contain,
          ),
        };
      },
    );
  }
}