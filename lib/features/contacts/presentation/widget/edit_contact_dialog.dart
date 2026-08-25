import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/contact_entity.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';

class EditContactDialog extends StatefulWidget {
  final ContactEntity contact;
  const EditContactDialog({super.key, required this.contact});

  @override
  State<EditContactDialog> createState() => _EditContactDialogState();
}

class _EditContactDialogState extends State<EditContactDialog> {
  late final TextEditingController nameCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController areaCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.contact.name);
    phoneCtrl = TextEditingController(text: widget.contact.phone);
    areaCtrl = TextEditingController(text: widget.contact.area);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    areaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('تعديل بيانات الجهة',
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameCtrl,
            decoration: InputDecoration(
                labelText: 'الاسم',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phoneCtrl,
            decoration: InputDecoration(
                labelText: 'الهاتف',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: areaCtrl,
            decoration: InputDecoration(
                labelText: 'المنطقة',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          onPressed: () {
            if (nameCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty)
              return;
            final updatedContact = ContactEntity(
              id: widget.contact.id,
              userId: widget.contact.userId,
              name: nameCtrl.text.trim(),
              phone: phoneCtrl.text.trim(),
              area: areaCtrl.text.trim(),
              type: widget.contact.type,
              openingBalance: widget.contact.openingBalance,
              createdAt: widget.contact.createdAt,
            );
            context
                .read<ContactsBloc>()
                .add(UpdateContactEvent(updatedContact));
            Navigator.pop(context);
          },
          child: const Text('حفظ التعديلات'),
        ),
      ],
    );
  }
}
