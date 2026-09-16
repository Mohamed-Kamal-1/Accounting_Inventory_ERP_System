import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/contacts_bloc.dart';
import 'contact_type_badge.dart';
import 'contacts_table.dart';
import 'data_cell_widget.dart';
import 'edit_contact_dialog.dart';

class ContactInfo extends StatelessWidget {
  final contact;

  const ContactInfo({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: DataCellWidget(
                  text: contact.name,
                  align: AlignmentDirectional.centerStart,
                  isBold: true)),
          Expanded(
              flex: 2,
              child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ContactTypeBadge(type: contact.type))),
          Expanded(
              flex: 2,
              child: DataCellWidget(
                  text: contact.phone,
                  align: AlignmentDirectional.centerStart)),
          Expanded(
              flex: 2,
              child: DataCellWidget(
                  text: contact.area.isNotEmpty ? contact.area : '-',
                  align: AlignmentDirectional.centerStart)),
          Expanded(
              flex: 2,
              child: DataCellWidget(
                  text: '${contact.openingBalance.toStringAsFixed(2)} ج.م',
                  align: AlignmentDirectional.centerStart,
                  color: Colors.teal,
                  isBold: true)),
          Expanded(
            flex: 2,
            child: Builder(
              builder: (context) {
                final bloc = context.read<ContactsBloc>();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.edit_note_rounded,
                            color: Colors.blueAccent),
                        splashRadius: 20,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => BlocProvider.value(
                                  value: bloc,
                                  child: EditContactDialog(contact: contact)));
                        }),
                    IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: Colors.redAccent),
                        splashRadius: 20,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => BlocProvider.value(
                                  value: bloc,
                                  child: DeleteContactDialog(
                                      contactId: contact.id)));
                        }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
