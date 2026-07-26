import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../inventory/domain/entities/product_entity.dart';
import '../view_model/cubit/sales_cubit.dart';
import '../view_model/cubit/sales_invoice_state.dart';

class ProductSearchWidget extends StatefulWidget {
  const ProductSearchWidget({super.key});

  @override
  State<ProductSearchWidget> createState() => _ProductSearchWidgetState();
}

class _ProductSearchWidgetState extends State<ProductSearchWidget> {
  final TextEditingController qtyController = TextEditingController(text: '1');
  TextEditingController? _autoCompleteController;
  ProductEntity? selectedProduct;

  @override
  void dispose() {
    qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalesCubit, SalesState>(
      listenWhen: (previous, current) =>
          previous.isSuccess != current.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          qtyController.text = '1';
          _autoCompleteController?.clear();
          selectedProduct = null;
        }
      },
      buildWhen: (previous, current) =>
          previous.isLoadingProducts != current.isLoadingProducts ||
          previous.availableProducts != current.availableProducts,
      builder: (context, state) {
        return Card(
          elevation: 2,
          color: Colors.blue.shade50.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.blue.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Autocomplete<ProductEntity>(
                    displayStringForOption: (ProductEntity option) =>
                        option.name,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<ProductEntity>.empty();
                      }
                      return state.availableProducts.where((product) {
                        return product.name
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (ProductEntity selection) {
                      selectedProduct = selection;
                    },
                    fieldViewBuilder: (context, textEditingController,
                        focusNode, onFieldSubmitted) {
                      _autoCompleteController = textEditingController;
                      return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: state.isLoadingProducts
                              ? 'جاري تحميل الأصناف...'
                              : 'ابحث عن صنف بالمخزن...',
                          prefixIcon: state.isLoadingProducts
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.inventory_2),
                          border: const OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'الكمية',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (selectedProduct == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('⚠️ يرجى اختيار صنف صحيح من القائمة'),
                              backgroundColor: Colors.orange),
                        );
                        return;
                      }

                      final qty = int.tryParse(qtyController.text) ?? 1;
                      if (qty <= 0) return;

                      context.read<SalesCubit>().addItemToCart(
                            selectedProduct!.id,
                            selectedProduct!.name,
                            selectedProduct!.salePrice,
                            qty,
                          );

                      selectedProduct = null;
                      qtyController.text = '1';
                      _autoCompleteController?.clear();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة للجدول'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3498DB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
