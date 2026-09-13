import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_theme/app_theme.dart';
import 'core/di/di.dart';
import 'core/routes/app_router.dart';
import 'core/services/desktop_updater.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DesktopUpdater.checkAndUpdate();
  await Supabase.initialize(
      // url: 'https://qwpfacmvoimxatyxwzsd.supabase.co',
      // anonKey: 'sb_publishable_rYHeXeEBXY1wl-LJbOIjew_9OmuK0UH'
      url: 'https://qskkxcuylefaxlqgpsnh.supabase.co',
      publishableKey: 'sb_publishable_MJB1LPjSks55efzlOumz9g__6X_yuRx');

  configureDependencies();

  runApp(const AccountingApp());
}

class AccountingApp extends StatefulWidget {
  const AccountingApp({super.key});

  @override
  State<AccountingApp> createState() => _AccountingAppState();
}

class _AccountingAppState extends State<AccountingApp> {
  static const String title = "Life Plast";
  late final GoRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter.createRouter();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<AuthCubit>()..checkAuthStatus(),
      child: MaterialApp.router(
        title: title,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _appRouter,
      ),
    );
  }
}
