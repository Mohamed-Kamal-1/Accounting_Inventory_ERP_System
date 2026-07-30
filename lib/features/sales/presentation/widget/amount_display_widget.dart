import 'package:flutter/cupertino.dart';

class AmountDisplayWidget extends StatelessWidget {
  final String label;
  final double amount;
  final Color? color;
  final double fontSize;

  const AmountDisplayWidget({
    super.key,
    required this.label,
    required this.amount,
    this.color,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label: $amount ج.م',
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
