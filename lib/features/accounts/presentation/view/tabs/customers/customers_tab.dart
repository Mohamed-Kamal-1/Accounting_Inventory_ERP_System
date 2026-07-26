// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../view_model/bloc/Account_Cubit.dart';
// import '../../../view_model/bloc/Accounts_State.dart';
// import '../../../widgets/add_account_dialog.dart';
// import 'customer_data_table.dart';
//
// class CustomersTab extends StatelessWidget {
//   static const String customer = 'customer';
//
//   const CustomersTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           TextField(
//             onChanged: (v) =>
//                 context.read<AccountCubit>().searchAccounts(v, 'customer'),
//             decoration: InputDecoration(
//               hintText: "بحث في العملاء...",
//               prefixIcon: const Icon(Icons.search),
//               filled: true,
//               fillColor: Colors.grey[100],
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.teal,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 25, vertical: 15)),
//                 onPressed: () => showDialog(
//                     context: context,
//                     builder: (_) => AddAccountDialog(
//                           type: 'customer',
//                           bloc: context.read<AccountCubit>(),
//                         )),
//                 icon: const Icon(Icons.add),
//                 label: const Text("إضافة عميل"),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: BlocBuilder<AccountCubit, AccountState>(
//               builder: (context, state) {
//                 if (state is AccountLoaded) {
//                   return CustomerDataTable(
//                       data: state.accounts,
//                       headerColor: Colors.teal[50]!,
//                       type: customer);
//                 }
//                 return const Center(child: CircularProgressIndicator());
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
