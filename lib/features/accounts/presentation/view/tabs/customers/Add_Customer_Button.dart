// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../data/all_accounts.dart';
// import '../../../view_model/bloc/Account_Cubit.dart';
//
// class AddCustomerButton extends StatelessWidget {
//   const AddCustomerButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
//       onPressed: () => _showAddDialog(context),
//       icon: const Icon(Icons.person_add_alt_1),
//       label: const Text("إضافة عميل جديد"),
//     );
//   }
//
//   void _showAddDialog(BuildContext context) {
//     final name = TextEditingController();
//     final phone = TextEditingController();
//     final city = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("بيانات العميل"),
//         content: Column(mainAxisSize: MainAxisSize.min, children: [
//           TextField(controller: name, decoration: const InputDecoration(labelText: "الاسم")),
//           TextField(controller: phone, decoration: const InputDecoration(labelText: "الهاتف")),
//           TextField(controller: city, decoration: const InputDecoration(labelText: "المدينة")),
//         ]),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("إلغاء")),
//           ElevatedButton(onPressed: () {
//             final acc = AccountModel(id: DateTime.now().toString(), name: name.text, phone: phone.text, city: city.text, type: 'customer');
//             context.read<AccountsCubit>().addNewAccount(acc);
//
//             Navigator.pop(ctx);
//           }, child: const Text("حفظ")),
//         ],
//       ),
//     );
//   }
// }
