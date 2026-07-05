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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium,),
          Text(value, style: Theme.of(context).textTheme.headlineSmall,),
          subtitle != null ? Text(subtitle!, style: Theme.of(context).textTheme.bodySmall,)
              : const SizedBox(height: 0,)
        ],
      ),
    );
  }
}
