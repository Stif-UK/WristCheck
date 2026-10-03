import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:wristcheck/ui/widgets/icons/wt_static_icon.dart';

class WTAnnualRecapAnimation extends StatefulWidget {
  const WTAnnualRecapAnimation({
    super.key,
    required this.fallbackIconDimensions,
    this.watchStyle,
    this.timeSec,
    this.timeMin,
    this.timeHour,
    this.timeHourDIG,
    this.timeDay,
    this.timeDate,
    this.top1Watch,
    this.top2Watch,
    this.top3Watch,
    this.onControllerReady,
    this.fit = Fit.fill,
  });

  final double fallbackIconDimensions;
  final String? watchStyle;
  final double? timeSec;
  final double? timeMin;
  final double? timeHour;
  final double? timeHourDIG;
  final String? timeDay;
  final double? timeDate;
  final String? top1Watch;
  final String? top2Watch;
  final String? top3Watch;
  final ValueChanged<WTAnnualRecapAnimationController?>? onControllerReady;
  final Fit fit;

  @override
  State<WTAnnualRecapAnimation> createState() => WTAnnualRecapAnimationState();
}

class WTAnnualRecapAnimationController {
  final RiveWidgetController controller;
  ViewModelInstance? _vmi;

  WTAnnualRecapAnimationController(this.controller) {
    try {
      _vmi = controller.dataBind(const AutoBind());
    } catch (_) {}
  }

  void setNumber(String name, double value) {
    try {
      _vmi?.number(name)?.value = value;
    } catch (_) {}
  }

  void setString(String name, String value) {
    try {
      _vmi?.string(name)?.value = value;
    } catch (_) {}
  }

  void fireTrigger(String name) {
    try {
      // Let's test if controller.stateMachine has input or trigger method
      // controller.stateMachine.input(name);
    } catch (_) {}
  }
}

class WTAnnualRecapAnimationState extends State<WTAnnualRecapAnimation> {
  late final _fileLoader = FileLoader.fromAsset('assets/animation/annual_recap_demo.riv', riveFactory: Factory.flutter);
  WTAnnualRecapAnimationController? _animController;

  @override
  void didUpdateWidget(covariant WTAnnualRecapAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_animController != null) {
      _applyInputs(widget, _animController!);
    }
  }

  void _applyInputs(WTAnnualRecapAnimation w, WTAnnualRecapAnimationController ctrl) {
    if (w.timeSec != null) ctrl.setNumber('timeSec', w.timeSec!);
    if (w.timeMin != null) ctrl.setNumber('timeMin', w.timeMin!);
    if (w.timeHour != null) ctrl.setNumber('timeHour', w.timeHour!);
    if (w.timeHourDIG != null) ctrl.setNumber('timeHourDIG', w.timeHourDIG!);
    if (w.timeDate != null) ctrl.setNumber('timeDate', w.timeDate!);
    if (w.timeDay != null) ctrl.setString('timeDay', w.timeDay!);
    if (w.top1Watch != null) ctrl.setString('top1Watch', w.top1Watch!);
    if (w.top2Watch != null) ctrl.setString('top2Watch', w.top2Watch!);
    if (w.top3Watch != null) ctrl.setString('top3Watch', w.top3Watch!);
    if (w.watchStyle != null) ctrl.setString('watchStyle', w.watchStyle!);
  }

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: _fileLoader,
      builder: (context, state) {
        return switch (state) {
          RiveLoading() => const CircularProgressIndicator(),
          RiveFailed() => WtStaticIcon(dimensions: widget.fallbackIconDimensions,),
          RiveLoaded(:final controller) => Builder(
            builder: (context) {
              final animCtrl = WTAnnualRecapAnimationController(controller);
              _animController = animCtrl;
              _applyInputs(widget, animCtrl);
              widget.onControllerReady?.call(animCtrl);
              return RiveWidget(
                controller: controller,
                fit: widget.fit,
              );
            },
          ),
        };
      },
    );
  }
}
