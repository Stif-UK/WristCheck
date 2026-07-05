import 'package:flutter/material.dart';

class RecapEmptyIcon extends StatelessWidget {
  const RecapEmptyIcon({super.key, required this.dimension});
  final double dimension;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.watch, size: 50, color: Theme.of(context).disabledColor),
    );
  }
}
