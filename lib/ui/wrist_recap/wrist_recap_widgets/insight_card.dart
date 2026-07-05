import 'package:flutter/material.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({super.key, required this.title, required this.value, this.subtitle});

  final String title;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(title, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(value, style: Theme.of(context).textTheme.headlineSmall,),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(subtitle!, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center,),
            ),
        ],
      ),
    );
  }
}
