import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/model/pic.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/database_manager.dart';

class ListOfTags extends StatelessWidget {
  final Pic picInfo;
  final bool activeTags;
  final bool fullScreen;

  const ListOfTags({
    @required this.picInfo,
    @required this.activeTags,
    this.fullScreen = false,
  });

  Widget _buildTagsWidget() {
    if (picInfo.tags.isEmpty && activeTags) {
      return Container();
    }

    List<Widget> tagsWidgets = [];
    print('Tags: ${picInfo.tags}');

    for (var tag in picInfo.tags) {
      tagsWidgets.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//          padding: const EdgeInsets.symmetric(horizontal: 16.0),
//          height: 30.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19.0),
            gradient: activeTags ? kSecondaryGradient : kYellowGradient,
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontFamily: 'Lato',
              color: kWhiteColor,
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
        ),
      );
    }

    if (activeTags == false) {
      tagsWidgets.add(CupertinoButton(
        padding: const EdgeInsets.all(0.0),
        minSize: 0,
        onPressed: () {
          if (fullScreen) {
            print('in full screen mode!');
            return;
          }
          DatabaseManager.instance.switchEditingTags();
        },
        child: Container(
          height: 30.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Add Tag",
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xffff6666),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.4099999964237213,
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Image.asset('lib/images/plusredico.png'),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19.0),
            border: Border.all(color: kSecondaryColor, width: 1.0),
          ),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (activeTags)
          Text(
            "Tags ativas",
            style: TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff979a9b),
              fontSize: 12,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
        SizedBox(
          height: 8.0,
        ),
        Wrap(
          spacing: 5.0,
          runSpacing: 5.0,
          children: tagsWidgets,
        ),
        SizedBox(
          height: 16.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTagsWidget();
  }
}
