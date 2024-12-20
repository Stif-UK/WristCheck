import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PeriodReviewLoading extends StatelessWidget {
  const PeriodReviewLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Hang tight while we crunch some numbers..."),
          const SizedBox(height: 40,),
          LoadingAnimationWidget.staggeredDotsWave(color: Theme.of(context).focusColor, size: 50)
        ],
      ),
    );
  }
}
