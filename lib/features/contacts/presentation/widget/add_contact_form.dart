import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/contact_entity.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';

class AddContactForm extends StatefulWidget {
  const AddContactForm({super.key});

  @override
  State<AddContactForm> createState() => _AddContactFormState();
}

class _AddContactFormState extends State<AddContactForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController openingBalanceController =
      TextEditingController();

  String selectedType = 'merchant';
  bool showAuthFields = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    areaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    openingBalanceController.dispose();
    super.dispose();
  }

  void _onTypeChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedType = newValue;
        showAuthFields = (newValue == 'sales' ||
            newValue == 'preview' ||
            newValue == 'technician');
      });
    }
  }

  void _submitForm() {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الاسم ورقم الهاتف مطلوبان')),
      );
      return;
    }

    if (showAuthFields &&
        (emailController.text.trim().isEmpty ||
            passwordController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يرجى إدخال البريد الإلكتروني وكلمة المرور للموظف')),
      );
      return;
    }

    final newContact = ContactEntity(
      id: const Uuid().v4(),
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      area: areaController.text.trim(),
      type: selectedType,
      openingBalance: double.tryParse(openingBalanceController.text) ?? 0.0,
      createdAt: DateTime.now(),
    );

    context.read<ContactsBloc>().add(
          AddContactEvent(
            contact: newContact,
            email: showAuthFields ? emailController.text.trim() : null,
            password: showAuthFields ? passwordController.text : null,
          ),
        );

    // تفريغ الحقول بعد الإرسال
    nameController.clear();
    phoneController.clear();
    areaController.clear();
    emailController.clear();
    passwordController.clear();
    openingBalanceController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'الاسم الكامل')),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration:
                          const InputDecoration(labelText: 'رقم الهاتف')),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                      controller: areaController,
                      decoration: const InputDecoration(labelText: 'المنطقة')),
                ),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: const InputDecoration(labelText: 'النوع'),
                    items: const [
                      DropdownMenuItem(
                          value: 'merchant', child: Text('تاجر (عميل)')),
                      DropdownMenuItem(
                          value: 'supplier', child: Text('مورد (مصنع)')),
                      DropdownMenuItem(
                          value: 'sales', child: Text('مندوب مبيعات')),
                      DropdownMenuItem(
                          value: 'preview', child: Text('مندوب معاينة')),
                      DropdownMenuItem(
                          value: 'technician', child: Text('فني / سباك')),
                    ],
                    onChanged: _onTypeChanged,
                  ),
                ),
                if (!showAuthFields)
                  SizedBox(
                    width: 200,
                    child: TextField(
                        controller: openingBalanceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'الرصيد الافتتاحي')),
                  ),
              ],
            ),
            if (showAuthFields) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8)),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                        width: 200,
                        child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                labelText: 'الإيميل للدخول'))),
                    SizedBox(
                        width: 200,
                        child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: 'كلمة المرور'))),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text('إضافة جديد'),
            ),
          ],
        ),
      ),
    );
  }
}
