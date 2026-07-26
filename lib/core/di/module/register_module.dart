// lib/core/di/register_module.dart

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class RegisterModule {
  // تسجيل كائن السوبابيز الفعلي داخل الـ GetIt آلياً
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}
