// import 'package:accounting_desktop/features/accounts/presentation/view/accounts_screen.dar.dart';
// import 'package:accounting_desktop/features/accounts/presentation/view/tabs/representative/Add_representatives_Button.dart';
// import 'package:accounting_desktop/features/accounts/presentation/view/tabs/representative/representative_data_table.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../view_model/bloc/Account_Cubit.dart';
// import '../../../view_model/bloc/Accounts_State.dart';
//
//
//
// class RepresentativeTab extends StatelessWidget {
//   const RepresentativeTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         children: [
//           TextField(
//             onChanged: (v) => context
//                 .read<AccountCubit>()
//                 .searchAccounts(v, AccountsScreen.representative),
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
//                     builder: (_) => AddRepresentativesButton(
//                           type: AccountsScreen.representative,
//                           bloc: context.read<AccountsCubit>(),
//                         )),
//                 icon: const Icon(Icons.add),
//                 label: const Text("إضافة المندوب"),
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: BlocBuilder<AccountsCubit, AccountsState>(
//               builder: (context, state) {
//                 if (state is AccountsLoaded) {
//                   return RepresentativeDataTable(
//                       data: state.accounts,
//                       headerColor: Colors.teal[50]!,
//                       type: AccountsScreen.representative);
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
