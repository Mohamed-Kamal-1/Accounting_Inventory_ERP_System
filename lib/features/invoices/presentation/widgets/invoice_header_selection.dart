import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_text/invoices_text/invoices_strings.dart';
import '../../../../core/dimensions/Dimension_app.dart';
import '../../../accounts/domain/entities/account_entity.dart';
import '../../../accounts/presentation/view_model/cubit/Account_Cubit.dart';
import '../../../accounts/presentation/view_model/cubit/Accounts_State.dart';

class InvoiceHeaderSelection extends StatelessWidget {
  final String accountType;
  final String? selectedAccountId;
  final String? selectedRepId;
  final ValueChanged<String?> onAccountChanged;
  final ValueChanged<String?> onRepChanged;

  const InvoiceHeaderSelection({
    super.key,
    required this.accountType,
    required this.selectedAccountId,
    required this.selectedRepId,
    required this.onAccountChanged,
    required this.onRepChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        // 1. حالة التحميل
        if (state is AccountLoading || state is AccountInitial) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('جاري جلب الحسابات من قاعدة البيانات...',
                  style: TextStyle(color: Colors.blue)),
            ),
          );
        }

        // 2. حالة الفشل في جلب البيانات
        if (state is AccountError) {
          return Center(
            child: Text('فشل كارثي في جلب البيانات: ${state.message}',
                style: const TextStyle(color: Colors.red)),
          );
        }

        // 3. حالة نجاح جلب البيانات (هنا سنرى لماذا كانت فارغة)
        if (state is AccountLoaded) {
          // استخدام toLowerCase() لمنع فشل المقارنة بسبب الحروف الكبيرة والصغيرة في الداتا بيز
          final List<AccountEntity> accounts = state.accounts
              .where((a) =>
                  a.type.trim().toLowerCase() ==
                  accountType.trim().toLowerCase())
              .toList();

          final List<AccountEntity> reps = state.accounts
              .where((a) => a.type.trim().toLowerCase() == 'representative')
              .toList();

          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: accounts.isEmpty
                        ? 'الجدول فارغ من نوع ($accountType)'
                        : InvoicesStrings.selectAccount,
                    border: const OutlineInputBorder(),
                    errorText:
                        accounts.isEmpty ? 'أضف عملاء/موردين أولاً' : null,
                  ),
                  value: accounts.any((a) => a.id == selectedAccountId)
                      ? selectedAccountId
                      : null,
                  items: accounts.isEmpty
                      ? null // تعطيل القائمة عمداً لأنها فارغة
                      : accounts
                          .map((a) => DropdownMenuItem(
                              value: a.id, child: Text(a.name)))
                          .toList(),
                  onChanged: accounts.isEmpty ? null : onAccountChanged,
                ),
              ),
              const SizedBox(width: Dimension.spacing20),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: reps.isEmpty
                        ? 'لا يوجد مناديب في الداتا بيز'
                        : InvoicesStrings.selectRep,
                    border: const OutlineInputBorder(),
                    errorText: reps.isEmpty ? 'أضف مناديب أولاً' : null,
                  ),
                  value: reps.any((r) => r.id == selectedRepId)
                      ? selectedRepId
                      : null,
                  items: reps.isEmpty
                      ? null
                      : reps
                          .map((r) => DropdownMenuItem(
                              value: r.id, child: Text(r.name)))
                          .toList(),
                  onChanged: reps.isEmpty ? null : onRepChanged,
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
