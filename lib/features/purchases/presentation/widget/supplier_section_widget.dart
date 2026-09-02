import 'package:flutter/material.dart';

import '../cubit/purchases_cubit.dart';

class SupplierSectionWidget extends StatelessWidget {
  final PurchasesCubit cubit;
  const SupplierSectionWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('تصنيف جهة الاتصال',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: cubit.selectedContactType,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 15)),
            items: const [
              DropdownMenuItem(value: 'supplier', child: Text('مورد')),
              DropdownMenuItem(value: 'merchant', child: Text('تاجر')),
              DropdownMenuItem(value: 'customer', child: Text('عميل')),
            ],
            onChanged: (val) => cubit.filterContactsByType(val!),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الاسم',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              InkWell(
                onTap: () {
                  cubit.loadInitialData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('تم تحديث قائمة الأسماء والمنتجات'),
                        duration: Duration(seconds: 1)),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.sync, size: 16, color: Color(0xFF3B82F6)),
                    SizedBox(width: 4),
                    Text('تحديث',
                        style:
                            TextStyle(color: Color(0xFF3B82F6), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: cubit.selectedSupplierId,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 15)),
            hint: const Text('اختر الاسم...'),
            items: cubit.filteredContacts
                .map((c) => DropdownMenuItem<String>(
                    value: c['id'], child: Text(c['name'])))
                .toList(),
            onChanged: (val) => cubit.selectSupplier(val!),
          ),
        ],
      ),
    );
  }
}
