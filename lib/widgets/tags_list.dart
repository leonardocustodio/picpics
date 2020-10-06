import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/managers/database_manager.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:picPics/stores/tags_store.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'dart:math';

enum TagStyle {
  MultiColored,
  RedFilled,
  GrayOutlined,
}

class TagsList extends StatefulWidget {
  final List<TagsStore> tags;
  final TextEditingController textEditingController;
  final FocusNode textFocusNode;
  final bool addTagField;
  final Function addTagButton;
  final bool addButtonVisible;
  final String title;
  final TagStyle tagStyle;
  final Function onTap;
  final Function onDoubleTap;
  final Function onPanEnd;
  final Function onSubmitted;
  final Function onChanged;
  final Function showEditTagModal;
  final bool shouldChangeToSwipeMode;

  const TagsList({
    @required this.tags,
    this.tagStyle = TagStyle.MultiColored,
    this.textEditingController,
    this.textFocusNode,
    this.addTagField = false,
    this.addButtonVisible = true,
    this.addTagButton,
    @required this.onTap,
    @required this.onDoubleTap,
    @required this.onPanEnd,
    this.onSubmitted,
    this.onChanged,
    this.title,
    @required this.showEditTagModal,
    this.shouldChangeToSwipeMode = false,
  });

  @override
  _TagsListState createState() => _TagsListState();
}

class _TagsListState extends State<TagsList> {
  int showSwiperInIndex;
  String tagBeingPanned;
  bool swipedRightDirection = false;

  Widget _buildTagsWidget(BuildContext context) {
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

    List<Widget> tagsWidgets = [];
    print('Tags in TagsList: ${widget.tags}');

    if (widget.tags.isEmpty && widget.tagStyle == TagStyle.GrayOutlined) {
      tagsWidgets.add(
        Container(
          padding: const EdgeInsets.only(top: 10.0, left: 18.0, bottom: 8.0),
          child: Text(
            S.of(context).no_tags_found,
            style: TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff979a9b),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < widget.tags.length; i++) {
      TagsStore tag = widget.tags[i];
      var mod = i % 4;

      tagsWidgets.add(
        GestureDetector(
          onDoubleTap: () {
            Vibrate.feedback(FeedbackType.success);
            DatabaseManager.instance.selectedTagKey = tag.id;
            widget.onDoubleTap();
          },
          onLongPress: () {
            DatabaseManager.instance.selectedTagKey = tag.id;
            widget.showEditTagModal();
          },
          onPanStart: (details) {
            print('Started pan on tag: ${tag.id}');
            tagBeingPanned = tag.id;
          },
          onPanUpdate: (details) {
            if (tagBeingPanned != tag.id) {
              return;
            }

            if (details.delta.dy < 0) {
              // swiping in right direction
              print(details.delta.dy);
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
          },
          child: CupertinoButton(
            minSize: 0,
            padding: const EdgeInsets.all(0),
            onPressed: () {
              if (widget.shouldChangeToSwipeMode) {
                setState(() {
                  if (showSwiperInIndex == null) {
                    showSwiperInIndex = widget.tags.indexWhere((element) => element.id == tag.id);
                  } else {
                    showSwiperInIndex = null;
                  }
                });
              }

              Vibrate.feedback(FeedbackType.success);
              DatabaseManager.instance.selectedTagKey = tag.id;
              widget.onTap(tag.id);
            },
            child: Container(
              decoration: widget.tagStyle == TagStyle.MultiColored
                  ? BoxDecoration(
                      gradient: getGradient(mod),
                      borderRadius: BorderRadius.circular(19.0),
                    )
                  : kGrayBoxDecoration,
              child: showSwiperInIndex != i
                  ? tag.id != kSecretTagKey
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            tag.name,
                            textScaleFactor: 1.0,
                            style: widget.tagStyle == TagStyle.MultiColored ? kWhiteTextStyle : kGrayTextStyle,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.2, horizontal: 19.0),
                          child:
                              widget.tagStyle == TagStyle.MultiColored ? Image.asset('lib/images/locktagwhite.png') : Image.asset('lib/images/locktaggray.png'),
                        )
                  : CustomAnimation<double>(
                      control: CustomAnimationControl.LOOP,
                      tween: 0.0.tweenTo(600.0),
                      duration: 7.seconds,
                      startPosition: 0.0,
                      builder: (context, child, value) {
                        double firstOpct = 0.0;
                        double secondOpct = 0.0;
                        double thirdOpct = 0.0;

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
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                child: Text(
                                  tag.name,
                                  textScaleFactor: 1.0,
                                  style: widget.tagStyle == TagStyle.MultiColored ? kWhiteTextStyle : kGrayTextStyle,
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: secondOpct,
                              child: Container(
                                height: 30.0,
                                width: 30.0,
                                child: Transform.rotate(
                                  angle: pi / 2,
                                  child: FlareActor(
                                    'lib/anims/swipe_arrow.flr',
                                    alignment: Alignment.center,
                                    fit: BoxFit.contain,
                                    animation: 'arrow_left',
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: thirdOpct,
                              child: Text(
                                S.of(context).delete,
                                textScaleFactor: 1.0,
                                style: widget.tagStyle == TagStyle.MultiColored ? kWhiteTextStyle : kGrayTextStyle,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ),
        ),
      );
    }

    if (widget.addTagButton != null) {
      tagsWidgets.add(CupertinoButton(
        minSize: 30,
        padding: const EdgeInsets.all(0),
        onPressed: widget.addTagButton,
        child: Container(
          height: 30.0,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Color(0xFFF1F3F5),
            border: Border.all(color: kLightGrayColor, width: 1.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset('lib/images/smalladdtag.png'),
              SizedBox(
                width: 4.0,
              ),
              Text(
                S.of(context).add_tag,
                textScaleFactor: 1.0,
                style: TextStyle(
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
      ));
    }

    if (widget.addTagField) {
      tagsWidgets.add(
        Container(
          margin: const EdgeInsets.only(top: 10.0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          height: 30.0,
          decoration: BoxDecoration(
            color: Color(0xFFF1F3F5),
            border: Border.all(color: kLightGrayColor, width: 1.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    color: Color(0xff606566),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    letterSpacing: -0.4099999964237213,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 6.0),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: S.of(context).add_tags,
                    hintStyle: TextStyle(
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
                  padding: const EdgeInsets.all(0),
                  minSize: 30,
                  onPressed: () {
                    widget.onSubmitted(widget.textEditingController.text);
                  },
                  child: Container(
                    child: Image.asset('lib/images/plusaddtagico.png'),
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
    return _buildTagsWidget(context);
  }
}
