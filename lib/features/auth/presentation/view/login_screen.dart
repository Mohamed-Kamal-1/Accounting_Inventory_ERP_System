import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/routes/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ❌ تم إزالة BlocProvider و Builder من هنا نهائياً
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildLoginForm(context, isMobile: true),
        desktop: _buildLoginForm(context, isMobile: false),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, {required bool isMobile}) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: isMobile ? double.infinity : 400,
          padding: const EdgeInsets.all(24.0),
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.message,
                          style: const TextStyle(color: Colors.white)),
                      backgroundColor: Colors.red),
                );
              } else if (state is AuthSuccess) {
                if (state.user.role == 'admin') {
                  context.go(AppRoute.sales);
                } else {
                  context.go(AppRoute.sales);
                }
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('تسجيل الدخول',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني / رقم الهاتف'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'كلمة المرور'),
                  ),
                  const SizedBox(height: 24),
                  if (state is AuthLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () {
                        if (emailController.text.trim().isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('برجاء إدخال كافة البيانات')),
                          );
                          return;
                        }
                        context.read<AuthCubit>().login(
                              emailController.text.trim(),
                              passwordController.text,
                            );
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50)),
                      child: const Text('دخول'),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
