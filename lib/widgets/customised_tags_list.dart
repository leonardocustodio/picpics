import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/model/tag_model.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/utils/helpers.dart';
import 'package:picpics/utils/show_edit_label_dialog.dart';

typedef OnTap = void Function(
  String tagId,
  String tagName,
  int counter,
  DateTime? lastUsedAt,
);

class CustomisedTagsList extends ConsumerWidget {
  const CustomisedTagsList({
    required this.tagsKeyList,
    required this.selectedTags,
    required this.onTap,
    required this.onDoubleTap,
    super.key,
    this.maxLength,
    this.title,
  });
  final List<String> tagsKeyList;
  final Map<String, TagModel> selectedTags;
  final int? maxLength;
  final String? title;
  final OnTap? onTap;
  final void Function()? onDoubleTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsState = ref.watch(tagsProvider);
    final s = ref.watch(sProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              title!,
              textScaler: TextScaler.noScaling,
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Color(0xff979a9b),
                fontSize: 12,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.4099999964237213,
              ),
            ),
          ),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: (tagsKeyList.isEmpty)
              ? [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      s.no_tags_found,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        color: Color(0xff979a9b),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.4099999964237213,
                      ),
                    ),
                  ),
                ]
              : List.generate(
                  maxLength != null ? tagsKeyList.length.clamp(0, maxLength!) : tagsKeyList.length,
                  (index) => _buildItem(context, ref, index, tagsState),
                ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, WidgetRef ref, int index, TagsState tagsState) {
    final tag = tagsState.allTags[tagsKeyList[index]]!;
    final isColorFull = selectedTags[tag.key] != null;
    return GestureDetector(
      onTap: () {
        unawaited(HapticFeedback.lightImpact());
        /* DatabaseManager.instance.selectedTagKey = tag.key; */
        onTap?.call(tag.key, tag.title, tag.count, tag.time);
      },
      onDoubleTap: () {
        unawaited(HapticFeedback.lightImpact());
        /* DatabaseManager.instance.selectedTagKey = tag.key; */
        onDoubleTap?.call();
      },
      onLongPress: () {
        /* DatabaseManager.instance.selectedTagKey = tag.key; */
        unawaited(showEditTagModal(tag.key, context, ref));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: isColorFull
            ? BoxDecoration(
                gradient: getGradient(index % 4),
                borderRadius: BorderRadius.circular(19),
              )
            : kGrayBoxDecoration,
        child: Text(
          tag.title,
          textScaler: TextScaler.noScaling,
          style: (isColorFull ? kWhiteTextStyle : kGrayTextStyle).copyWith(fontSize: 14),
        ),
      ),
    );
  }
}
