import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_theme/app_theme.dart';
import 'core/di/di.dart';
import 'core/routes/app_router.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تنبيه أمني: وضع المفاتيح هنا مباشرة هو ممارسة خاطئة في بيئة الإنتاج، يجب استخدام .env لاحقاً
  await Supabase.initialize(
    url: 'https://qskkxcuylefaxlqgpsnh.supabase.co',
    publishableKey: 'sb_publishable_MJB1LPjSks55efzlOumz9g__6X_yuRx',
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
  // 1. تعريف الراوتر كمتغير نهائي متأخر
  late final GoRouter _appRouter;

  @override
  void initState() {
    super.initState();
    // 2. إنشاء الراوتر مرة واحدة فقط في دورة حياة التطبيق
    _appRouter = AppRouter.createRouter();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // 3. التهيئة الصحيحة للـ Bloc باستخدام create
      create: (context) => getIt.get<AuthCubit>()..checkAuthStatus(),
      child: MaterialApp.router(
        title: 'Life Plast',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _appRouter,
      ),
    );
  }
}
