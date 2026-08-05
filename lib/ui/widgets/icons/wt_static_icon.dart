import 'package:flutter/material.dart';

class WtStaticIcon extends StatelessWidget {
  const WtStaticIcon({super.key, required this.dimensions});
  final double dimensions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimensions,
      height: dimensions,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: AssetImage('assets/icon/drawerheader.png'),
            fit: BoxFit.contain
        ),
      ),
    );
  }
}
