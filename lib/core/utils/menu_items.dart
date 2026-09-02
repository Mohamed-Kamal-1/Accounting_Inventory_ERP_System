import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

class SidebarItem {
  final String title;
  final String route;
  final IconData icon;
  final List<String> roles;
  final int branchIndex; // إضافة إجبارية

  const SidebarItem({
    required this.title,
    required this.route,
    required this.icon,
    required this.roles,
    required this.branchIndex, // إضافته هنا
  });
}

// تعديل القائمة لتتطابق مع ترتيب الفروع في AppRouter
final List<SidebarItem> appMenuItems = [
  SidebarItem(
    title: 'لوحة التحكم',
    route: AppRoute.dashboard,
    icon: Icons.dashboard,
    roles: ['admin', 'manager'],
    branchIndex: 0, // الفرع الأول
  ),
  SidebarItem(
    title: 'المبيعات',
    route: AppRoute.sales,
    icon: Icons.point_of_sale,
    roles: ['admin', 'manager', 'cashier'],
    branchIndex: 1, // الفرع الثاني
  ),
  SidebarItem(
    title: 'جهات الاتصال',
    route: AppRoute.contacts,
    icon: Icons.people,
    roles: ['admin', 'manager'],
    branchIndex: 2, // الفرع الثالث
  ),
  SidebarItem(
    title: 'المخازن',
    route: AppRoute.inventory,
    icon: Icons.inventory,
    roles: ['admin', 'manager'],
    branchIndex: 3, // الفرع الرابع
  ),
  SidebarItem(
    title: 'المشتريات',
    route: AppRoute.purchases,
    icon: Icons.shopify_outlined,
    roles: ['admin', 'manager'],
    branchIndex: 4, // الفرع الرابع
  ),
];
