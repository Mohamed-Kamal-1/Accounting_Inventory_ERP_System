import 'package:flutter/material.dart';

import 'header_cell_widget.dart';

class ContactHeaderTable extends StatelessWidget {
  const ContactHeaderTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: const Row(
        children: [
          Expanded(
              flex: 3,
              child: HeaderCellWidget(
                  title: 'الاسم', align: AlignmentDirectional.centerStart)),
          Expanded(
              flex: 2,
              child: HeaderCellWidget(
                  title: 'النوع', align: AlignmentDirectional.centerStart)),
          Expanded(
              flex: 2,
              child: HeaderCellWidget(
                  title: 'الهاتف', align: AlignmentDirectional.centerStart)),
          Expanded(
              flex: 2,
              child: HeaderCellWidget(
                  title: 'المنطقة', align: AlignmentDirectional.centerStart)),
          Expanded(
              flex: 2,
              child: HeaderCellWidget(
                  title: 'الرصيد الافتتاحي',
                  align: AlignmentDirectional.centerStart)),
          Expanded(
              flex: 2,
              child: HeaderCellWidget(
                  title: 'إجراءات', align: AlignmentDirectional.centerEnd)),
        ],
      ),
    );
  }
}
