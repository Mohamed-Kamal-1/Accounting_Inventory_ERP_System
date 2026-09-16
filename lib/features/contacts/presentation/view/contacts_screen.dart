import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';
import '../widget/add_contact_form.dart';
import '../widget/contacts_table.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<ContactsBloc>()..add(LoadContactsEvent()),
      child: Builder(builder: (context) {
        final isMobile = MediaQuery.sizeOf(context).width < 600;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: BlocListener<ContactsBloc, ContactsState>(
            listener: (context, state) {
              if (state is ContactsActionSuccess) {
                _showModernSnackBar(context, state.message, Colors.teal);
              } else if (state is ContactsError) {
                _showModernSnackBar(
                    context, state.errorMessage, Colors.redAccent);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.people_alt_rounded,
                          color: Colors.blueAccent, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'إدارة جهات الاتصال',
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 16 : 24),
                  const AddContactForm(),
                  SizedBox(height: isMobile ? 16 : 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'ابحث بالاسم، رقم الهاتف، أو المنطقة...',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: Colors.blueAccent),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      onChanged: (value) {
                        context
                            .read<ContactsBloc>()
                            .add(SearchContactsEvent(value));
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Expanded(
                    child: ContactsTable(),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showModernSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
                child: Text(message,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
