import 'package:flutter/material.dart';

class DecorationHelper{

  /**
   * lightenColour takes a Material Color as input and returns a colour lightened by the given multiplier
   */
  static Color lightenColour(Color givenColour, double amount){

    assert(amount >= 0 && amount <= 1);
    final hslColor = HSLColor.fromColor(givenColour);
    final lightenedHslColor = hslColor.withLightness((hslColor.lightness + amount).clamp(0.0, 1.0));
    return lightenedHslColor.toColor();
  }
}