import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/inventory_bloc.dart';
import '../bloc/inventory_event.dart';
import '../bloc/inventory_state.dart';

class CategoryManagementDialog extends StatefulWidget {
  final InventoryBloc bloc;

  const CategoryManagementDialog({super.key, required this.bloc});

  @override
  State<CategoryManagementDialog> createState() =>
      _CategoryManagementDialogState();
}

class _CategoryManagementDialogState extends State<CategoryManagementDialog> {
  final TextEditingController _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<InventoryBloc, InventoryState>(
        builder: (context, state) {
          final categories = (state is InventoryLoaded) ? state.categories : [];
          return AlertDialog(
            title: const Text('إدارة أقسام المخزن'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(
                              labelText: 'اسم القسم الجديد'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle,
                            color: Colors.green, size: 30),
                        onPressed: () {
                          if (_nameCtrl.text.trim().isNotEmpty) {
                            context
                                .read<InventoryBloc>()
                                .add(AddCategoryEvent(_nameCtrl.text.trim()));
                            _nameCtrl.clear();
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return ListTile(
                          title: Text(cat.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context
                                  .read<InventoryBloc>()
                                  .add(DeleteCategoryEvent(cat.id));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إغلاق')),
            ],
          );
        },
      ),
    );
  }
}
