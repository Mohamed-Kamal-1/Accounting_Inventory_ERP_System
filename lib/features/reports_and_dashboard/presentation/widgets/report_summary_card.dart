import 'package:flutter/material.dart';

class ReportSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const ReportSummaryCard(
      {super.key,
      required this.title,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.sizeOf(context).width / 2 - 24;
    return Card(
      color: color.withValues(alpha: 0.1),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: cardWidth,
        child: Column(
          children: [
            Text(title,
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
