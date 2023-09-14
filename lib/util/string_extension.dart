//extension on the string class to track validation against individual form fields
extension ExtString on String{
  bool get isAlphaNumericAndNotEmpty{
    final titleRegExp = RegExp(r"^[a-zA-Z0-9!£$&+()-.\s]+$");
    return titleRegExp.hasMatch(this);
  }

  bool get isServiceNumber{
    //in range 0-99 or blank
    final titleRegExp = RegExp(r"^([0-9]{1,2}|)$");
    return titleRegExp.hasMatch(this);
  }

}