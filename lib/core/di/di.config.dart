// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/all_data_service/data/models/account/all_accounts.dart'
    as _i822;
import '../../features/all_data_service/data/models/product_model.dart'
    as _i515;
import '../../features/auth/data/data_sources/auth_remote_datasource.dart'
    as _i586;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/logout_usecase.dart' as _i48;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/contacts/data/datasources/contacts_remote_data_source.dart'
    as _i936;
import '../../features/contacts/data/repositories_impl/contacts_repository_impl.dart'
    as _i663;
import '../../features/contacts/domain/repositories/contacts_repository.dart'
    as _i909;
import '../../features/contacts/domain/usecases/add_contact_usecase.dart'
    as _i834;
import '../../features/contacts/domain/usecases/delete_contact_usecase.dart'
    as _i173;
import '../../features/contacts/domain/usecases/get_contacts_usecase.dart'
    as _i1050;
import '../../features/contacts/domain/usecases/update_contact_usecase.dart'
    as _i103;
import '../../features/contacts/presentation/bloc/contacts_bloc.dart' as _i295;
import '../../features/inventory/data/datasources/inventory_remote_datasource.dart'
    as _i103;
import '../../features/inventory/data/repositories/inventory_repository_impl.dart'
    as _i572;
import '../../features/inventory/domain/repositories/inventory_repository.dart'
    as _i422;
import '../../features/inventory/domain/usecases/category_usecases.dart'
    as _i431;
import '../../features/inventory/domain/usecases/product_usecases.dart'
    as _i607;
import '../../features/inventory/presentation/bloc/inventory_bloc.dart'
    as _i690;
import '../../features/inventory/presentation/cubit/custody_cubit.dart'
    as _i115;
import '../../features/inventory/presentation/view_model/cubit/inventory_cubit.dart'
    as _i232;
import '../../features/purchases/data/datasources/purchases_remote_datasource.dart'
    as _i212;
import '../../features/purchases/data/repositories_implementation/purchases_repository_impl.dart'
    as _i443;
import '../../features/purchases/domain/repositories/purchases_repository.dart'
    as _i363;
import '../../features/purchases/presentation/cubit/purchases_cubit.dart'
    as _i1054;
import '../../features/purchases_history/data/datasources/purchases_history_remote_datasource.dart'
    as _i1050;
import '../../features/purchases_history/data/repositories_implementation/purchases_history_repository_impl.dart'
    as _i126;
import '../../features/purchases_history/domain/repositories/purchases_history_repository.dart'
    as _i149;
import '../../features/purchases_history/presentation/cubit/purchases_history_cubit.dart'
    as _i432;
import '../../features/reports_and_dashboard/data/datasources/reports_remote_datasource.dart'
    as _i991;
import '../../features/reports_and_dashboard/data/datasources/treasury_remote_datasource.dart'
    as _i121;
import '../../features/reports_and_dashboard/data/repositories/reports_repository_impl.dart'
    as _i471;
import '../../features/reports_and_dashboard/data/repositories/treasury_repository_impl.dart'
    as _i418;
import '../../features/reports_and_dashboard/domain/repositories/reports_repository.dart'
    as _i959;
import '../../features/reports_and_dashboard/domain/repositories/treasury_repository.dart'
    as _i656;
import '../../features/reports_and_dashboard/domain/usecases/get_dashboard_stats_usecase.dart'
    as _i1015;
import '../../features/reports_and_dashboard/domain/usecases/get_treasury_transactions_usecase.dart'
    as _i126;
import '../../features/reports_and_dashboard/presentation/cubit/reports_cubit.dart'
    as _i793;
import '../../features/sales/data/datasources/sales_remote_datasource.dart'
    as _i1019;
import '../../features/sales/data/repositories_impl/sales_repository_impl.dart'
    as _i735;
import '../../features/sales/domain/repositories/sales_repository.dart'
    as _i434;
import '../../features/sales/presentation/view_model/cubit/sales_cubit.dart'
    as _i228;
import '../../features/sales_history/data/datasources/sales_history_remote_data_source.dart'
    as _i303;
import '../../features/sales_history/data/repositories/sales_history_repository_impl.dart'
    as _i874;
import '../../features/sales_history/domain/repositories/sales_history_repository.dart'
    as _i230;
import '../../features/sales_history/presentation/view_model/cubit/sales_history_cubit.dart'
    as _i478;
import 'module/register_module.dart' as _i209;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.singleton<_i822.AccountService>(() => _i822.AccountService());
    gh.singleton<_i515.ProductService>(() => _i515.ProductService());
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.factory<_i1019.SalesRemoteDataSource>(
        () => _i1019.SalesRemoteDataSourceImpl(gh<_i454.SupabaseClient>()));
    gh.lazySingleton<_i303.SalesHistoryRemoteDataSource>(() =>
        _i303.SalesHistoryRemoteDataSource(
            supabaseClient: gh<_i454.SupabaseClient>()));
    gh.singleton<_i121.TreasuryRemoteDataSource>(
        () => _i121.TreasuryRemoteDataSourceImpl());
    gh.singleton<_i991.ReportsRemoteDataSource>(
        () => _i991.ReportsRemoteDataSourceImpl());
    gh.factory<_i586.AuthRemoteDataSourceImpl>(
        () => _i586.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()));
    gh.factory<_i936.ContactsRemoteDataSourceImpl>(
        () => _i936.ContactsRemoteDataSourceImpl(gh<_i454.SupabaseClient>()));
    gh.factory<_i103.InventoryRemoteDataSource>(
        () => _i103.InventoryRemoteDataSource(gh<_i454.SupabaseClient>()));
    gh.singleton<_i212.PurchasesRemoteDataSource>(
        () => _i212.PurchasesRemoteDataSourceImpl());
    gh.singleton<_i1050.PurchasesHistoryRemoteDataSource>(
        () => _i1050.PurchasesHistoryRemoteDataSourceImpl());
    gh.singleton<_i363.PurchasesRepository>(() =>
        _i443.PurchasesRepositoryImpl(gh<_i212.PurchasesRemoteDataSource>()));
    gh.factory<_i787.AuthRepository>(
        () => _i153.AuthRepositoryImpl(gh<_i586.AuthRemoteDataSourceImpl>()));
    gh.singleton<_i656.TreasuryRepository>(() =>
        _i418.TreasuryRepositoryImpl(gh<_i121.TreasuryRemoteDataSource>()));
    gh.singleton<_i959.ReportsRepository>(
        () => _i471.ReportsRepositoryImpl(gh<_i991.ReportsRemoteDataSource>()));
    gh.factory<_i232.InventoryCubit>(
        () => _i232.InventoryCubit(gh<_i515.ProductService>()));
    gh.singleton<_i149.PurchasesHistoryRepository>(() =>
        _i126.PurchasesHistoryRepositoryImpl(
            gh<_i1050.PurchasesHistoryRemoteDataSource>()));
    gh.factory<_i188.LoginUseCase>(
        () => _i188.LoginUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i48.LogoutUseCase>(
        () => _i48.LogoutUseCase(gh<_i787.AuthRepository>()));
    gh.lazySingleton<_i117.AuthCubit>(() => _i117.AuthCubit(
          gh<_i188.LoginUseCase>(),
          gh<_i787.AuthRepository>(),
          gh<_i48.LogoutUseCase>(),
        ));
    gh.factory<_i909.ContactsRepository>(() =>
        _i663.ContactsRepositoryImpl(gh<_i936.ContactsRemoteDataSourceImpl>()));
    gh.factory<_i1054.PurchasesCubit>(
        () => _i1054.PurchasesCubit(gh<_i212.PurchasesRemoteDataSource>()));
    gh.factory<_i434.SalesRepository>(
        () => _i735.SalesRepositoryImpl(gh<_i1019.SalesRemoteDataSource>()));
    gh.factory<_i432.PurchasesHistoryCubit>(() =>
        _i432.PurchasesHistoryCubit(gh<_i149.PurchasesHistoryRepository>()));
    gh.factory<_i1015.GetDashboardStatsUseCase>(
        () => _i1015.GetDashboardStatsUseCase(gh<_i959.ReportsRepository>()));
    gh.lazySingleton<_i230.SalesHistoryRepository>(() =>
        _i874.SalesHistoryRepositoryImpl(
            remoteDataSource: gh<_i303.SalesHistoryRemoteDataSource>()));
    gh.factory<_i422.InventoryRepository>(() =>
        _i572.InventoryRepositoryImpl(gh<_i103.InventoryRemoteDataSource>()));
    gh.factory<_i126.GetTreasuryTransactionsUseCase>(() =>
        _i126.GetTreasuryTransactionsUseCase(gh<_i656.TreasuryRepository>()));
    gh.factory<_i115.CustodyCubit>(
        () => _i115.CustodyCubit(gh<_i422.InventoryRepository>()));
    gh.factory<_i431.GetCategoriesUseCase>(
        () => _i431.GetCategoriesUseCase(gh<_i422.InventoryRepository>()));
    gh.factory<_i431.AddCategoryUseCase>(
        () => _i431.AddCategoryUseCase(gh<_i422.InventoryRepository>()));
    gh.factory<_i431.DeleteCategoryUseCase>(
        () => _i431.DeleteCategoryUseCase(gh<_i422.InventoryRepository>()));
    gh.factory<_i607.GetProductsUseCase>(
        () => _i607.GetProductsUseCase(gh<_i422.InventoryRepository>()));
    gh.factory<_i607.AddProductUseCase>(
        () => _i607.AddProductUseCase(gh<_i422.InventoryRepository>()));
    gh.factory<_i607.UpdateProductUseCase>(
        () => _i607.UpdateProductUseCase(gh<_i422.InventoryRepository>()));
    gh.factory<_i607.DeleteProductUseCase>(
        () => _i607.DeleteProductUseCase(gh<_i422.InventoryRepository>()));
    gh.factory<_i834.AddContactUseCase>(
        () => _i834.AddContactUseCase(gh<_i909.ContactsRepository>()));
    gh.factory<_i173.DeleteContactUseCase>(
        () => _i173.DeleteContactUseCase(gh<_i909.ContactsRepository>()));
    gh.factory<_i1050.GetContactsUseCase>(
        () => _i1050.GetContactsUseCase(gh<_i909.ContactsRepository>()));
    gh.factory<_i103.UpdateContactUseCase>(
        () => _i103.UpdateContactUseCase(gh<_i909.ContactsRepository>()));
    gh.factory<_i228.SalesCubit>(() => _i228.SalesCubit(
          gh<_i422.InventoryRepository>(),
          gh<_i909.ContactsRepository>(),
        ));
    gh.factory<_i478.SalesHistoryCubit>(() => _i478.SalesHistoryCubit(
        repository: gh<_i230.SalesHistoryRepository>()));
    gh.factory<_i295.ContactsBloc>(() => _i295.ContactsBloc(
          gh<_i1050.GetContactsUseCase>(),
          gh<_i834.AddContactUseCase>(),
          gh<_i173.DeleteContactUseCase>(),
          gh<_i103.UpdateContactUseCase>(),
        ));
    gh.factory<_i690.InventoryBloc>(() => _i690.InventoryBloc(
          gh<_i431.GetCategoriesUseCase>(),
          gh<_i431.AddCategoryUseCase>(),
          gh<_i431.DeleteCategoryUseCase>(),
          gh<_i607.GetProductsUseCase>(),
          gh<_i607.AddProductUseCase>(),
          gh<_i607.UpdateProductUseCase>(),
          gh<_i607.DeleteProductUseCase>(),
        ));
    gh.lazySingleton<_i793.ReportsCubit>(() => _i793.ReportsCubit(
          gh<_i1015.GetDashboardStatsUseCase>(),
          gh<_i126.GetTreasuryTransactionsUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i209.RegisterModule {}
