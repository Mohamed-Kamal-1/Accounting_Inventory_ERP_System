import 'package:flutter/material.dart';

import '../../view/dashboard_screen.dart';

class DashboardFiltersWidget extends StatelessWidget {
  final bool isMobile;
  final String startDateText;
  final String endDateText;
  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;
  final VoidCallback onShowResultsTap;
  final VoidCallback onTodayTap;

  const DashboardFiltersWidget({
    super.key,
    required this.isMobile,
    required this.startDateText,
    required this.endDateText,
    required this.onStartDateTap,
    required this.onEndDateTap,
    required this.onShowResultsTap,
    required this.onTodayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('تصفية بالمدة:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: DateInputWidget(
                            dateText: startDateText, onTap: onStartDateTap)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('إلى:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                        child: DateInputWidget(
                            dateText: endDateText, onTap: onEndDateTap)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onShowResultsTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('عرض النتائج',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onTodayTap,
                        icon: const Icon(Icons.today, size: 16),
                        label: const Text('شغل اليوم',
                            style: TextStyle(fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 15,
              runSpacing: 15,
              children: [
                const Text('تصفية بالمدة:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                DateInputWidget(dateText: startDateText, onTap: onStartDateTap),
                const Text('إلى:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                DateInputWidget(dateText: endDateText, onTap: onEndDateTap),
                ElevatedButton(
                  onPressed: onShowResultsTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('عرض النتائج',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                OutlinedButton.icon(
                  onPressed: onTodayTap,
                  icon: const Icon(Icons.today, size: 18),
                  label: const Text('شغل اليوم'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
    );
  }
}
