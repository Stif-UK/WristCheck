///A screen which will display to contain the GDPR consent form

import 'package:flutter/material.dart';
import 'package:wristcheck/privacy/initialisation_helper.dart';

class InitialiseScreen extends StatefulWidget {
  const InitialiseScreen({required this.targetWidget});

  final Widget targetWidget;

  @override
  State<InitialiseScreen> createState() => _InitialiseScreenState();
}

class _InitialiseScreenState extends State<InitialiseScreen> {
  final _initialisationHelper = InitialisationHelper();

  @override
  void initState() {
    super.initState();
    _initialise();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    )
  );

  Future<void> _initialise() async{
    final navigator = Navigator.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initialisationHelper.initialise();
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => widget.targetWidget)
      );
    });
  }

}
