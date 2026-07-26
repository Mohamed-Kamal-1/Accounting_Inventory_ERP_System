import 'package:flutter/material.dart';
import '../../../../core/app_text/reports_text/reports_screen_text.dart';
import 'app_date_picker.dart';

class ReportFilterHeader extends StatelessWidget {
  const ReportFilterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    bool isPC = w > 800;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 15, runSpacing: 15,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(width: isPC ? 250 : double.infinity, child: const TextField(decoration: InputDecoration(hintText: ReportsStrings.searchHint, prefixIcon: Icon(Icons.search), border: OutlineInputBorder()))),
            SizedBox(width: isPC ? 180 : double.infinity, child: const AppDatePicker(label: "من تاريخ")),
            // اختيار تاريخ النهاية
            SizedBox(width: isPC ? 180 : double.infinity, child: const AppDatePicker(label: "إلى تاريخ")),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18)),
              onPressed: () {},
              icon: const Icon(Icons.analytics),
              label: const Text(ReportsStrings.showReport),
            ),
          ],
        ),
      ),
    );
  }


}