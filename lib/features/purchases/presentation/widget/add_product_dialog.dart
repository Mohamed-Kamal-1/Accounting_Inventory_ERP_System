import 'package:flutter/material.dart';

import '../cubit/purchases_cubit.dart';

class AddProductDialog extends StatefulWidget {
  final PurchasesCubit cubit;
  const AddProductDialog({super.key, required this.cubit});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  String? selectedProductId;
  String selectedProductName = "";
  final TextEditingController qtyCtrl = TextEditingController(text: '1');
  final TextEditingController priceCtrl = TextEditingController();

  @override
  void dispose() {
    qtyCtrl.dispose();
    priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text('إضافة منتج للفاتورة',
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
                labelText: 'اختر الصنف', border: OutlineInputBorder()),
            items: widget.cubit.allProducts
                .map((p) => DropdownMenuItem<String>(
                    value: p['id'], child: Text(p['name'])))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedProductId = val;
                final prod =
                    widget.cubit.allProducts.firstWhere((p) => p['id'] == val);
                selectedProductName = prod['name'];
                priceCtrl.text = prod['purchase_price'].toString();
              });
            },
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                  child: TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'السعر', border: OutlineInputBorder()))),
              const SizedBox(width: 15),
              Expanded(
                  child: TextField(
                      controller: qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'الكمية', border: OutlineInputBorder()))),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء')),
        ElevatedButton(
          onPressed: () {
            if (selectedProductId != null &&
                priceCtrl.text.isNotEmpty &&
                qtyCtrl.text.isNotEmpty) {
              widget.cubit.addProductToInvoice(
                selectedProductId!,
                selectedProductName,
                double.parse(priceCtrl.text),
                int.parse(qtyCtrl.text),
              );
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white),
          child: const Text('إضافة'),
        ),
      ],
    );
  }
}
