import 'package:flutter/material.dart';

class DataCellWidget extends StatelessWidget {
  final String text;
  final AlignmentDirectional align;
  final Color? color;
  final bool isBold;

  const DataCellWidget(
      {super.key,
      required this.text,
      required this.align,
      this.color,
      this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: Text(
        text,
        style: TextStyle(
            color: color ?? const Color(0xFF1E293B),
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
