// lib/features/auth/screens/verify_email_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../shared/widgets/loading_button.dart';
import '../../../core/utils/snackbar_utils.dart';
import 'dart:async';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  int _resendCountdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() {
      _resendCountdown = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  Future<void> _verifyEmail() async {
    if (_codeController.text.isEmpty) {
      SnackbarUtils.showErrorSnackbar(
        context,
        'Please enter the verification code',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .verifyEmail(widget.email, _codeController.text.trim());

      if (mounted) {
        SnackbarUtils.showSuccessSnackbar(
          context,
          'Email verified successfully. You can now login.',
        );

        // Navigate to login screen
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

  Future<void> _resendCode() async {
    if (_resendCountdown > 0) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Call resend verification code API
      // For now, just simulate a delay
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        SnackbarUtils.showSuccessSnackbar(
          context,
          'Verification code resent to ${widget.email}',
        );

        _startResendTimer();
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
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            const Icon(Icons.mark_email_read, size: 80, color: Colors.blue),

            const SizedBox(height: 24),

            Text(
              'Verify Your Email',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Text(
              'We have sent a verification code to:\n${widget.email}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 32),

            // Verification code field
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Verification Code',
                hintText: 'Enter the code sent to your email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // Verify button
            SizedBox(
              width: double.infinity,
              child: LoadingButton(
                onPressed: _verifyEmail,
                isLoading: _isLoading,
                text: 'Verify Email',
              ),
            ),

            const SizedBox(height: 24),

            // Resend code
            TextButton.icon(
              onPressed: _resendCountdown > 0 ? null : _resendCode,
              icon: const Icon(Icons.refresh),
              label: Text(
                _resendCountdown > 0
                    ? 'Resend Code in $_resendCountdown seconds'
                    : 'Resend Code',
              ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
