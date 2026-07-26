// import 'package:injectable/injectable.dart';
//
// import '../../../../core/database/app_database.dart';
// import '../../domain/entities/account_entity.dart';
// import '../../domain/repositories/accounts_repository.dart';
// import '../datasources/accounts_local_datasource.dart';
// import '../datasources/accounts_remote_datasource.dart';
//
// @Singleton(as: AccountsRepository)
// class AccountsRepositoryImpl implements AccountsRepository {
//   final AccountsLocalDataSource _localDb;
//   final AccountsRemoteDataSource _remoteApi;
//
//   AccountsRepositoryImpl(this._localDb, this._remoteApi);
//
//   @override
//   Future<List<AccountEntity>> getAccounts(String type) async {
//     // 1. محاولة مزامنة صامتة من السيرفر (Supabase) إلى قاعدة البيانات المحلية (Drift)
//     try {
//       final remoteAccounts = await _remoteApi.fetchAllAccounts();
//       for (var json in remoteAccounts) {
//         await _localDb.upsertAccount(
//           AccountsTableCompanion.insert(
//             id: json['id'].toString(),
//             name: json['name'].toString(),
//             type: json['type'].toString(),
//             phone: json['phone']?.toString() ?? '',
//             city: json['city']?.toString() ?? '',
//           ),
//         );
//       }
//     } catch (_) {
//       // تجاهل الخطأ في حالة عدم وجود إنترنت لضمان عمل التطبيق أوفلاين بسلاسة
//     }
//
//     // 2. القراءة النهائية والدائمة تتم من قاعدة البيانات المحلية (Drift)
//     final localData = (type == 'all' || type.trim().isEmpty)
//         ? await _localDb.fetchAll()
//         : await _localDb.fetchByType(type);
//
//     return localData.map(_mapToEntity).toList();
//   }
//
//   @override
//   Future<void> addAccount(AccountEntity account) async {
//     // 1. الحفظ المحلي فوراً في Drift لتسريع الواجهة للمستخدم
//     await _localDb.upsertAccount(
//       AccountsTableCompanion.insert(
//         id: account.id,
//         name: account.name,
//         type: account.type,
//         phone: account.phone,
//         city: account.city,
//       ),
//     );
//
//     // 2. الرفع إلى السيرفر (Supabase) في الخلفية
//     try {
//       await _remoteApi.insertAccount({
//         'id': account.id,
//         'name': account.name,
//         'type': account.type,
//         'phone': account.phone,
//         'city': account.city,
//       });
//     } catch (_) {
//       // الحفظ المحلي يضمن عدم ضياع البيانات حتى لو كنت أوفلاين
//     }
//   }
//
//   @override
//   Future<void> deleteAccount(String id) async {
//     await _localDb.deleteAccount(id);
//     try {
//       await _remoteApi.removeAccount(id);
//     } catch (_) {}
//   }
//
//   @override
//   Future<List<AccountEntity>> getAccountsByType(String type) async {
//     return await getAccounts(type);
//   }
//
//   @override
//   Future<List<AccountEntity>> searchAccounts(String query, String type) async {
//     final results = await _localDb.search(query, type);
//     return results.map(_mapToEntity).toList();
//   }
//
//   // دالة مساعدة لتحويل الـ Table Data الخاص بـ Drift إلى الـ Entity الخاصة بالـ Domain
//   AccountEntity _mapToEntity(AccountsTableData row) {
//     return AccountEntity(
//       id: row.id,
//       name: row.name,
//       type: row.type,
//       phone: row.phone ?? '',
//       city: row.city ?? '',
//     );
//   }
// }
