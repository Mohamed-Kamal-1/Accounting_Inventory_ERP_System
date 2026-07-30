import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // تأكد من استدعاء هذه الحزمة
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_theme/app_theme.dart';
import 'core/di/di.dart';
import 'core/routes/app_router.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qskkxcuylefaxlqgpsnh.supabase.co',
    publishableKey: 'sb_publishable_MJB1LPjSks55efzlOumz9g__6X_yuRx',
  );

  configureDependencies();

  final authCubit = getIt<AuthCubit>();
  final router = AppRouter.createRouter(authCubit);

  runApp(
    BlocProvider.value(
      value: authCubit..checkAuthStatus(),
      child: AccountingApp(appRouter: router),
    ),
  );
}

class AccountingApp extends StatelessWidget {
  final GoRouter appRouter;

  const AccountingApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Life Plast',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // 3. استخدام الراوتر الممرر وعدم إنشائه من جديد
      routerConfig: appRouter,
    );
  }
}
