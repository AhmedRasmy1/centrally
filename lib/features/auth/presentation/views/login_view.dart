import 'package:centrally/core/router/routes_manager.dart';
import 'package:centrally/core/theme/color_manager.dart';
import 'package:centrally/core/theme/style_manager.dart';
import 'package:centrally/core/theme/values_manager.dart';
import 'package:centrally/core/utils/cached_data_shared_preferences.dart';
import 'package:centrally/core/widgets/brand_logo.dart';
import 'package:centrally/features/auth/presentation/widgets/email_field.dart';
import 'package:centrally/features/auth/presentation/widgets/password_field.dart';
import 'package:centrally/features/auth/presentation/widgets/remember_forgor_row.dart';
import 'package:centrally/features/auth/presentation/widgets/submit_button.dart';
import 'package:centrally/features/auth/presentation/widgets/welcome_header.dart';
import 'package:centrally/models/centerly_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  static final Uri _whatsAppUri = Uri.parse('https://wa.me/201000000000');
  static final Uri _phoneUri = Uri(scheme: 'tel', path: '+201000000000');

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'demo@centerly.app');
  final _passwordController = TextEditingController(text: 'password123');
  bool _rememberMe = true;
  bool _obscurePassword = true;
  bool _isLoading = false;
  UserRole _selectedRole = UserRole.teacher;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    await CacheService.setData(
      key: CacheConstants.userToken,
      value: 'fake-dev-token',
    );
    await CacheService.setData(
      key: CacheConstants.role,
      value: _selectedRole.name,
    );
    await CacheService.setData(
      key: CacheConstants.userEmail,
      value: _emailController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);
    context.goNamed(
      RoutesManager.homeName,
      queryParameters: {'role': _selectedRole.name},
    );
  }

  Future<void> _launchContact(Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened || !mounted) return;
  }

  void _showContactOptions() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppPadding.p24,
            AppPadding.p8,
            AppPadding.p24,
            AppPadding.p24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Contact Centerly', style: AppTextStyles.headlineSmall),
              const SizedBox(height: AppSize.s8),
              Text(
                'Use the same channel for new subscriptions or extra secretary seats.',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppSize.s20),
              FilledButton.icon(
                onPressed: () => _launchContact(_whatsAppUri),
                icon: const Icon(Icons.chat_outlined),
                label: const Text('WhatsApp'),
              ),
              const SizedBox(height: AppSize.s12),
              OutlinedButton.icon(
                onPressed: () => _launchContact(_phoneUri),
                icon: const Icon(Icons.call_outlined),
                label: const Text('Call support'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const SizedBox(height: AppSize.s24),
                _RoleSelector(
                  selectedRole: _selectedRole,
                  onChanged: (role) => setState(() => _selectedRole = role),
                ),
                const SizedBox(height: AppSize.s24),
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
                  onRememberChanged: (value) =>
                      setState(() => _rememberMe = value ?? false),
                ),
                const SizedBox(height: AppSize.s32),
                SubmitButton(onPressed: _submit, isLoading: _isLoading),
                const SizedBox(height: AppSize.s20),
                TextButton(
                  onPressed: _showContactOptions,
                  child: const Text('New to Centerly? Contact Us'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({required this.selectedRole, required this.onChanged});

  final UserRole selectedRole;
  final ValueChanged<UserRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<UserRole>(
      segments: const [
        ButtonSegment(
          value: UserRole.teacher,
          label: Text('Teacher'),
          icon: Icon(Icons.person_outline),
        ),
        ButtonSegment(
          value: UserRole.secretary,
          label: Text('Secretary'),
          icon: Icon(Icons.badge_outlined),
        ),
      ],
      selected: {selectedRole},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}
