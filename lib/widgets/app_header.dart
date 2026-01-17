import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picpics/screens/settings_screen.dart';

/// Reusable app header widget with logo and settings button.
/// Used across all main tabs for consistent appearance.
///
/// If [leading] is provided, it replaces the default logo.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.leading,
  });

  /// Optional widget to display instead of the logo.
  /// Useful for search fields or other custom content.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 44,
        child: Row(
          children: <Widget>[
            Expanded(
              child: leading ??
                  Image.asset(
                    'lib/images/picpicssmallred.png',
                    alignment: Alignment.centerLeft,
                  ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              child: Image.asset('lib/images/settings.png'),
            ),
          ],
        ),
      ),
    );
  }
}
