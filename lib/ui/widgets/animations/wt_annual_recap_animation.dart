import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:wristcheck/ui/widgets/icons/wt_static_icon.dart';
import 'package:wristcheck/config.dart';

class WTAnnualRecapAnimation extends StatefulWidget {
  const WTAnnualRecapAnimation({
    super.key,
    required this.fallbackIconDimensions,
    this.artboardName = 'MAIN',
    this.enoughData,
    this.daysTracked,
    this.totalWearsTracked,
    this.watchesWorn,
    this.totalBought,
    this.totalSold,
    this.topWatchStyle,
    this.top1Watch,
    this.top1WatchWorn,
    this.topWatch1ICON,
    this.top2Watch,
    this.top2WatchWorn,
    this.topWatch2ICON,
    this.top3Watch,
    this.top3WatchWorn,
    this.topWatch3ICON,
    this.springWatchTEXT,
    this.springWatch,
    this.summerWatchTEXT,
    this.summerWatch,
    this.autumnWatchTEXT,
    this.autumnWatch,
    this.winterWatchTEXT,
    this.winterWatch,
    // Legacy / optional inputs
    this.watchStyle,
    this.timeSec,
    this.timeMin,
    this.timeHour,
    this.timeHourDIG,
    this.timeDay,
    this.timeDate,
    this.onControllerReady,
    this.onScreenshotTrigger,
    this.onFinalSlide,
    this.fit = Fit.contain,
  });

  final double fallbackIconDimensions;
  final String artboardName;
  final bool? enoughData;
  final double? daysTracked;
  final double? totalWearsTracked;
  final double? watchesWorn;
  final double? totalBought;
  final double? totalSold;
  final String? topWatchStyle;
  final String? top1Watch;
  final double? top1WatchWorn;
  final String? topWatch1ICON;
  final String? top2Watch;
  final double? top2WatchWorn;
  final String? topWatch2ICON;
  final String? top3Watch;
  final double? top3WatchWorn;
  final String? topWatch3ICON;
  final String? springWatchTEXT;
  final String? springWatch;
  final String? summerWatchTEXT;
  final String? summerWatch;
  final String? autumnWatchTEXT;
  final String? autumnWatch;
  final String? winterWatchTEXT;
  final String? winterWatch;

  // Legacy / optional inputs
  final String? watchStyle;
  final double? timeSec;
  final double? timeMin;
  final double? timeHour;
  final double? timeHourDIG;
  final String? timeDay;
  final double? timeDate;
  final ValueChanged<WTAnnualRecapAnimationController?>? onControllerReady;
  final VoidCallback? onScreenshotTrigger;
  final VoidCallback? onFinalSlide;
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
    } catch (e1) {
      debugPrint("WTAnnualRecapAnimation: AutoBind failed ($e1). Trying BindByName('ViewModel1')...");
      try {
        _vmi = controller.dataBind(const BindByName('ViewModel1'));
      } catch (e2) {
        debugPrint("WTAnnualRecapAnimation: BindByName failed ($e2). Trying BindByIndex(0)...");
        try {
          _vmi = controller.dataBind(const BindByIndex(0));
        } catch (e3) {
          debugPrint("WTAnnualRecapAnimation: BindByIndex failed ($e3). Trying BindEmpty()...");
          try {
            _vmi = controller.dataBind(const BindEmpty());
          } catch (e4) {
            debugPrint("WTAnnualRecapAnimation: All dataBind attempts failed: $e4");
          }
        }
      }
    }
  }

  void setNumber(String name, double value) {
    try {
      _vmi?.number(name)?.value = value;
    } catch (e) {
      debugPrint("Error setting number '$name': $e");
    }
  }

  void setString(String name, String value) {
    try {
      _vmi?.string(name)?.value = value;
    } catch (e) {
      debugPrint("Error setting string '$name': $e");
    }
  }

  void setEnum(String name, String value) {
    try {
      _vmi?.enumerator(name)?.value = value;
    } catch (e) {
      debugPrint("Error setting enum '$name': $e");
    }
  }

  void setBoolean(String name, bool value) {
    try {
      _vmi?.boolean(name)?.value = value;
    } catch (e) {
      debugPrint("Error setting boolean '$name': $e");
    }
  }

  void fireTrigger(String name) {
    try {
      _vmi?.trigger(name)?.trigger();
    } catch (e) {
      debugPrint("Error firing trigger '$name': $e");
    }
  }

  final List<(ViewModelInstanceObservableValue<bool>, void Function(bool))> _boolSubscriptions = [];

  void addTriggerListener(String name, void Function(bool) listener) {
    try {
      final triggerProp = _vmi?.trigger(name);
      if (triggerProp == null) {
        debugPrint("WTAnnualRecapAnimation: trigger '$name' not found on ViewModel");
        return;
      }
      triggerProp.addListener(listener);
      _boolSubscriptions.add((triggerProp, listener));
    } catch (e) {
      debugPrint("Error adding trigger listener '$name': $e");
    }
  }

  void addBooleanListener(
    String name,
    void Function(bool) listener, {
    bool notifyInitial = false,
  }) {
    try {
      final boolProp = _vmi?.boolean(name);
      if (boolProp == null) {
        debugPrint("WTAnnualRecapAnimation: boolean '$name' not found on ViewModel");
        return;
      }
      boolProp.addListener(listener);
      _boolSubscriptions.add((boolProp, listener));
      if (notifyInitial) {
        listener(boolProp.value);
      }
    } catch (e) {
      debugPrint("Error adding boolean listener '$name': $e");
    }
  }

  void dispose() {
    for (final (prop, listener) in _boolSubscriptions) {
      prop.removeListener(listener);
      prop.dispose();
    }
    _boolSubscriptions.clear();
  }
}

class WTAnnualRecapAnimationState extends State<WTAnnualRecapAnimation> {
  late final _fileLoader = FileLoader.fromAsset(
    'assets/animation/wristtrack_recap_23_11.riv',
    riveFactory: Factory.flutter,
  );
  WTAnnualRecapAnimationController? _animController;

  void _onScreenshotTrigger(bool _) {
    widget.onScreenshotTrigger?.call();
  }

  void _onFinalSlideChanged(bool isFinalSlide) {
    if (isFinalSlide) {
      widget.onFinalSlide?.call();
    }
  }

  @override
  void dispose() {
    _animController?.dispose();
    _fileLoader.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WTAnnualRecapAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_animController != null) {
      _applyInputs(widget, _animController!);
    }
  }

  void _applyInputs(WTAnnualRecapAnimation w, WTAnnualRecapAnimationController ctrl) {
    if (w.enoughData != null) ctrl.setBoolean('enoughData', w.enoughData!);
    if (w.daysTracked != null) ctrl.setNumber('daysTracked', w.daysTracked!);
    if (w.totalWearsTracked != null) ctrl.setNumber('totalWearsTracked', w.totalWearsTracked!);
    if (w.watchesWorn != null) ctrl.setNumber('watchesWorn', w.watchesWorn!);
    if (w.totalBought != null) ctrl.setNumber('totalBought', w.totalBought!);
    if (w.totalSold != null) ctrl.setNumber('totalSold', w.totalSold!);
    if (w.topWatchStyle != null) ctrl.setString('topStyleTEXT', w.topWatchStyle!);
    if (w.top1Watch != null) ctrl.setString('top1WatchTEXT', w.top1Watch!);
    if (w.top1WatchWorn != null) ctrl.setNumber('top1WatchWorn', w.top1WatchWorn!);
    if (w.topWatch1ICON != null) ctrl.setEnum('topWatch1ICON', w.topWatch1ICON!);
    if (w.top2Watch != null) ctrl.setString('top2WatchTEXT', w.top2Watch!);
    if (w.top2WatchWorn != null) ctrl.setNumber('top2WatchWorn', w.top2WatchWorn!);
    if (w.topWatch2ICON != null) ctrl.setEnum('topWatch2ICON', w.topWatch2ICON!);
    if (w.top3Watch != null) ctrl.setString('top3WatchTEXT', w.top3Watch!);
    if (w.top3WatchWorn != null) ctrl.setNumber('top3WatchWorn', w.top3WatchWorn!);
    if (w.topWatch3ICON != null) ctrl.setEnum('topWatch3ICON', w.topWatch3ICON!);
    if (w.springWatchTEXT != null) ctrl.setString('springWatchTEXT', w.springWatchTEXT!);
    if (w.springWatch != null) ctrl.setEnum('springWatchICON', w.springWatch!);
    if (w.summerWatchTEXT != null) ctrl.setString('summerWatchTEXT', w.summerWatchTEXT!);
    if (w.summerWatch != null) ctrl.setEnum('summerWatchICON', w.summerWatch!);
    if (w.autumnWatchTEXT != null) ctrl.setString('autumnWatchTEXT', w.autumnWatchTEXT!);
    if (w.autumnWatch != null) ctrl.setEnum('autumnWatchICON', w.autumnWatch!);
    if (w.winterWatchTEXT != null) ctrl.setString('winterWatchTEXT', w.winterWatchTEXT!);
    if (w.winterWatch != null) ctrl.setEnum('winterWatchICON', w.winterWatch!);

    // Time & date inputs for "WristTrack rewind" clock physics animation
    if (w.timeSec != null) ctrl.setNumber('timeSec', w.timeSec!);
    if (w.timeMin != null) ctrl.setNumber('timeMin', w.timeMin!);
    if (w.timeHour != null) ctrl.setNumber('timeHour', w.timeHour!);
    if (w.timeHourDIG != null) ctrl.setNumber('timeHourDIG', w.timeHourDIG!);
    if (w.timeDate != null) ctrl.setNumber('timeDate', w.timeDate!);
    if (w.timeDay != null) ctrl.setString('timeDay', w.timeDay!);
    if (w.watchStyle != null) ctrl.setString('watchStyle', w.watchStyle!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: WristCheckConfig.getWCColour(),
      child: RiveWidgetBuilder(
        fileLoader: _fileLoader,
        artboardSelector: ArtboardNamed(widget.artboardName),
        onLoaded: (state) {
          _animController?.dispose();
          final animCtrl = WTAnnualRecapAnimationController(state.controller);
          _animController = animCtrl;
          _applyInputs(widget, animCtrl);
          animCtrl.addTriggerListener('screenShotTrigger', _onScreenshotTrigger);
          animCtrl.addBooleanListener('isFinalSlide', _onFinalSlideChanged);
          widget.onControllerReady?.call(animCtrl);
        },
        onFailed: (error, stackTrace) {
          debugPrint("WTAnnualRecapAnimation onFailed (${widget.artboardName}): $error\n$stackTrace");
        },
        builder: (context, state) {
          return switch (state) {
            RiveLoading() => const Center(child: CircularProgressIndicator(color: Colors.white)),
            RiveFailed(:final error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WtStaticIcon(dimensions: widget.fallbackIconDimensions),
                    const SizedBox(height: 12),
                    Text(
                      "Animation failed to load: $error",
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            RiveLoaded(:final controller) => RiveWidget(
              controller: controller,
              fit: widget.fit,
              //Fit.layout,
              layoutScaleFactor: 2.0,
              hitTestBehavior: RiveHitTestBehavior.opaque,
            ),
          };
        },
      ),
    );
  }
}

