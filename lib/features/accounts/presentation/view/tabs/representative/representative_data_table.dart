// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../../all_data_service/data/models/account/all_accounts.dart';
// import '../../../view_model/bloc/Account_Cubit.dart';
//
// class RepresentativeDataTable extends StatelessWidget {
//   final String type;
//
//   final List<AccountModel> data;
//   final Color headerColor;
//
//   const RepresentativeDataTable(
//       {super.key, required this.data, required this.headerColor, required this.type});
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
//             ],
//           ),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: ConstrainedBox(
//               constraints: BoxConstraints(minWidth: constraints.maxWidth),
//               child: DataTable(
//                 headingRowColor: WidgetStateProperty.all(headerColor),
//                 horizontalMargin: 20,
//                 columnSpacing: 40,
//                 columns: const [
//                   DataColumn(
//                       label: Text("اسم المندوب ",
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text("المدينة",
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text("الهاتف",
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                   DataColumn(
//                       label: Text("الالغاء",
//                           style: TextStyle(fontWeight: FontWeight.bold))),
//                 ],
//                 rows: data
//                     .map((acc) =>
//                     DataRow(cells: [
//                       DataCell(Text(acc.name)),
//                       DataCell(Text(acc.city)),
//                       DataCell(Text(acc.phone)),
//                       DataCell(IconButton(
//                           icon: const Icon(Icons.delete,
//                               color: Colors.redAccent),
//                           onPressed: () {
//                             context
//                                 .read<AccountsCubit>()
//                                 .resetAllData(acc.id, type);
//                           })),
//                     ]))
//                     .toList(),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
