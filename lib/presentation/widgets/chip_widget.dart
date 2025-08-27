import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  final String label;

  const ChipWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
