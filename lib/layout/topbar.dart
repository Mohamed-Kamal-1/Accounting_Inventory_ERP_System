// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../core/dimensions/Dimension_app.dart';
// import 'navigation_controller.dart';
//
// class TopBar extends StatelessWidget {
//   static const String appTitle = 'Accounting System';
//   static const String permissionTitle = 'Admin';
//
//   const TopBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: Dimension.heightTabBar56,
//       padding: const EdgeInsets.symmetric(horizontal: Dimension.padding16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             // استخدام withValues بدلاً من Opacity للأداء
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: const [
//           MenuToggleButton(), // الكلاس المنفصل للزرار
//           SizedBox(width: 8),
//           Text(
//             appTitle,
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Spacer(),
//           Text(
//             permissionTitle,
//             style: TextStyle(color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // كلاس منفصل لزرار القائمة (Responsive Menu Button)
// class MenuToggleButton extends StatelessWidget {
//   const MenuToggleButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // استخدام MediaQuery.sizeOf(context) كما طلبت لضمان أداء أسرع
//     final double screenWidth = MediaQuery.sizeOf(context).width;
//     final bool isMobile = screenWidth < 1000;
//
//     // إذا لم تكن الشاشة موبايل، لا ترسم الزرار
//     if (!isMobile) return const SizedBox.shrink();
//
//     return IconButton(
//       icon: const Icon(Icons.menu),
//       onPressed: () {
//         // الوصول للـ scaffoldKey لفتح القائمة الجانبية (Drawer)
//         context
//             .read<NavigationController>()
//             .scaffoldKey
//             .currentState
//             ?.openDrawer();
//       },
//     );
//   }
// }
