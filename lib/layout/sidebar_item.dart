// import 'package:flutter/material.dart';
// import '../core/colors/app_color.dart';
//
// class SidebarItem extends StatelessWidget {
//   final String title;
//   final VoidCallback onTap;
//   final IconData icon;
//   final bool isActive;
//
//   const SidebarItem({
//     super.key,
//     required this.title,
//     required this.onTap,
//     required this.isActive,
//     required this.icon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       // تحديد أيقونة العنصر مع تغيير الشفافية بناءً على الحالة
//       leading: Icon(
//         icon,
//         color: isActive
//             ? Colors.white
//             : Colors.white.withValues(alpha: 0.7),
//       ),
//       // تفعيل حالة الاختيار برمجياً
//       selected: isActive,
//       // لون الخلفية عند الاختيار (مأخوذ من ملف الألوان الخاص بك)
//       selectedTileColor: AppColor.selectionColor,
//       // نص العنصر
//       title: Text(
//         title,
//         style: TextStyle(
//           color: isActive
//               ? Colors.white
//               : Colors.white.withValues(alpha: 0.9),
//           fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//       onTap: onTap,
//       // تغيير شكل الماوس عند الوقوف على العنصر (مناسب للويب والديسكطوب)
//       mouseCursor: SystemMouseCursors.click,
//     );
//   }
// }
