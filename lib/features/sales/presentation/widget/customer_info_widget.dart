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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
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
                      decoration: InputDecoration(
                        labelText: state.currentMode == 'merchant'
                            ? 'اسم العميل / التاجر'
                            : (state.currentMode == 'salesman'
                                ? 'اسم المندوب'
                                : 'اسم المورد'),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
              decoration: InputDecoration(
                labelText: 'المدينة / المنطقة',
                prefixIcon: const Icon(Icons.location_city),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
