import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database_manager.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:picPics/generated/l10n.dart';

enum TagStyle {
  MultiColored,
  RedFilled,
  GrayOutlined,
}

class TagsList extends StatelessWidget {
  final List<String> tagsKeys;
  final TextEditingController textEditingController;
  final bool addTagField;
  final Function addTagButton;
  final bool addButtonVisible;
  final String title;
  final TagStyle tagStyle;
  final Function onTap;
  final Function onDoubleTap;
  final Function onSubmitted;
  final Function onChanged;
  final Function showEditTagModal;

  const TagsList({
    @required this.tagsKeys,
    this.tagStyle = TagStyle.MultiColored,
    this.textEditingController,
    this.addTagField = false,
    this.addButtonVisible = true,
    this.addTagButton,
    @required this.onTap,
    @required this.onDoubleTap,
    this.onSubmitted,
    this.onChanged,
    this.title,
    @required this.showEditTagModal,
  });

  Widget _buildTagsWidget(BuildContext context) {
    if (tagsKeys == null) {
      return Container();
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

    List<Widget> tagsWidgets = [];
    print('Tags in TagsList: $tagsKeys');

    var index = 0;

    for (var tagKey in tagsKeys) {
      var mod = index % 4;
      index++;

      String tagName = DatabaseManager.instance.getTagName(tagKey);

      tagsWidgets.add(
        GestureDetector(
          onTap: () {
            Vibrate.feedback(FeedbackType.success);
            DatabaseManager.instance.selectedTagKey = tagKey;
            onTap(tagName);
          },
          onDoubleTap: () {
            Vibrate.feedback(FeedbackType.success);
            DatabaseManager.instance.selectedTagKey = tagKey;
            onDoubleTap();
          },
          onLongPress: () {
            DatabaseManager.instance.selectedTagKey = tagKey;
            showEditTagModal();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: tagStyle == TagStyle.MultiColored
                ? BoxDecoration(
                    gradient: getGradient(mod),
                    borderRadius: BorderRadius.circular(19.0),
                  )
                : kGrayBoxDecoration,
            child: Text(
              tagName,
              textScaleFactor: 1.0,
              style: tagStyle == TagStyle.MultiColored ? kWhiteTextStyle : kGrayTextStyle,
            ),
          ),
        ),
      );
    }

    if (addTagButton != null) {
      tagsWidgets.add(CupertinoButton(
        minSize: 30,
        padding: const EdgeInsets.all(0),
        onPressed: addTagButton,
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

    if (addTagField) {
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
                  controller: textEditingController,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
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
              if (addButtonVisible)
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  minSize: 30,
                  onPressed: () {
                    onSubmitted(textEditingController.text);
                  },
                  child: Container(
                    child: Image.asset('lib/images/plusaddtagico.png'),
                  ),
                ),
            ],
          ),
        ),

//        CupertinoButton(
//          padding: const EdgeInsets.all(0.0),
//          minSize: 0,
//          onPressed: () {
////          if (fullScreen) {
////            print('in full screen mode!');
////            return;
////          }
////            DatabaseManager.instance.switchEditingTags();
//          },
//          child: Container(
//            height: 30.0,
//            child: Row(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                Text(
//                  "Add Tag",
//                  style: TextStyle(
//                    fontFamily: 'Lato',
//                    color: Color(0xffff6666),
//                    fontSize: 12,
//                    fontWeight: FontWeight.w700,
//                    fontStyle: FontStyle.normal,
//                    letterSpacing: -0.4099999964237213,
//                  ),
//                ),
//                SizedBox(
//                  width: 8.0,
//                ),
//                Image.asset('lib/images/plusredico.png'),
//              ],
//            ),
//            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
//            decoration: BoxDecoration(
//              borderRadius: BorderRadius.circular(19.0),
//              border: Border.all(color: kSecondaryColor, width: 1.0),
//            ),
//          ),
//        ),
      );
    }

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
