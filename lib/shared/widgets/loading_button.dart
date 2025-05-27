// lib/shared/widgets/loading_button.dart
import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final Future<void> Function()? onPressed;
  final String text;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        disabledBackgroundColor: Theme.of(
          context,
        ).colorScheme.primary.withOpacity(0.6),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : Text(text),
    );
  }
}
