import 'package:flutter/material.dart';

class ImageOverlay extends StatelessWidget {
  const ImageOverlay({
    super.key,
    required this.title,
    required this.subtitle
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.black.withAlpha(50),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 18.0,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                color: Colors.white,
                tooltip: 'Close',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          Container(
          color: Colors.black.withAlpha(50),
      padding: const EdgeInsets.all(8.0),
      child: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.white,
          decoration: TextDecoration.none,
          fontSize: 18.0,
        ),
      ),
    ),
]
          )
        ],
      ),
    );
  }
}