import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/generated/l10n.dart' as lang;

/// A reusable widget for displaying error states with an optional retry button.
///
/// Use this widget when content fails to load and you want to show a user-friendly
/// error message with the option to retry the operation.
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    this.message,
    this.onRetry,
    this.icon,
    this.compact = false,
    super.key,
  });

  /// The error message to display. Defaults to "Something went wrong".
  final String? message;

  /// Optional callback for retry button. If null, no retry button is shown.
  final VoidCallback? onRetry;

  /// Optional custom icon. Defaults to error_outline icon.
  final IconData? icon;

  /// If true, displays a compact version suitable for grid items.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact();
    }
    return _buildFull(context);
  }

  Widget _buildCompact() {
    return ColoredBox(
      color: kGreyPlaceholder,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              color: const Color(0xff979a9b),
              size: 24,
            ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: GestureDetector(
                  onTap: onRetry,
                  child: const Icon(
                    Icons.refresh,
                    color: kPrimaryColor,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFull(BuildContext context) {
    final l10n = lang.S.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              color: const Color(0xff979a9b),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? l10n.something_went_wrong,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Color(0xff979a9b),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.try_again,
                    textScaler: TextScaler.noScaling,
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      color: kWhiteColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A simple inline error widget for use in photo grids and cards.
/// This is a compact version that just shows an error icon.
class PhotoErrorWidget extends StatelessWidget {
  const PhotoErrorWidget({
    this.onRetry,
    super.key,
  });

  /// Optional callback for retry. If provided, shows a refresh icon.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: kGreyPlaceholder,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.broken_image_outlined,
              color: Color(0xff979a9b),
              size: 32,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: kPrimaryColor,
                    size: 18,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
