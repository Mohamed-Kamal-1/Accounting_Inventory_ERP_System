import 'package:flutter/material.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

class ProductFormDialog extends StatefulWidget {
  final List<CategoryEntity> categories;
  final Function(ProductEntity prod, int initialQty) onSave;

  const ProductFormDialog(
      {super.key, required this.categories, required this.onSave});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final nameController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final salePriceController = TextEditingController();
  final qtyController = TextEditingController(text: '1');
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    if (widget.categories.isNotEmpty) {
      selectedCategoryId = widget.categories.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('➕ إضافة صنف جديد للمخزن'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم الصنف')),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCategoryId,
              items: widget.categories
                  .map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                  .toList(),
              onChanged: (val) => setState(() => selectedCategoryId = val),
              decoration: const InputDecoration(labelText: 'القسم'),
            ),
            const SizedBox(height: 10),
            TextField(
                controller: purchasePriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'سعر الشراء')),
            const SizedBox(height: 10),
            TextField(
                controller: salePriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'سعر البيع')),
            const SizedBox(height: 10),
            TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'الرصيد الافتتاحي')),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء')),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.isEmpty || selectedCategoryId == null)
              return;

            final prod = ProductEntity(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              categoryId: selectedCategoryId!,
              name: nameController.text,
              purchasePrice:
                  double.tryParse(purchasePriceController.text) ?? 0.0,
              salePrice: double.tryParse(salePriceController.text) ?? 0.0,
              surveyPrice: 0.0,
              minQty: 1,
              showToSurvey: true,
            );

            widget.onSave(prod, int.tryParse(qtyController.text) ?? 1);
            Navigator.pop(context);
          },
          child: const Text('حفظ الصنف'),
        ),
      ],
    );
  }
}
