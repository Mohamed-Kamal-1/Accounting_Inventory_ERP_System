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
    url: 'https://qskkxcuylefaxlqgpsnh.supabase.co',
    publishableKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFza2t4Y3V5bGVmYXhscWdwc25oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM3NDI1NDEsImV4cCI6MjA5OTMxODU0MX0.SumZzcYLvTMQ2VlfDbjiIUoAZzDtfG8EEt5Ca9AGqtE',
  );

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
