import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database_manager.dart';

enum TagStyle {
  MultiColored,
  RedFilled,
  GrayOutlined,
}

class TagsList extends StatelessWidget {
  final List<String> tags;
  final TextEditingController textEditingController;
  final bool addTagField;
  final String title;
  final TagStyle tagStyle;
  final Function onSubmitted;
  final Function onChanged;
//  final bool

  const TagsList({
    @required this.tags,
    this.tagStyle = TagStyle.MultiColored,
    this.textEditingController,
    this.addTagField = false,
    this.onSubmitted,
    this.onChanged,
    this.title,
  });

  Widget _buildTagsWidget() {
//    if (picInfo != null) {
//      if (picInfo.tags.isEmpty && activeTags) {
//        return Container();
//      }
//    }

//    BoxDecoration(
//      borderRadius: BorderRadius.circular(19.0),
//      gradient: kSecondaryGradient,
//    ),

    List<Widget> tagsWidgets = [];
    print('Tags: $tags');

    for (var tag in tags) {
      tagsWidgets.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: kGrayBoxDecoration,
          child: Text(
            tag,
            style: kGrayTextStyle,
          ),
        ),
      );
    }

    if (addTagField) {
      tagsWidgets.add(
        Container(
          margin: const EdgeInsets.only(top: 5.0),
          height: 30.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFF1F3F5),
            border: Border.all(color: kLightGrayColor, width: 1.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
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
              contentPadding: const EdgeInsets.only(right: 2.0),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
              border: OutlineInputBorder(borderSide: BorderSide.none),
              prefixIcon: Image.asset('lib/images/smalladdtag.png'),
              prefixIconConstraints: BoxConstraints.tight(Size(30.0, 30.0)),
              hintText: 'Add tags',
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
    return _buildTagsWidget();
  }
}
