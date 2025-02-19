//extension on the string class to track validation against individual form fields
extension ExtString on String{
  bool get isAlphaNumericAndNotEmpty{
    final titleRegExp = RegExp(r"^[a-zA-Z0-9!£$&+()-.\s]+$");
    return titleRegExp.hasMatch(this);
  }

  bool get isAlphaNumericIncAccentsAndSymbolsAndNotEmpty{
    final titleRegExp = RegExp(r'^[a-zA-Záéíñóöúñü0-9-,.?!& ;:/\[\]]+$');
    return titleRegExp.hasMatch(this);
  }

  bool get isServiceNumber{
    //in range 0-99 or blank
    final titleRegExp = RegExp(r"^([0-9]{1,2}|)$");
    return titleRegExp.hasMatch(this);
  }

  bool get isDouble{
    //in range 0-99 with a single digit past decimal or blank
    final titleRegExp = RegExp(r'^(?:[0-9]|[1-9][0-9])(?:\.\d)?$');
    return titleRegExp.hasMatch(this);
  }

  bool get isAlphaNumericWithSymbolsOrEmpty{
    final titleRegExp = RegExp(r'|^([a-zA-Z0-9-_.?!;:/& ]+)$');
    return titleRegExp.hasMatch(this);
  }

  bool get isWcCurrency{
    //valid int or blank
    final titleRegExp = RegExp(r"^(\d+|\s*)$");
    return titleRegExp.hasMatch(this);
  }

  bool get containsSale{
    final titleRegExp = RegExp(r'sale', caseSensitive: false);
    return titleRegExp.hasMatch(this);
  }

  /*
  Validate if a filename meets the criteria of being an image saved by the app
   */
  bool get isWCJpg{
    final isFront = RegExp(r'_front.jpg', caseSensitive: false);
    final isBack = RegExp(r'_back.jpg', caseSensitive: false);
    return isBack.hasMatch(this) || isFront.hasMatch(this);

  }

}