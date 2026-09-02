import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/routes/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: ResponsiveLayout(
        mobile: RegisterFormWidget(isMobile: true),
        desktop: RegisterFormWidget(isMobile: false),
      ),
    );
  }
}

class RegisterFormWidget extends StatefulWidget {
  final bool isMobile;
  const RegisterFormWidget({super.key, required this.isMobile});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  // 💡 1. إضافة مفتاح النموذج للتحكم في التحقق
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isObscured = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: widget.isMobile ? double.infinity : 420,
          padding: const EdgeInsets.all(32.0),
          margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10)),
            ],
          ),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                // السناك بار هنا سيظهر فقط لأخطاء السيرفر (مثل: البريد مستخدم مسبقاً)
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message), backgroundColor: Colors.red));
              } else if (state is AuthSuccess) {
                context.go(AppRoute.sales);
              }
            },
            builder: (context, state) {
              // 💡 2. تغليف العمود بـ Form
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_add_alt_1_rounded,
                        size: 80, color: Colors.blueAccent),
                    const SizedBox(height: 16),
                    const Text('إنشاء حساب جديد',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B))),
                    const SizedBox(height: 32),

                    // 💡 3. تحويل TextField إلى TextFormField مع إضافة validator
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'برجاء إدخال الاسم الكامل';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'الاسم الكامل',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'برجاء إدخال البريد الإلكتروني';
                        }
                        // فحص صيغة البريد الإلكتروني (Regex) لمنع خطأ Supabase
                        final bool emailValid =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value);
                        if (!emailValid) {
                          return 'صيغة البريد الإلكتروني غير صحيحة';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: passwordController,
                      obscureText: _isObscured,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'برجاء إدخال كلمة المرور';
                        }
                        if (value.length < 6) {
                          return 'كلمة المرور يجب أن لا تقل عن 6 أحرف';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_isObscured
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              setState(() => _isObscured = !_isObscured),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _isObscured,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'برجاء تأكيد كلمة المرور';
                        }
                        if (value != passwordController.text) {
                          return 'كلمات المرور غير متطابقة';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (state is AuthLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () {
                          // 💡 4. تشغيل الفحص قبل إرسال البيانات للسيرفر
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().register(
                                  nameController.text.trim(),
                                  emailController.text.trim(),
                                  passwordController.text,
                                );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('تسجيل الحساب',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('لديك حساب بالفعل؟',
                            style: TextStyle(color: Colors.grey)),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('تسجيل الدخول',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent)),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
