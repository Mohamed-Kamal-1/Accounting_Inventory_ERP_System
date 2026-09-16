import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/contact_entity.dart';
import '../bloc/contacts_bloc.dart';
import 'contact_type_badge.dart';
import 'contacts_table.dart';
import 'edit_contact_dialog.dart';

class MobileContactCard extends StatelessWidget {
  final ContactEntity contact;

  const MobileContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(contact.name,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B)))),
              ContactTypeBadge(type: contact.type),
            ],
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Color(0xFFF1F5F9))),
          Row(
            children: [
              Icon(Icons.phone_iphone_rounded,
                  size: 16, color: Colors.grey.shade500),
              const SizedBox(width: 8),
              Text(contact.phone,
                  style: TextStyle(color: Colors.grey.shade700)),
              const Spacer(),
              Icon(Icons.location_on_rounded,
                  size: 16, color: Colors.grey.shade500),
              const SizedBox(width: 8),
              Text(contact.area.isNotEmpty ? contact.area : '-',
                  style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                    'الرصيد: ${contact.openingBalance.toStringAsFixed(2)} ج.م',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontSize: 13)),
              ),
              Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.edit_note_rounded,
                          color: Colors.blueAccent),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        final bloc = context.read<ContactsBloc>();
                        showDialog(
                            context: context,
                            builder: (_) => BlocProvider.value(
                                  value: bloc,
                                  child: EditContactDialog(contact: contact),
                                ));
                      }),
                  IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: Colors.redAccent),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        final bloc = context.read<ContactsBloc>();
                        showDialog(
                            context: context,
                            builder: (_) => BlocProvider.value(
                                  value: bloc,
                                  child: DeleteContactDialog(
                                      contactId: contact.id),
                                ));
                      }),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
