import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/stores/tags_store.dart';

class CustomisedTagsList extends StatefulWidget {
  final dynamic tags;
  final dynamic selectedTags;
  final int maxLength;
  final TextEditingController textEditingController;
  final FocusNode textFocusNode;
  final String title;
  final Function onTap;
  final Function onDoubleTap;
  final Function onSubmitted;
  final Function showEditTagModal;

  const CustomisedTagsList({
    @required this.tags,
    @required this.selectedTags,
    this.maxLength = 12,
    this.textEditingController,
    this.textFocusNode,
    @required this.onTap,
    @required this.onDoubleTap,
    this.onSubmitted,
    this.title,
    @required this.showEditTagModal,
  });

  @override
  _CustomisedTagsListState createState() => _CustomisedTagsListState();
}

class _CustomisedTagsListState extends State<CustomisedTagsList> {
  int showSwiperInIndex;
  String tagBeingPanned;
  bool swipedRightDirection = false;

  Widget _buildTagsWidget(BuildContext context, List<TagsStore> tags) {
    List<Widget> tagsWidgets = [];
    //print('Tags in CustomisedTagsList: ${tags}');

    if (tags.isEmpty) {
      tagsWidgets.add(
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
        ),
      );
    }

    for (int i = 0; i < tags.length; i++) {
      if (widget.maxLength != null && i >= widget.maxLength) {
        //break;
      }
      TagsStore tag = tags[i];
      var isColorFull = widget.selectedTags.contains(tag);

      tagsWidgets.add(
        GestureDetector(
          /* onTap: () {
            Vibrate.feedback(FeedbackType.success);
            DatabaseManager.instance.selectedTagKey = tag.id;
            widget.onTap(tag.id, tag.name);
          }, */
          onDoubleTap: () {
            Vibrate.feedback(FeedbackType.success);
            DatabaseManager.instance.selectedTagKey = tag.id;
            widget.onDoubleTap();
          },
          onLongPress: () {
            DatabaseManager.instance.selectedTagKey = tag.id;
            widget.showEditTagModal();
          },
          /* onPanStart: (details) {
            //print('Started pan on tag: ${tag.id}');
            tagBeingPanned = tag.id;
          }, */
          /* onPanUpdate: (details) {
            if (tagBeingPanned != tag.id) {
              return;
            }

            if (details.delta.dy < 0) {
              // swiping in right direction
              //print(details.delta.dy);
              swipedRightDirection = true;
            }
          },
          onPanEnd: (details) {
            if (swipedRightDirection) {
              showSwiperInIndex = null;
              Vibrate.feedback(FeedbackType.success);
              DatabaseManager.instance.selectedTagKey = tag.id;
              widget.onPanEnd();
              swipedRightDirection = false;
            }
          }, */
          child: CupertinoButton(
            minSize: 0,
            padding: const EdgeInsets.all(0),
            onPressed: () {
              /* if (widget.shouldChangeToSwipeMode) {
                setState(() {
                  if (showSwiperInIndex == null) {
                    showSwiperInIndex =
                        tags.indexWhere((element) => element.id == tag.id);
                  } else {
                    showSwiperInIndex = null;
                  }
                });
              } */

              Vibrate.feedback(FeedbackType.success);
              DatabaseManager.instance.selectedTagKey = tag.id;
              widget.onTap(tag.id, tag.name);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: isColorFull
                  ? BoxDecoration(
                      gradient: getGradient(i % 4),
                      borderRadius: BorderRadius.circular(19))
                  : kGrayBoxDecoration,
              child: Text(
                tag.name,
                textScaleFactor: 1.0,
                style: (isColorFull ? kWhiteTextStyle : kGrayTextStyle)
                    .copyWith(fontSize: 14),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.title,
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
          children: tagsWidgets,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.tags is Future
        ? FutureBuilder<List<TagsStore>>(
            future: widget.tags,
            builder: (c, AsyncSnapshot<List<TagsStore>> snapshot) {
              return snapshot.hasData
                  ? _buildTagsWidget(context, snapshot.data)
                  : Container();
            })
        : _buildTagsWidget(context, widget.tags);
  }
}

LinearGradient getGradient(int num) {
  switch (num) {
    case 0:
      {
        return kPrimaryGradient;
      }
      break;
    case 1:
      {
        return kSecondaryGradient;
      }
      break;
    case 2:
      {
        return kPinkGradient;
      }
      break;
    default:
      {
        return kCardYellowGradient;
      }
      break;
  }
}
