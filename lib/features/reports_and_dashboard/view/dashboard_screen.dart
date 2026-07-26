import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.transparent, // تعتمد على لون الهيكل الرئيسي
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الهيدر وزر الإيداع
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 10,
                children: [
                  const Text(
                    'داشبورد الخزنة والسيولة',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _openAddModal(context),
                    icon: const Icon(Icons.add),
                    label: const Text('إيداع مبالغ إضافية'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2ECC71),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // كارت الفلاتر (التواريخ)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  const Text('من:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildDateInput('2026-07-01'),
                  const Text('إلى:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildDateInput('2026-07-20'),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C3E50)),
                    child: const Text('عرض النتائج',
                        style: TextStyle(color: Colors.white)),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('شغل اليوم'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // العدادات والبطاقات الخمسة
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildStatCard('تحصيلات السوق', '0.00',
                      const Color(0xFF2ECC71), Icons.handshake, screenWidth),
                  _buildStatCard('ماليات خاصة', '0.00', const Color(0xFFF39C12),
                      Icons.wallet, screenWidth),
                  _buildStatCard(
                      'مدفوعات موردين',
                      '0.00',
                      const Color(0xFFE74C3C),
                      Icons.local_shipping,
                      screenWidth),
                  _buildStatCard('إجمالي المصروفات', '0.00',
                      const Color(0xFFE67E22), Icons.receipt, screenWidth),
                  _buildStatCard(
                      'صافي الخزينة',
                      '0.00',
                      const Color(0xFF3498DB),
                      Icons.account_balance,
                      screenWidth,
                      isNet: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // جدول تفاصيل الحركة
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('تفاصيل حركة النقدية',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const Divider(),
                    const Expanded(
                      child: Center(
                        child: Text('جاري مزامنة البيانات...'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String val, Color color, IconData icon, double screenWidth,
      {bool isNet = false}) {
    double cardWidth = screenWidth > 1200
        ? (screenWidth - 240 - 80) / 5.2
        : screenWidth > 800
            ? (screenWidth - 240 - 50) / 3
            : screenWidth > 600
                ? (screenWidth - 50) / 2
                : screenWidth - 40;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isNet ? const Color(0xFF2C3E50) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(right: BorderSide(color: color, width: 5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 12,
                  color: isNet ? Colors.white70 : Colors.grey[700],
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(val,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isNet ? Colors.white : color)),
        ],
      ),
    );
  }

  static Widget _buildDateInput(String dateText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6)),
      child: Text(dateText),
    );
  }

  void _openAddModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة سيولة يدوية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(decoration: InputDecoration(labelText: 'المبلغ')),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: 'البيان')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('حفظ')),
        ],
      ),
    );
  }
}
