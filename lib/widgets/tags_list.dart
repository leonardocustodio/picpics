import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/private_photos_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/enum.dart';
import 'package:picpics/utils/helpers.dart';
import 'package:picpics/utils/show_edit_label_dialog.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

typedef OnString = void Function(String);
typedef OnEmptyTap = void Function();

class TagsList extends ConsumerStatefulWidget {
  const TagsList({
    required this.tagsKeyList,
    required this.tagStyle,
    this.onTap,
    this.onDoubleTap,
    this.onPanEnd,
    this.textEditingController,
    this.textFocusNode,
    this.addTagField = false,
    this.addButtonVisible = true,
    this.addTagButton,
    this.onSubmitted,
    this.onChanged,
    this.title,
    this.aiButtonTitle,
    this.onAiButtonTap,
    this.shouldChangeToSwipeMode = false,
    super.key,
  });

  final List<String> tagsKeyList;
  final TextEditingController? textEditingController;
  final FocusNode? textFocusNode;
  final bool addTagField;
  final void Function()? addTagButton;
  final bool addButtonVisible;
  final String? title;
  final TagStyle tagStyle;
  final OnString? onTap;
  final OnString? onDoubleTap;
  final OnString? onPanEnd;
  final OnString? onSubmitted;
  final OnString? onChanged;
  final String? aiButtonTitle;
  final void Function()? onAiButtonTap;
  final bool shouldChangeToSwipeMode;

  @override
  ConsumerState<TagsList> createState() => _TagsListState();
}

class _TagsListState extends ConsumerState<TagsList> {
  int? showSwiperInIndex;
  String? tagBeingPanned;
  bool swipedRightDirection = false;

  Widget _buildTagsWidget(BuildContext context, List<String> tags) {
    final tagsWidgets = <Widget>[];
    final tagsState = ref.watch(tagsProvider);
    final privatePhotosState = ref.watch(privatePhotosProvider);
    final s = ref.watch(sProvider);

    // Removed verbose log to prevent log spam

    if (tags.isEmpty && widget.tagStyle == TagStyle.grayOutlined) {
      tagsWidgets.add(
        Container(
          padding: const EdgeInsets.only(top: 10, left: 18, bottom: 8),
          child: Text(
            s.no_tags_found,
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff979a9b),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
        ),
      );
    }

    for (var i = 0; i < tags.length; i++) {
      final tagKey = tags[i];

      /// We'll have to avoid the tags whose tag name is null and
      /// also if the tags is [kSecretTagKey] and showPrivate is False
      if (tagsState.allTags[tagKey]?.title == null ||
          (!privatePhotosState.showPrivate && tagKey == kSecretTagKey)) {
        continue;
      }

      tagsWidgets.add(
        GestureDetector(
          onTap: () {
            if (widget.shouldChangeToSwipeMode) {
              setState(() {
                if (showSwiperInIndex == null) {
                  showSwiperInIndex = tags.indexWhere((element) => element == tagKey);
                } else {
                  showSwiperInIndex = null;
                }
              });
            }
            unawaited(HapticFeedback.lightImpact());
            widget.onTap?.call(tagKey);
          },
          onDoubleTap: () {
            unawaited(HapticFeedback.lightImpact());
            widget.onDoubleTap?.call(tagKey);
          },
          onLongPress: () {
            unawaited(showEditTagModal(tagKey, context, ref));
          },
          onPanStart: (details) {
            AppLogger.d('Started pan on tag: $tagKey');
            tagBeingPanned = tagKey;
          },
          onPanUpdate: (details) {
            if (tagBeingPanned != tagKey) {
              return;
            }

            if (details.delta.dy < 0) {
              // swiping in right direction
              AppLogger.d(details.delta.dy);
              swipedRightDirection = true;
            }
          },
          onPanEnd: (details) {
            if (swipedRightDirection) {
              showSwiperInIndex = null;
              unawaited(HapticFeedback.lightImpact());
              widget.onPanEnd?.call(tagKey);
              swipedRightDirection = false;
            }
          },
          child: DecoratedBox(
            decoration: widget.tagStyle == TagStyle.multiColored
                ? BoxDecoration(
                    gradient: getGradient(i % 4),
                    borderRadius: BorderRadius.circular(19),
                  )
                : kGrayBoxDecoration,
            child: showSwiperInIndex != i
                ? tagKey != kSecretTagKey
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Text(
                          tagsState.allTags[tagKey]?.title ?? '',
                          textScaler: TextScaler.noScaling,
                          style: widget.tagStyle == TagStyle.multiColored ? kWhiteTextStyle : kGrayTextStyle,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.2,
                          horizontal: 19,
                        ),
                        child: widget.tagStyle == TagStyle.multiColored
                            ? Image.asset('lib/images/locktagwhite.png')
                            : Image.asset('lib/images/locktaggray.png'),
                      )
                : CustomAnimationBuilder<double>(
                    control: Control.loop,
                    tween: 0.0.tweenTo(600),
                    duration: 7.seconds,
                    builder: (context, value, _) {
                      var firstOpct = 0.0;
                      var secondOpct = 0.0;
                      var thirdOpct = 0.0;

                      if (value <= 300) {
                        firstOpct = 0.0;
                        thirdOpct = 0.0;
                        secondOpct = 1.0;

                        if (value <= 20) {
                          secondOpct = value / 20.0;
                        } else if (value <= 280) {
                          secondOpct = 1.0;
                        } else {
                          secondOpct = 1.0 - ((value - 280.0) / 20.0);
                        }
                      } else if (value <= 500) {
                        firstOpct = 0.0;
                        secondOpct = 0.0;

                        if (value <= 380) {
                          thirdOpct = (value - 300.0) / 80.0;
                        } else if (value <= 420) {
                          thirdOpct = 1.0;
                        } else {
                          thirdOpct = 1.0 - ((value - 420.0) / 80);
                        }
                      } else if (value <= 700) {
                        secondOpct = 0.0;
                        thirdOpct = 0.0;

                        if (value <= 580) {
                          firstOpct = (value - 500.0) / 80.0;
                        } else if (value <= 620) {
                          firstOpct = 1.0;
                        } else {
                          firstOpct = 1.0 - ((value - 620) / 80.0);
                        }
                      }

                      return Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Opacity(
                            opacity: firstOpct,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: Text(
                                tagsState.allTags[tagKey]?.title ?? '',
                                textScaler: TextScaler.noScaling,
                                style: widget.tagStyle == TagStyle.multiColored ? kWhiteTextStyle : kGrayTextStyle,
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: secondOpct,
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: Transform.rotate(
                                angle: pi / 2,
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: kWhiteColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: thirdOpct,
                            child: Text(
                              s.delete,
                              textScaler: TextScaler.noScaling,
                              style: widget.tagStyle == TagStyle.multiColored ? kWhiteTextStyle : kGrayTextStyle,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ),
      );
    }

    if (widget.addTagButton != null) {
      tagsWidgets.add(
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: widget.addTagButton,
          minimumSize: const Size(30, 30),
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F5),
              border: Border.all(color: kLightGrayColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('lib/images/smalladdtag.png'),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  s.add_tag,
                  textScaler: TextScaler.noScaling,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    color: kGrayColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.4099999964237213,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (widget.addTagField) {
      tagsWidgets.add(
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F5),
                    border: Border.all(color: kLightGrayColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: <Widget>[
                      Image.asset('lib/images/smalladdtag.png'),
                      Expanded(
                        child: TextField(
                          controller: widget.textEditingController,
                          focusNode: widget.textFocusNode,
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                          keyboardType: TextInputType.text,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xff606566),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.4099999964237213,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 6),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: s.add_tags,
                            hintStyle: const TextStyle(
                              fontFamily: 'Lato',
                              color: kGrayColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.4099999964237213,
                            ),
                          ),
                        ),
                      ),
                      if (widget.addButtonVisible)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (widget.onSubmitted != null) {
                              widget.onSubmitted!(
                                widget.textEditingController!.text,
                              );
                            }
                          },
                          minimumSize: const Size(30, 30),
                          child: const Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (widget.onAiButtonTap != null)
                CupertinoButton(
                  padding: const EdgeInsets.only(left: 8),
                  onPressed: widget.onAiButtonTap,
                  child: Row(
                    children: [
                      Text(
                        widget.aiButtonTitle!,
                        textScaler: TextScaler.noScaling,
                        style: kGrayTextStyle.copyWith(fontSize: 15),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.title!,
              textScaler: TextScaler.noScaling,
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Color(0xff979a9b),
                fontSize: 14,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.4099999964237213,
              ),
            ),
          ),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: tagsWidgets,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTagsWidget(context, widget.tagsKeyList);
  }
}
