// lib/features/auth/screens/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../shared/widgets/loading_button.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/snackbar_utils.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .forgotPassword(_emailController.text.trim());

      if (mounted) {
        SnackbarUtils.showSuccessSnackbar(
          context,
          'Password reset instructions sent to your email',
        );

        // Navigate back to login screen
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showErrorSnackbar(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Icon(
                Icons.lock_reset,
                size: 80,
                color: theme.colorScheme.primary,
              ),

              const SizedBox(height: 24),

              Text(
                'Reset Your Password',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Enter your email address and we\'ll send you instructions to reset your password.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 32),

              // Email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),

              const SizedBox(height: 24),

              // Reset password button
              SizedBox(
                width: double.infinity,
                child: LoadingButton(
                  onPressed: _resetPassword,
                  isLoading: _isLoading,
                  text: 'Reset Password',
                ),
              ),

              const SizedBox(height: 24),

              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Back to Login',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
