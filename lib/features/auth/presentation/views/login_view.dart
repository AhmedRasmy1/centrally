import 'package:centrally/core/di/di.dart';
import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/router/routes_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/core/widgets/brand_logo.dart';
import 'package:centrally/features/auth/presentation/view_models/login_view_model/login_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:centrally/features/auth/presentation/widgets/email_field.dart';
import 'package:centrally/features/auth/presentation/widgets/password_field.dart';
import 'package:centrally/features/auth/presentation/widgets/remember_forgor_row.dart';
import 'package:centrally/features/auth/presentation/widgets/sign_up_row.dart';
import 'package:centrally/features/auth/presentation/widgets/submit_button.dart';
import 'package:centrally/features/auth/presentation/widgets/welcome_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  late LoginCubit loginCubit;

  @override
  void initState() {
    super.initState();
    loginCubit = getIt.get<LoginCubit>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await loginCubit.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginCubit,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSize.s40),
                  const BrandLogo(),
                  const SizedBox(height: AppSize.s32),
                  const WelcomeHeader(),
                  const SizedBox(height: AppSize.s32),
                  EmailField(controller: _emailController),
                  const SizedBox(height: AppSize.s16),
                  PasswordField(
                    controller: _passwordController,
                    obscure: _obscurePassword,
                    onToggleObscure: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),

                  const SizedBox(height: AppSize.s12),
                  RememberForgotRow(
                    onPressed: () {},
                    rememberMe: _rememberMe,
                    onRememberChanged: (v) =>
                        setState(() => _rememberMe = v ?? false),
                  ),
                  const SizedBox(height: AppSize.s32),
                  BlocListener<LoginCubit, LoginState>(
                    listener: (context, state) {
                      state.maybeWhen(
                        orElse: () {},
                        loading: () => setState(() => _isLoading = true),
                        success: (data) {
                          setState(() => _isLoading = false);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم تسجيل الدخول بنجاح'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // context.goNamed(RoutesManager.homeName);
                        },
                        failure: (error) {
                          setState(() => _isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('فشل تسجيل الدخول'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      );
                    },
                    child: SubmitButton(
                      onPressed: _submit,
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(height: AppSize.s20),
                  SignUpRow(
                    onTap: () =>
                        context.pushNamed(RoutesManager.createCenterName),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
