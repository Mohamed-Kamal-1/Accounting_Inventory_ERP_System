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
  // ... (نفس المتغيرات والدوال _onTypeChanged و _submitForm من الكود السابق تماماً، لا تغيير فيها)
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
        phoneController.text.trim().isEmpty) return;
    final newContact = ContactEntity(
      id: const Uuid().v4(),
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      area: areaController.text.trim(),
      type: selectedType,
      openingBalance: double.tryParse(openingBalanceController.text) ?? 0.0,
      createdAt: DateTime.now(),
    );
    context.read<ContactsBloc>().add(AddContactEvent(
          contact: newContact,
          email: showAuthFields ? emailController.text.trim() : null,
          password: showAuthFields ? passwordController.text : null,
        ));
    nameController.clear();
    phoneController.clear();
    areaController.clear();
    emailController.clear();
    passwordController.clear();
    openingBalanceController.clear();
    FocusScope.of(context).unfocus();
  }

  InputDecoration _modernInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.blueAccent.shade100, size: 20),
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 💡 تحديد عرض الحقول بناءً على حجم الشاشة
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final double inputWidth = isMobile ? double.infinity : 220;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                  width: inputWidth,
                  child: TextField(
                      controller: nameController,
                      decoration: _modernInputDecoration(
                          'الاسم الكامل', Icons.person_rounded))),
              SizedBox(
                  width: inputWidth,
                  child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _modernInputDecoration(
                          'رقم الهاتف', Icons.phone_rounded))),
              SizedBox(
                  width: inputWidth,
                  child: TextField(
                      controller: areaController,
                      decoration: _modernInputDecoration(
                          'المنطقة', Icons.location_on_rounded))),
              SizedBox(
                width: inputWidth,
                child: DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: _modernInputDecoration(
                      'نوع الجهة', Icons.category_rounded),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
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
                    width: inputWidth,
                    child: TextField(
                        controller: openingBalanceController,
                        keyboardType: TextInputType.number,
                        decoration: _modernInputDecoration('الرصيد الافتتاحي',
                            Icons.account_balance_wallet_rounded))),
            ],
          ),
          if (showAuthFields) ...[
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(color: Color(0xFFE2E8F0))),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                    width: inputWidth,
                    child: TextField(
                        controller: emailController,
                        decoration: _modernInputDecoration(
                            'الإيميل للدخول', Icons.email_rounded))),
                SizedBox(
                    width: inputWidth,
                    child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: _modernInputDecoration(
                            'كلمة المرور', Icons.lock_rounded))),
              ],
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width:
                isMobile ? double.infinity : null, // زر بعرض الشاشة في الموبايل
            child: ElevatedButton.icon(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: const Text('حفظ وإضافة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
