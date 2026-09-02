import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/routes/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: ResponsiveLayout(
        mobile: LoginFormWidget(isMobile: true),
        desktop: LoginFormWidget(isMobile: false),
      ),
    );
  }
}

// 💡 الكلاس المعماري الصحيح للواجهة
class LoginFormWidget extends StatefulWidget {
  final bool isMobile;
  const LoginFormWidget({super.key, required this.isMobile});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: widget.isMobile ? double.infinity : 420,
          padding: const EdgeInsets.all(32.0),
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message), backgroundColor: Colors.red));
              } else if (state is AuthSuccess) {
                context.go(AppRoute.sales);
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_circle_rounded,
                      size: 80, color: Colors.blueAccent),
                  const SizedBox(height: 16),
                  const Text('مرحباً بعودتك',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B))),
                  const SizedBox(height: 8),
                  const Text('قم بتسجيل الدخول للمتابعة',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 32),

                  // حقل البريد
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // حقل كلمة المرور
                  TextField(
                    controller: passwordController,
                    obscureText: _isObscured,
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
                  const SizedBox(height: 32),

                  // زر الدخول
                  if (state is AuthLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () {
                        if (emailController.text.trim().isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('برجاء إدخال كافة البيانات')));
                          return;
                        }
                        context.read<AuthCubit>().login(
                            emailController.text.trim(),
                            passwordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('تسجيل الدخول',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ليس لديك حساب؟',
                          style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () => context.push(AppRoute.register),
                        child: const Text('إنشاء حساب جديد',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent)),
                      )
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
