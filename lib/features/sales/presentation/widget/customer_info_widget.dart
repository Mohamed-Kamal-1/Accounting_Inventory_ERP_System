import 'package:flutter/material.dart';

class CustomerInfoWidget extends StatelessWidget {
  final TextEditingController contactController;
  final TextEditingController cityController;

  const CustomerInfoWidget({
    super.key,
    required this.contactController,
    required this.cityController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: contactController,
                decoration: const InputDecoration(
                  labelText: 'اسم العميل / المندوب...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 1,
              child: TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'المدينة / المنطقة',
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
