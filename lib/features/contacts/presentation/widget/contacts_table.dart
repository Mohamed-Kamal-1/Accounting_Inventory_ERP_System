import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';
import 'contact_header_table.dart';
import 'contact_info.dart';
import 'mobile_contact_card.dart';

class ContactsTable extends StatelessWidget {
  const ContactsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state) {
        if (state is ContactsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ContactsLoaded) {
          if (state.filteredContacts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded,
                      size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('لا توجد جهات مطابقة للبحث.',
                      style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 800;

              if (isMobile) {
                return ListView.separated(
                  itemCount: state.filteredContacts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final contact = state.filteredContacts[index];
                    return MobileContactCard(contact: contact);
                  },
                );
              } else {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      ContactHeaderTable(),
                      Expanded(
                        child: ListView.separated(
                          itemCount: state.filteredContacts.length,
                          separatorBuilder: (context, index) => const Divider(
                              height: 1, color: Color(0xFFF1F5F9)),
                          itemBuilder: (context, index) {
                            final contact = state.filteredContacts[index];
                            return ContactInfo(
                              contact: contact,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class DeleteContactDialog extends StatelessWidget {
  final String contactId;

  const DeleteContactDialog({super.key, required this.contactId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
          SizedBox(width: 8),
          Text('تأكيد الحذف', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: const Text('هل أنت متأكد من حذف هذه الجهة نهائياً؟'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0),
          onPressed: () {
            context.read<ContactsBloc>().add(DeleteContactEvent(contactId));
            Navigator.pop(context);
          },
          child: const Text('نعم، حذف'),
        ),
      ],
    );
  }
}
