import 'package:flutter/material.dart';

class ModernStatCard extends StatelessWidget {
  final String title;
  final String val;
  final Color color;
  final IconData icon;
  final double screenWidth;

  const ModernStatCard({
    super.key,
    required this.title,
    required this.val,
    required this.color,
    required this.icon,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    double cardWidth = screenWidth > 1200
        ? (screenWidth - 240 - 110) / 4
        : screenWidth > 800
            ? (screenWidth - 240 - 70) / 2
            : screenWidth - 48;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border(right: BorderSide(color: color, width: 6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(val,
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ],
      ),
    );
  }
}
