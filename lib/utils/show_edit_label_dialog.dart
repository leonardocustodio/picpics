import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/managers/database_manager.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/cupertino_input_dialog.dart';

Future<void> showEditTagModal(String tagKey, BuildContext context, WidgetRef ref) async {
  if (tagKey.trim().isNotEmpty && tagKey != kSecretTagKey) {
    final alertInputController = TextEditingController();
    final tagName = await DatabaseManager.instance.getTagName(tagKey);
    alertInputController.text = tagName ?? '';

    AppLogger.d('showModal');
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (_) {
        return Consumer(
          builder: (context, ref, child) {
            final s = ref.watch(sProvider);

            return CupertinoInputDialog(
              prefixImage: Image.asset('lib/images/smalladdtag.png'),
              alertInputController: alertInputController,
              title: s.edit_tag,
              destructiveButtonTitle: s.delete,
              onPressedDestructive: () {
                unawaited(ref.read(tagsProvider.notifier).deleteTagFromPic(tagKey: tagKey));
                Navigator.of(context).pop();
              },
              defaultButtonTitle: s.ok,
              onPressedDefault: () {
                AppLogger.d(
                  'Editing tag - Old name: $tagKey - New name: ${alertInputController.text}',
                );
                if (tagName != alertInputController.text) {
                  unawaited(ref.read(tagsProvider.notifier).editTagName(
                        oldTagKey: tagKey,
                        newName: alertInputController.text,
                      ),);
                }
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    );
  }
}
