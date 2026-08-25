import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';
import 'contact_type_badge.dart';
import 'data_cell_widget.dart';
import 'edit_contact_dialog.dart';
import 'header_cell_widget.dart';
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
                // عرض الموبايل (كروت)
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
                // عرض الشاشات الكبيرة (جدول منظم بدون مسافات فارغة)
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      // 💡 الترويسة (Headers)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8FAFC),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                          border: Border(
                              bottom: BorderSide(color: Color(0xFFE2E8F0))),
                        ),
                        child: const Row(
                          children: [
                            // AlignmentDirectional.centerStart تعني أقصى اليمين في العربي
                            Expanded(
                                flex: 3,
                                child: HeaderCellWidget(
                                    title: 'الاسم',
                                    align: AlignmentDirectional.centerStart)),
                            Expanded(
                                flex: 2,
                                child: HeaderCellWidget(
                                    title: 'النوع',
                                    align: AlignmentDirectional.centerStart)),
                            Expanded(
                                flex: 2,
                                child: HeaderCellWidget(
                                    title: 'الهاتف',
                                    align: AlignmentDirectional.centerStart)),
                            Expanded(
                                flex: 2,
                                child: HeaderCellWidget(
                                    title: 'المنطقة',
                                    align: AlignmentDirectional.centerStart)),
                            Expanded(
                                flex: 2,
                                child: HeaderCellWidget(
                                    title: 'الرصيد الافتتاحي',
                                    align: AlignmentDirectional.centerStart)),
                            Expanded(
                                flex: 2,
                                child: HeaderCellWidget(
                                    title: 'إجراءات',
                                    align: AlignmentDirectional.centerEnd)),
                          ],
                        ),
                      ),

                      // 💡 البيانات (Data Rows)
                      Expanded(
                        child: ListView.separated(
                          itemCount: state.filteredContacts.length,
                          separatorBuilder: (context, index) => const Divider(
                              height: 1, color: Color(0xFFF1F5F9)),
                          itemBuilder: (context, index) {
                            final contact = state.filteredContacts[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: DataCellWidget(
                                          text: contact.name,
                                          align:
                                              AlignmentDirectional.centerStart,
                                          isBold: true)),
                                  Expanded(
                                      flex: 2,
                                      child: Align(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: ContactTypeBadge(
                                              type: contact.type))),
                                  Expanded(
                                      flex: 2,
                                      child: DataCellWidget(
                                          text: contact.phone,
                                          align: AlignmentDirectional
                                              .centerStart)),
                                  Expanded(
                                      flex: 2,
                                      child: DataCellWidget(
                                          text: contact.area.isNotEmpty
                                              ? contact.area
                                              : '-',
                                          align: AlignmentDirectional
                                              .centerStart)),
                                  Expanded(
                                      flex: 2,
                                      child: DataCellWidget(
                                          text:
                                              '${contact.openingBalance.toStringAsFixed(2)} ج.م',
                                          align:
                                              AlignmentDirectional.centerStart,
                                          color: Colors.teal,
                                          isBold: true)),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            icon: const Icon(
                                                Icons.edit_note_rounded,
                                                color: Colors.blueAccent),
                                            splashRadius: 20,
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      EditContactDialog(
                                                          contact: contact));
                                            }),
                                        IconButton(
                                            icon: const Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.redAccent),
                                            splashRadius: 20,
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      DeleteContactDialog(
                                                          contactId:
                                                              contact.id));
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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

// 3. نافذة تعديل البيانات (Class منفصل بالكامل)

// 4. نافذة الحذف (Class منفصل)
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
