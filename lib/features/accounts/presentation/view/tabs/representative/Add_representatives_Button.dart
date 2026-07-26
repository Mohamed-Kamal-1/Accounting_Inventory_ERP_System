// import 'package:flutter/material.dart';
//
// import '../../../../../all_data_service/data/models/account/all_accounts.dart';
// import '../../../view_model/bloc/Account_Cubit.dart';
//
// class AddRepresentativesButton extends StatefulWidget {
//   final String type;
//   final AccountCubit bloc; // نمرر الكيوبيت هنا
//
//   const AddRepresentativesButton(
//       {super.key, required this.type, required this.bloc});
//
//   @override
//   State<AddRepresentativesButton> createState() => _AddAccountDialogState();
// }
//
// class _AddAccountDialogState extends State<AddRepresentativesButton> {
//   final nameCtrl = TextEditingController();
//   final phoneCtrl = TextEditingController();
//   final cityCtrl = TextEditingController();
//
//   void _onSave() {
//     if (nameCtrl.text.trim().isNotEmpty) {
//       final newAcc = AccountModel(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         name: nameCtrl.text.trim(),
//         phone: phoneCtrl.text.trim(),
//         city: cityCtrl.text.trim(),
//         type: widget.type,
//       );
//
//       widget.bloc.addNewAccount(newAcc);
//       Navigator.of(context).pop();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text("إضافة بيانات المندوب",
//           textAlign: TextAlign.center,
//           style: const TextStyle(fontWeight: FontWeight.bold)),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameCtrl,
//               decoration: const InputDecoration(
//                   labelText: "اسم المندوب ", border: OutlineInputBorder()),
//               onSubmitted: (_) => _onSave(),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: phoneCtrl,
//               decoration: const InputDecoration(
//                   labelText: "الهاتف", border: OutlineInputBorder()),
//               keyboardType: TextInputType.phone,
//               onSubmitted: (_) => _onSave(),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: cityCtrl,
//               decoration: const InputDecoration(
//                   labelText: "المدينة", border: OutlineInputBorder()),
//               onSubmitted: (_) => _onSave(),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("إلغاء")),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.teal, foregroundColor: Colors.white),
//           onPressed: _onSave,
//           child: const Text("حفظ المندوب"),
//         ),
//       ],
//     );
//   }
// }
