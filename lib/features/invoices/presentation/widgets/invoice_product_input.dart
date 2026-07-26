// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../core/app_text/invoices_text/invoices_strings.dart';
// import '../../../../core/dimensions/Dimension_app.dart';
// import '../../../inventory/domain/entities/product_entity.dart';
// import '../../../inventory/presentation/cubit/custody_cubit.dart';
// import '../../../inventory/presentation/cubit/inventory_state.dart';
//
// class InvoiceProductInput extends StatelessWidget {
//   final ProductEntity? currentSelectedProduct;
//   final TextEditingController qtyController;
//   final TextEditingController priceController;
//   final ValueChanged<ProductEntity?> onProductChanged;
//   final VoidCallback onAddPressed;
//
//   const InvoiceProductInput({
//     super.key,
//     required this.currentSelectedProduct,
//     required this.qtyController,
//     required this.priceController,
//     required this.onProductChanged,
//     required this.onAddPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(Dimension.padding16),
//         child: Row(
//           children: [
//             Expanded(
//               flex: 2,
//               child: BlocBuilder<InventoryCubit, InventoryState>(
//                 builder: (context, state) {
//                   List<ProductEntity> products = [];
//                   if (state is InventoryLoaded) products = state.products;
//                   return DropdownButtonFormField<ProductEntity>(
//                     decoration: const InputDecoration(
//                         labelText: InvoicesStrings.productName),
//                     value: currentSelectedProduct,
//                     items: products
//                         .map((p) =>
//                             DropdownMenuItem(value: p, child: Text(p.name)))
//                         .toList(),
//                     onChanged: onProductChanged,
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(width: Dimension.spacing12),
//             Expanded(
//               child: TextField(
//                 controller: qtyController,
//                 decoration:
//                     const InputDecoration(labelText: InvoicesStrings.quantity),
//                 keyboardType: TextInputType.number,
//               ),
//             ),
//             const SizedBox(width: Dimension.spacing12),
//             Expanded(
//               child: TextField(
//                 controller: priceController,
//                 decoration:
//                     const InputDecoration(labelText: InvoicesStrings.price),
//                 keyboardType:
//                     const TextInputType.numberWithOptions(decimal: true),
//               ),
//             ),
//             const SizedBox(width: Dimension.spacing12),
//             IconButton(
//               icon: const Icon(Icons.add_box,
//                   color: Colors.blue, size: Dimension.size48),
//               onPressed: onAddPressed,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
