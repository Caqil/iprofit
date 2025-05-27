// lib/features/auth/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../shared/widgets/loading_button.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/services/device_service.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _referralCodeController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_termsAccepted) {
      SnackbarUtils.showErrorSnackbar(
        context,
        'You must accept the terms and conditions',
      );
      return;
    }

    try {
      await ref
          .read(authProvider.notifier)
          .register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
            _phoneController.text.trim(),
            _referralCodeController.text.isEmpty
                ? null
                : _referralCodeController.text.trim(),
          );

      if (mounted) {
        SnackbarUtils.showSuccessSnackbar(
          context,
          'Registration successful. Please verify your email.',
        );

        // Navigate to verify email screen
        context.push(
          '/verify-email',
          extra: {'email': _emailController.text.trim()},
        );
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils.showErrorSnackbar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AsyncLoading;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Logo and App Name
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.trending_up,
                        color: theme.colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Investment Pro',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Title
                Text(
                  'Create Account',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Join us and start your investment journey',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),

                const SizedBox(height: 40),

                // Name field
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  icon: Icons.person_outline,
                  validator: Validators.validateName,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                ),

                const SizedBox(height: 16),

                // Email field
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 16),

                // Phone field
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 16),

                // Password field
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock_outlined,
                  obscureText: _obscurePassword,
                  validator: Validators.validatePassword,
                  textInputAction: TextInputAction.next,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Confirm password field
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  icon: Icons.lock_outlined,
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Referral code field (optional)
                _buildTextField(
                  controller: _referralCodeController,
                  label: 'Referral Code (Optional)',
                  hint: 'Enter referral code if you have one',
                  icon: Icons.group_outlined,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 24),

                // Terms and conditions checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value!;
                        });
                      },
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return theme.colorScheme.primary;
                        }
                        return theme.colorScheme.outline;
                      }),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _termsAccepted = !_termsAccepted;
                          });
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'I agree to the ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.7,
                              ),
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Register button
                SizedBox(
                  width: double.infinity,
                  child: LoadingButton(
                    onPressed: _register,
                    isLoading: isLoading,
                    text: 'Register',
                  ),
                ),

                const SizedBox(height: 16),

                // Login link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextInputAction? textInputAction,
    Widget? suffixIcon,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              icon,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
