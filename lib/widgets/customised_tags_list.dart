import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/model/tag_model.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:picPics/stores/language_controller.dart';

import 'package:picPics/stores/private_photos_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/show_edit_label_dialog.dart';

typedef OnTap = Function(
    String tagId, String tagName, int counter, DateTime lastUsedAt);

// ignore: must_be_immutable
class CustomisedTagsList extends StatelessWidget {
  final List<String> tagsKeyList;
  final Map<String, TagModel> selectedTags;
  int? maxLength;
  final String? title;
  final OnTap? onTap;
  final Function? onDoubleTap;

  CustomisedTagsList({
    required this.tagsKeyList,
    required this.selectedTags,
    this.maxLength,
    required this.onTap,
    required this.onDoubleTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    tagsKeyList.removeWhere((element) =>
        PrivatePhotosController.to.showPrivate.value == false &&
        element == kSecretTagKey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title!,
              textScaleFactor: 1.0,
              style: TextStyle(
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
          direction: Axis.horizontal,
          spacing: 5.0,
          runSpacing: 5.0,
          runAlignment: WrapAlignment.start,
          children: (tagsKeyList.isEmpty)
              ? [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Obx(
                      () => Text(
                        LangControl.to.S.value.no_tags_found,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: Color(0xff979a9b),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.4099999964237213,
                        ),
                      ),
                    ),
                  )
                ]
              : List.generate(
                  maxLength != null
                      ? tagsKeyList.length.clamp(0, maxLength!)
                      : tagsKeyList.length,
                  (index) => _buildItem(index),
                ),
        ),
      ],
    );
  }

  Widget _buildItem(int index) {
    var tag = TagsController.to.allTags[tagsKeyList[index]]!.value;
    var isColorFull = selectedTags[tag.key] != null;
    return GestureDetector(
      onTap: () {
        Vibrate.feedback(FeedbackType.success);
        /* DatabaseManager.instance.selectedTagKey = tag.key; */
        onTap?.call(tag.key, tag.title, tag.count, tag.time);
      },
      onDoubleTap: () {
        Vibrate.feedback(FeedbackType.success);
        /* DatabaseManager.instance.selectedTagKey = tag.key; */
        onDoubleTap?.call();
      },
      onLongPress: () {
        /* DatabaseManager.instance.selectedTagKey = tag.key; */
        showEditTagModal(tag.key);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: isColorFull
            ? BoxDecoration(
                gradient: getGradient(index % 4),
                borderRadius: BorderRadius.circular(19))
            : kGrayBoxDecoration,
        child: Text(
          tag.title,
          textScaleFactor: 1.0,
          style: (isColorFull ? kWhiteTextStyle : kGrayTextStyle)
              .copyWith(fontSize: 14),
        ),
      ),
    );
  }
}
