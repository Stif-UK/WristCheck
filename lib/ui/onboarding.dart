import 'package:flutter/material.dart';

class WristCheckOnboarding extends StatefulWidget {
  const WristCheckOnboarding({Key? key}) : super(key: key);

  @override
  State<WristCheckOnboarding> createState() => _WristCheckOnboardingState();
}

class _WristCheckOnboardingState extends State<WristCheckOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          Container(
            color: Colors.red,
            child: const Center(child: Text("Page 1")),
          ),
          Container(
            color: Colors.blue,
            child: const Center(child: Text("Page 2")),
          ),
          Container(
            color: Colors.green,
            child: const Center(child: Text("Page 3")),
          ),
        ],
      ),
    );
  }
}
