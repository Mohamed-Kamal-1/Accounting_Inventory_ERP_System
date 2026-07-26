// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../view_model/bloc/Account_Cubit.dart';
//
// class AccountsSearchBar extends StatelessWidget {
//   const AccountsSearchBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: TextField(
//         onChanged: (value) {
//           // نداء دالة البحث في الكيوبيت فوراً مع كل حرف يتكتب
//           context.read<AccountsCubit>().searchAccounts(value);
//         },
//         decoration: const InputDecoration(
//           hintText: "بحث بالاسم أو رقم الهاتف...",
//           border: InputBorder.none,
//           icon: Icon(Icons.search, color: Colors.grey),
//         ),
//       ),
//     );
//   }
// }
