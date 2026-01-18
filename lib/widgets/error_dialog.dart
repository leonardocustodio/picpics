import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/generated/l10n.dart' as lang;

/// A dialog for displaying error messages to the user.
///
/// Use this for showing errors from failed operations with an optional
/// retry callback. Follows the app's design language.
class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    required this.message,
    this.title,
    this.onRetry,
    this.onDismiss,
    this.retryButtonText,
    this.dismissButtonText,
    super.key,
  });

  /// The error message to display
  final String message;

  /// Optional title for the dialog. Defaults to "Error".
  final String? title;

  /// Optional callback for retry button. If null, no retry button is shown.
  final VoidCallback? onRetry;

  /// Callback when dialog is dismissed. Closes the dialog if not provided.
  final VoidCallback? onDismiss;

  /// Custom text for the retry button. Defaults to "Try Again".
  final String? retryButtonText;

  /// Custom text for the dismiss button. Defaults to "OK".
  final String? dismissButtonText;

  /// Shows the error dialog using the provided context.
  static Future<void> show(
    BuildContext context, {
    required String message,
    String? title,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
    String? retryButtonText,
    String? dismissButtonText,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ErrorDialog(
        message: message,
        title: title,
        onRetry: onRetry,
        onDismiss: onDismiss ?? () => Navigator.of(context).pop(),
        retryButtonText: retryButtonText,
        dismissButtonText: dismissButtonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = lang.S.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFFF1F3F5),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(14),
            bottom: Radius.circular(19),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Header with close button
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 8, top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title ?? l10n.error,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        color: kWarningColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: onDismiss ?? () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xff979a9b),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff606566),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Dismiss/OK button
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: onDismiss ?? () => Navigator.of(context).pop(),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xffe2e4e5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            dismissButtonText ?? l10n.ok,
                            textScaler: TextScaler.noScaling,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xff606566),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Retry button (if provided)
                  if (onRetry != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.of(context).pop();
                          onRetry?.call();
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              retryButtonText ?? l10n.try_again,
                              textScaler: TextScaler.noScaling,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                color: kWhiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
