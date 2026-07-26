import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../../../core/dimensions/Dimension_app.dart';
import '../view_model/cubit/Account_Cubit.dart';
import '../view_model/cubit/Accounts_State.dart';
import 'accounts_action_bar.dart';
import 'accounts_data_table.dart';

class AccountTabContent extends StatelessWidget {
  final String type;

  const AccountTabContent({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<AccountCubit>()..fetchAccounts(type),
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(Dimension.padding20),
            child: Column(
              children: [
                AccountsActionBar(type: type),
                const SizedBox(height: Dimension.heightSizeBox20),
                Expanded(
                  child: BlocBuilder<AccountCubit, AccountState>(
                    builder: (context, state) {
                      if (state is AccountLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AccountLoaded) {
                        if (state.accounts.isEmpty) {
                          return const Center(
                              child: Text('لا توجد بيانات حالياً'));
                        }
                        return AccountsDataTable(
                            data: state.accounts, type: type);
                      } else if (state is AccountError) {
                        return Center(child: Text(state.message));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
