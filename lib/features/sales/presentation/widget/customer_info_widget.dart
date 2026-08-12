import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../contacts/domain/entities/contact_entity.dart';
import '../view_model/cubit/sales_cubit.dart';
import '../view_model/cubit/sales_invoice_state.dart';

class CustomerInfoWidget extends StatelessWidget {
  final TextEditingController contactController;
  final TextEditingController cityController;

  const CustomerInfoWidget({
    super.key,
    required this.contactController,
    required this.cityController,
  });

  // 💡 تصميم موحد وحديث لحقول الإدخال
  InputDecoration _modernInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.blueAccent.shade200, size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFC), // Slate 50
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: BlocBuilder<SalesCubit, SalesState>(
              buildWhen: (previous, current) =>
                  previous.filteredContacts != current.filteredContacts ||
                  previous.currentMode != current.currentMode,
              builder: (context, state) {
                return Autocomplete<ContactEntity>(
                  key: ValueKey(state.currentMode),
                  displayStringForOption: (ContactEntity option) => option.name,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<ContactEntity>.empty();
                    }
                    return state.filteredContacts
                        .where((ContactEntity contact) {
                      return contact.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (ContactEntity selection) {
                    contactController.text = selection.name;
                    cityController.text = selection.area;
                    context
                        .read<SalesCubit>()
                        .updateSelectedContact(selection.id);
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    textEditingController.addListener(() {
                      contactController.text = textEditingController.text;
                      if (textEditingController.text.isEmpty) {
                        context.read<SalesCubit>().updateSelectedContact('');
                        cityController.clear();
                      }
                    });

                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      onTap: () {
                        context.read<SalesCubit>().fetchContacts();
                      },
                      decoration: _modernInputDecoration(
                        state.currentMode == 'merchant'
                            ? 'اسم العميل / التاجر'
                            : (state.currentMode == 'salesman'
                                ? 'اسم المندوب'
                                : 'اسم المورد'),
                        Icons.person_search_rounded,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: TextField(
              controller: cityController,
              decoration: _modernInputDecoration(
                  'المدينة / المنطقة', Icons.location_on_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
