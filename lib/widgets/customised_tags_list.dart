import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/stores/tags_store.dart';

typedef OnTap = Function(
    String tagId, String tagName, int counter, DateTime lastUsedAt);

// ignore: must_be_immutable
class CustomisedTagsList extends StatelessWidget {
  final List<TagsStore> tags;
  final Map<String, TagsStore> selectedTags;
  int maxLength;
  final String title;
  final OnTap onTap;
  final Function onDoubleTap;
  final Function showEditTagModal;

  CustomisedTagsList({
    @required this.tags,
    @required this.selectedTags,
    this.maxLength,
    @required this.onTap,
    @required this.onDoubleTap,
    this.title,
    @required this.showEditTagModal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
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
          children: (tags.isEmpty)
              ? [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      S.of(context).no_tags_found,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Color(0xff979a9b),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        letterSpacing: -0.4099999964237213,
                      ),
                    ),
                  )
                ]
              : List.generate(
                  maxLength != null
                      ? tags.length.clamp(0, maxLength)
                      : tags.length,
                  (index) => _buildItem(index),
                ),
        ),
      ],
    );
  }

  Widget _buildItem(int index) {
    TagsStore tag = tags[index];
    var isColorFull = selectedTags[tag.id] != null;
    return GestureDetector(
      onTap: () {
        Vibrate.feedback(FeedbackType.success);
        DatabaseManager.instance.selectedTagKey = tag.id;
        if (onTap != null) onTap(tag.id, tag.name, tag.count, tag.time);
      },
      onDoubleTap: () {
        Vibrate.feedback(FeedbackType.success);
        DatabaseManager.instance.selectedTagKey = tag.id;
        if (onDoubleTap != null) onDoubleTap();
      },
      onLongPress: () {
        DatabaseManager.instance.selectedTagKey = tag.id;
        if (showEditTagModal != null) showEditTagModal();
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
          tag.name,
          textScaleFactor: 1.0,
          style: (isColorFull ? kWhiteTextStyle : kGrayTextStyle)
              .copyWith(fontSize: 14),
        ),
      ),
    );
  }
}

LinearGradient getGradient(int _) {
  switch (_) {
    case 0:
      return kPrimaryGradient;
    case 1:
      return kSecondaryGradient;
    case 2:
      return kPinkGradient;
    default:
      return kCardYellowGradient;
  }
}
