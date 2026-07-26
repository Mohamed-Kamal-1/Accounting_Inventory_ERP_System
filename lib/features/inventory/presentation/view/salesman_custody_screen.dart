import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/entities/inventory_transaction_entity.dart';
import '../../domain/entities/salesman_custody_entity.dart';
import '../cubit/custody_cubit.dart';
import '../cubit/custody_state.dart';

class SalesmanCustodyScreen extends StatefulWidget {
  final String salesmanId;
  final String salesmanName;

  const SalesmanCustodyScreen({
    super.key,
    required this.salesmanId,
    required this.salesmanName,
  });

  @override
  State<SalesmanCustodyScreen> createState() => _SalesmanCustodyScreenState();
}

class _SalesmanCustodyScreenState extends State<SalesmanCustodyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt.get<CustodyCubit>()..loadSalesmanCustody(widget.salesmanId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('عهدة المندوب: ${widget.salesmanName}'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                  text: 'العهدة الحالية بالسيارة',
                  icon: Icon(Icons.local_shipping)),
              Tab(text: 'سجل حركات العهدة', icon: Icon(Icons.history)),
            ],
          ),
        ),
        body: BlocBuilder<CustodyCubit, CustodyState>(
          builder: (context, state) {
            if (state is CustodyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CustodyError) {
              return Center(
                  child: Text(state.message,
                      style: const TextStyle(color: Colors.red)));
            } else if (state is CustodyLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildCurrentCustodyTab(state.currentCustody),
                  _buildTransactionHistoryTab(state.transactions),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCurrentCustodyTab(List<SalesmanCustodyEntity> custody) {
    if (custody.isEmpty) {
      return const Center(
          child: Text('السيارة فارغة حالياً. لا توجد عهدة مسجلة.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: custody.length,
      itemBuilder: (context, index) {
        final item = custody[index];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.inventory_2)),
            title: Text(item.productName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(
              '${item.currentQty} قطعة',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionHistoryTab(List<InventoryTransactionEntity> txs) {
    if (txs.isEmpty) {
      return const Center(child: Text('لا توجد حركات عهدة سابقة.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: txs.length,
      itemBuilder: (context, index) {
        final tx = txs[index];
        final isWithdraw = tx.type == 'transfer_to_rep';
        return Card(
          child: ListTile(
            leading: Icon(
              isWithdraw ? Icons.arrow_downward : Icons.arrow_upward,
              color: isWithdraw ? Colors.red : Colors.green,
            ),
            title: Text(tx.productName),
            subtitle: Text(isWithdraw ? 'سحب عهدة' : 'مرتجع للعهدة'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${tx.quantity.abs()} قطعة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isWithdraw ? Colors.red : Colors.green,
                    fontSize: 16,
                  ),
                ),
                Text(
                  tx.createdAt.toLocal().toString().substring(0, 16),
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
