import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/contact_entity.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';
import 'contact_type_badge.dart';

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
            return const Center(child: Text('لا توجد جهات مطابقة للبحث.'));
          }
          return Card(
            elevation: 2,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(
                      label: Text('الاسم',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('النوع',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('الهاتف',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('المنطقة',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('الرصيد الافتتاحي',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('إجراءات',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: state.filteredContacts.map((contact) {
                  return DataRow(cells: [
                    DataCell(Text(contact.name)),
                    DataCell(ContactTypeBadge(type: contact.type)),
                    DataCell(Text(contact.phone)),
                    DataCell(
                        Text(contact.area.isNotEmpty ? contact.area : '-')),
                    DataCell(Text(contact.openingBalance.toStringAsFixed(2))),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditDialog(context, contact),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _showDeleteDialog(context, contact.id),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showEditDialog(BuildContext context, ContactEntity contact) {
    final nameCtrl = TextEditingController(text: contact.name);
    final phoneCtrl = TextEditingController(text: contact.phone);
    final areaCtrl = TextEditingController(text: contact.area);
    final bloc =
        context.read<ContactsBloc>(); // حفظ الـ Bloc قبل فتح الـ Dialog

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تعديل بيانات الجهة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'الاسم')),
            const SizedBox(height: 8),
            TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'الهاتف')),
            const SizedBox(height: 8),
            TextField(
                controller: areaCtrl,
                decoration: const InputDecoration(labelText: 'المنطقة')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, foregroundColor: Colors.white),
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty)
                return;

              final updatedContact = ContactEntity(
                id: contact.id,
                userId: contact.userId,
                name: nameCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                area: areaCtrl.text.trim(),
                type: contact.type, // لا نسمح بتعديل النوع
                openingBalance:
                    contact.openingBalance, // لا نسمح بتعديل الرصيد الافتتاحي
                createdAt: contact.createdAt,
              );

              bloc.add(UpdateContactEvent(updatedContact));
              Navigator.pop(ctx);
            },
            child: const Text('حفظ التعديلات'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String contactId) {
    // ... (نفس كود الحذف السابق بدون تغيير)
    final bloc = context.read<ContactsBloc>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذه الجهة؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              bloc.add(DeleteContactEvent(contactId));
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
