import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/model/tag_model.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/tags_controller.dart';
import 'package:picpics/utils/helpers.dart';
import 'package:picpics/utils/show_edit_label_dialog.dart';

typedef OnTap = void Function(
    String tagId, String tagName, int counter, DateTime lastUsedAt,);

// ignore: must_be_immutable
class CustomisedTagsList extends StatelessWidget {

  CustomisedTagsList({
    required this.tagsKeyList, required this.selectedTags, required this.onTap, required this.onDoubleTap, super.key,
    this.maxLength,
    this.title,
  });
  final List<String> tagsKeyList;
  final Map<String, TagModel> selectedTags;
  int? maxLength;
  final String? title;
  final OnTap? onTap;
  final Function? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              title!,
              textScaler: const TextScaler.linear(1),
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
                    child: Obx(
                      () => Text(
                        LangControl.to.S.value.no_tags_found,
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
                  ),
                ]
              : List.generate(
                  maxLength != null
                      ? tagsKeyList.length.clamp(0, maxLength!)
                      : tagsKeyList.length,
                  _buildItem,
                ),
        ),
      ],
    );
  }

  Widget _buildItem(int index) {
    final tag = TagsController.to.allTags[tagsKeyList[index]]!.value;
    final isColorFull = selectedTags[tag.key] != null;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        /* DatabaseManager.instance.selectedTagKey = tag.key; */
        onTap?.call(tag.key, tag.title, tag.count, tag.time);
      },
      onDoubleTap: () {
        HapticFeedback.lightImpact();
        /* DatabaseManager.instance.selectedTagKey = tag.key; */
        onDoubleTap?.call();
      },
      onLongPress: () {
        /* DatabaseManager.instance.selectedTagKey = tag.key; */
        showEditTagModal(tag.key);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: isColorFull
            ? BoxDecoration(
                gradient: getGradient(index % 4),
                borderRadius: BorderRadius.circular(19),)
            : kGrayBoxDecoration,
        child: Text(
          tag.title,
          textScaler: const TextScaler.linear(1),
          style: (isColorFull ? kWhiteTextStyle : kGrayTextStyle)
              .copyWith(fontSize: 14),
        ),
      ),
    );
  }
}
