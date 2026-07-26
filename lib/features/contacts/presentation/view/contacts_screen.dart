// lib/features/contacts/presentation/pages/contacts_screen.dart

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
        return Scaffold(
          appBar: AppBar(
            title: const Text('إدارة الموردين، التجار، والموظفين'),
          ),
          body: BlocListener<ContactsBloc, ContactsState>(
            listener: (context, state) {
              if (state is ContactsActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message,
                        style: const TextStyle(color: Colors.white)),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is ContactsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage,
                        style: const TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // نموذج إضافة جهة اتصال جديدة (مكون منفصل)
                  const AddContactForm(),
                  const SizedBox(height: 24),

                  // حقل البحث السريع المربوط بـ Event الـ BLoC مباشرة
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'بحث بالاسم، رقم الهاتف، أو المنطقة...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        context
                            .read<ContactsBloc>()
                            .add(SearchContactsEvent(value));
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // جدول عرض جهات الاتصال المفلترة (مكون منفصل)
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
}
