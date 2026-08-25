import 'package:flutter/material.dart';

class HeaderCellWidget extends StatelessWidget {
  final String title;
  final AlignmentDirectional align;

  const HeaderCellWidget({super.key, required this.title, required this.align});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              fontSize: 13)),
    );
  }
}
