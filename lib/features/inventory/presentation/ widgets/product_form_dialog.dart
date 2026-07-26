import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

class ProductFormDialog extends StatefulWidget {
  final ProductEntity? product;
  final List<CategoryEntity> categories;
  final Function(ProductEntity product, int initialQty) onSave;

  const ProductFormDialog({
    super.key,
    this.product,
    required this.categories,
    required this.onSave,
  });

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController purchasePriceCtrl;
  late TextEditingController salePriceCtrl;
  late TextEditingController surveyPriceCtrl;
  late TextEditingController minQtyCtrl;
  late TextEditingController initialQtyCtrl;

  String? selectedCategoryId;
  bool showToSurvey = false;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    isEditMode = widget.product != null;
    nameCtrl = TextEditingController(text: widget.product?.name ?? '');
    purchasePriceCtrl = TextEditingController(
        text: widget.product?.purchasePrice.toString() ?? '');
    salePriceCtrl =
        TextEditingController(text: widget.product?.salePrice.toString() ?? '');
    surveyPriceCtrl = TextEditingController(
        text: widget.product?.surveyPrice.toString() ?? '');
    minQtyCtrl =
        TextEditingController(text: widget.product?.minQty.toString() ?? '5');
    initialQtyCtrl = TextEditingController(text: '0');
    showToSurvey = widget.product?.showToSurvey ?? false;

    if (widget.categories.isNotEmpty) {
      selectedCategoryId =
          isEditMode ? widget.product!.categoryId : widget.categories.first.id;
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    purchasePriceCtrl.dispose();
    salePriceCtrl.dispose();
    surveyPriceCtrl.dispose();
    minQtyCtrl.dispose();
    initialQtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditMode ? 'تعديل بيانات الصنف' : 'إضافة صنف جديد'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'اسم الصنف'),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategoryId,
                decoration: const InputDecoration(labelText: 'التصنيف'),
                items: widget.categories.map((cat) {
                  return DropdownMenuItem(value: cat.id, child: Text(cat.name));
                }).toList(),
                onChanged: (val) => setState(() => selectedCategoryId = val),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: minQtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'حد الأمان (النواقص)'),
                    ),
                  ),
                  if (!isEditMode) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: initialQtyCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'الكمية الابتدائية'),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: purchasePriceCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'سعر الشراء'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: salePriceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'سعر البيع'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: surveyPriceCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'سعر المعاينة'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('عرض هذا الصنف في معاينات المندوب'),
                value: showToSurvey,
                onChanged: (val) => setState(() => showToSurvey = val ?? false),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final prod = ProductEntity(
                id: widget.product?.id ?? const Uuid().v4(),
                categoryId: selectedCategoryId!,
                name: nameCtrl.text.trim(),
                purchasePrice: double.tryParse(purchasePriceCtrl.text) ?? 0.0,
                salePrice: double.tryParse(salePriceCtrl.text) ?? 0.0,
                surveyPrice: double.tryParse(surveyPriceCtrl.text) ?? 0.0,
                minQty: int.tryParse(minQtyCtrl.text) ?? 5,
                showToSurvey: showToSurvey,
              );
              widget.onSave(prod, int.tryParse(initialQtyCtrl.text) ?? 0);
              Navigator.pop(context);
            }
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}
