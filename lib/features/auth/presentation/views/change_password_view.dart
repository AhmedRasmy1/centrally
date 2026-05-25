import 'package:flutter/material.dart';
import 'package:centrally/core/di/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:centrally/features/auth/presentation/widgets/submit_button.dart';
import 'package:centrally/features/auth/presentation/widgets/password_field.dart';
import 'package:centrally/features/auth/presentation/view_models/change_password_view_model/change_password_cubit.dart';
import 'package:centrally/core/constants/strings_manager.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  late ChangePasswordCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt.get<ChangePasswordCubit>();
  }

  @override
  void dispose() {
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _cubit.changePassword(
        oldPassword: _oldPassCtrl.text.trim(),
        newPassword: _newPassCtrl.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: AppBar(
          backgroundColor: ColorManager.background,
          elevation: 0,
          title: Text(StringsManager.changePasswordTitle.tr()),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSize.s32),

                  PasswordField(
                    controller: _oldPassCtrl,
                    obscure: _obscureOld,
                    hintText: 'كلمة المرور الحالية',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'برجاء إدخال كلمة المرور الحالية';
                      }
                      return null;
                    },
                    onToggleObscure: () =>
                        setState(() => _obscureOld = !_obscureOld),
                  ),

                  const SizedBox(height: AppSize.s16),

                  PasswordField(
                    controller: _newPassCtrl,
                    obscure: _obscureNew,
                    hintText:
                        'كلمة المرور الجديدة', // تقدر تبدلها بـ StringsManager
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'برجاء إدخال كلمة المرور الجديدة';
                      }
                      if (value.length < 6) {
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      }
                      return null;
                    },
                    onToggleObscure: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),

                  const SizedBox(height: AppSize.s16),

                  PasswordField(
                    controller: _confirmPassCtrl,
                    obscure: _obscureConfirm,
                    hintText:
                        'تأكيد كلمة المرور الجديدة', // تقدر تبدلها بـ StringsManager
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'برجاء تأكيد كلمة المرور';
                      }
                      if (value != _newPassCtrl.text) {
                        return 'كلمات المرور غير متطابقة!'; // اللوجيك الأهم هنا
                      }
                      return null;
                    },
                    onToggleObscure: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),

                  const SizedBox(height: AppSize.s32),

                  BlocListener<ChangePasswordCubit, ChangePasswordState>(
                    listener: (context, state) {
                      state.maybeWhen(
                        orElse: () {},
                        loading: () => setState(() => _isLoading = true),
                        success: (_) {
                          setState(() => _isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                StringsManager.changePasswordSuccess.tr(),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // تفريغ الحقول بعد النجاح
                          _oldPassCtrl.clear();
                          _newPassCtrl.clear();
                          _confirmPassCtrl.clear();
                          _formKey.currentState?.reset();
                        },
                        failure: (errMessage) {
                          setState(() => _isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errMessage),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
