import 'package:flutter/material.dart';

class ContactTypeBadge extends StatelessWidget {
  final String type;

  const ContactTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    String label;

    switch (type) {
      case 'merchant':
        bgColor = Colors.purple;
        label = 'تاجر';
        break;
      case 'supplier':
        bgColor = Colors.orange;
        label = 'مورد';
        break;
      case 'sales':
        bgColor = Colors.blue;
        label = 'مندوب بيع';
        break;
      case 'preview':
        bgColor = Colors.teal;
        label = 'مندوب معاينة';
        break;
      case 'technician':
        bgColor = Colors.deepOrange;
        label = 'فني';
        break;
      default:
        bgColor = Colors.grey;
        label = 'مجهول';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
