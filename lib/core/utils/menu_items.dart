import 'package:flutter/material.dart';

class SidebarItem {
  final String title;
  final IconData icon;
  final String route;
  final List<String> roles;

  const SidebarItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.roles,
  });
}

const List<SidebarItem> appMenuItems = [
  // ====================== قسم الإدارة (Admin) ======================
  SidebarItem(
      title: 'لوحة التحكم',
      icon: Icons.dashboard,
      route: '/dashboard',
      roles: ['admin']),
  SidebarItem(
      title: 'فاتورة بيع',
      icon: Icons.receipt,
      route: '/sales',
      roles: ['admin']),
  SidebarItem(
      title: 'المشتريات',
      icon: Icons.shopping_cart,
      route: '/purchases',
      roles: ['admin']),
  SidebarItem(
      title: 'المرتجعات',
      icon: Icons.assignment_return,
      route: '/returns',
      roles: ['admin']),
  SidebarItem(
      title: 'سداد وتحصيل نقدي',
      icon: Icons.calendar_today,
      route: '/today_invoices',
      roles: ['admin']),
  SidebarItem(
      title: 'الخزينة والسيولة',
      icon: Icons.account_balance_wallet,
      route: '/finance',
      roles: ['admin']),
  SidebarItem(
      title: 'مصروفات',
      icon: Icons.money_off,
      route: '/admin_expenses',
      roles: ['admin']),
  SidebarItem(
      title: 'المخزن',
      icon: Icons.inventory,
      route: '/inventory',
      roles: ['admin']),
  SidebarItem(
      title: 'مراجعة معاينات',
      icon: Icons.fact_check,
      route: '/admin_previews',
      roles: ['admin']),
  SidebarItem(
      title: 'مناديب',
      icon: Icons.people_alt,
      route: '/agents_report',
      roles: ['admin']),
  SidebarItem(
      title: 'الزيارات والخطوط',
      icon: Icons.map,
      route: '/admin_monitor',
      roles: ['admin']),
  SidebarItem(
      title: 'التوالف',
      icon: Icons.remove_shopping_cart,
      route: '/damages',
      roles: ['admin']),
  SidebarItem(
      title: 'إضافة عملاء',
      icon: Icons.person_add,
      route: '/contacts',
      roles: ['admin']),
  SidebarItem(
      title: 'كشوفات الحسابات',
      icon: Icons.receipt_long,
      route: '/statement',
      roles: ['admin']),
  SidebarItem(
      title: 'التقارير المالية',
      icon: Icons.bar_chart,
      route: '/reports',
      roles: ['admin']),
  SidebarItem(
      title: 'الإعدادات',
      icon: Icons.settings,
      route: '/settings',
      roles: ['admin']),

  // ====================== قسم المناديب (Sales) ======================
  SidebarItem(
      title: 'مخزني',
      icon: Icons.inventory_2,
      route: '/salesman_inventory',
      roles: ['sales']),
  SidebarItem(
      title: 'الزيارات',
      icon: Icons.directions_walk,
      route: '/rep_visit',
      roles: ['sales']),
  SidebarItem(
      title: 'فاتورة بيع',
      icon: Icons.add_shopping_cart,
      route: '/salesman_sales',
      roles: ['sales']),
  SidebarItem(
      title: 'مرتجع بيع',
      icon: Icons.keyboard_return,
      route: '/sales_return',
      roles: ['sales']),
  SidebarItem(
      title: 'سداد نقدي',
      icon: Icons.payments,
      route: '/collect_payment',
      roles: ['sales']),
  SidebarItem(
      title: 'كشف حساب تاجر',
      icon: Icons.account_box,
      route: '/salesman_customers',
      roles: ['sales']),

  // ====================== قسم المعاينات (Preview) ======================
  SidebarItem(
      title: 'معاينات',
      icon: Icons.search,
      route: '/preview',
      roles: ['preview']),
  SidebarItem(
      title: 'طلبات معاينات',
      icon: Icons.assignment,
      route: '/agent_tasks',
      roles: ['preview']),

  // ====================== قسم الفنيين (Technician) ======================
  SidebarItem(
      title: 'طلب معاينة',
      icon: Icons.handyman,
      route: '/preview_request',
      roles: ['technician']),
  SidebarItem(
      title: 'تقارير المعاينات',
      icon: Icons.plumbing,
      route: '/plumber_dash',
      roles: ['technician']),
];
