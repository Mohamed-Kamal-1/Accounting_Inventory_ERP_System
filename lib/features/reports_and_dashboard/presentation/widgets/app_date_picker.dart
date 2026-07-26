import 'package:flutter/material.dart';

class AppDatePicker extends StatelessWidget {
  final String label;
  const AppDatePicker({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true, // يمنع الكتابة اليدوية ويجبر المستخدم على اختيار التاريخ
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calendar_today),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000), // بداية التاريخ المسموح به
          lastDate: DateTime(2100), // نهاية التاريخ المسموح به
          // locale: const Locale('ar', 'EG'), // لدعم الواجهة العربية
        );

        if (pickedDate != null) {
          // هنا يتم تخزين التاريخ المختار لاحقاً في الـ Controller
          print("التاريخ المختار: ${pickedDate.year}-${pickedDate.month}-${pickedDate.day}");
        }
      },
    );
  }
}