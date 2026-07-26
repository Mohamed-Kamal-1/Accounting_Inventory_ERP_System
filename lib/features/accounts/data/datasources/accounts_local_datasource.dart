// import 'package:drift/drift.dart';
// import 'package:injectable/injectable.dart';
//
// import '../../../../core/database/app_database.dart';
//
// abstract class AccountsLocalDataSource {
//   Future<List<AccountsTableData>> fetchAll();
//   Future<List<AccountsTableData>> fetchByType(String type);
//   Future<void> upsertAccount(AccountsTableCompanion account);
//   Future<void> deleteAccount(String id);
//   Future<List<AccountsTableData>> search(String query, String type);
// }
//
// @Singleton(as: AccountsLocalDataSource)
// class AccountsLocalDataSourceImpl implements AccountsLocalDataSource {
//   final AppDatabase _db;
//
//   AccountsLocalDataSourceImpl(this._db);
//
//   @override
//   Future<List<AccountsTableData>> fetchAll() async {
//     return await _db.select(_db.accountsTable).get();
//   }
//
//   @override
//   Future<List<AccountsTableData>> fetchByType(String type) async {
//     return await (_db.select(_db.accountsTable)
//           ..where((t) => t.type.equals(type)))
//         .get();
//   }
//
//   @override
//   Future<void> upsertAccount(AccountsTableCompanion account) async {
//     await _db.into(_db.accountsTable).insertOnConflictUpdate(account);
//   }
//
//   @override
//   Future<void> deleteAccount(String id) async {
//     await (_db.delete(_db.accountsTable)..where((t) => t.id.equals(id))).go();
//   }
//
//   @override
//   Future<List<AccountsTableData>> search(String query, String type) async {
//     return await (_db.select(_db.accountsTable)
//           ..where((t) =>
//               t.type.equals(type) &
//               (t.name.like('%$query%') | t.phone.like('%$query%'))))
//         .get();
//   }
// }
