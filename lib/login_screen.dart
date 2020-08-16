import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picPics/analytics_manager.dart';
import 'package:picPics/constants.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/tabs_screen.dart';
import 'package:picPics/database_manager.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:hive/hive.dart';
import 'package:picPics/model/tag.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppStore appStore;

  void createDefaultTags(BuildContext context) async {
    var tagsBox = await Hive.openBox('tags');

    if (tagsBox.length == 0) {
      print('adding default tags...');
      Tag tag1 = Tag(S.of(context).family_tag, []);
      Tag tag2 = Tag(S.of(context).travel_tag, []);
      Tag tag3 = Tag(S.of(context).pets_tag, []);
      Tag tag4 = Tag(S.of(context).work_tag, []);
      Tag tag5 = Tag(S.of(context).selfies_tag, []);
      Tag tag6 = Tag(S.of(context).parties_tag, []);
      Tag tag7 = Tag(S.of(context).sports_tag, []);
      Tag tag8 = Tag(S.of(context).home_tag, []);
      Tag tag9 = Tag(S.of(context).foods_tag, []);
      Tag tag10 = Tag(S.of(context).screenshots_tag, []);

      Map<String, Tag> entries = {
        DatabaseManager.instance.encryptTag(S.of(context).family_tag): tag1,
        DatabaseManager.instance.encryptTag(S.of(context).travel_tag): tag2,
        DatabaseManager.instance.encryptTag(S.of(context).pets_tag): tag3,
        DatabaseManager.instance.encryptTag(S.of(context).work_tag): tag4,
        DatabaseManager.instance.encryptTag(S.of(context).selfies_tag): tag5,
        DatabaseManager.instance.encryptTag(S.of(context).parties_tag): tag6,
        DatabaseManager.instance.encryptTag(S.of(context).sports_tag): tag7,
        DatabaseManager.instance.encryptTag(S.of(context).home_tag): tag8,
        DatabaseManager.instance.encryptTag(S.of(context).foods_tag): tag9,
        DatabaseManager.instance.encryptTag(S.of(context).screenshots_tag): tag10,
      };
      tagsBox.putAll(entries);
    }
  }

  @override
  void initState() {
    super.initState();
    Analytics.sendCurrentScreen(Screen.login_screen);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: new BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(
                    flex: 2,
                  ),
                  Image.asset('lib/images/picpics_small.png'),
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    S.of(context).welcome,
                    textScaleFactor: 1.0,
                    style: kLoginDescriptionTextStyle,
                  ),
                  Text(
                    S.of(context).photos_always_organized,
                    textScaleFactor: 1.0,
                    style: kLoginDescriptionTextStyle,
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () async {
                      createDefaultTags(context);
                      await appStore.requestGalleryPermission();
                      Navigator.pushReplacementNamed(context, TabsScreen.id);
                    },
                    child: Container(
                      height: 44.0,
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          S.of(context).continue_string,
                          textScaleFactor: 1.0,
                          style: kLoginButtonTextStyle,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
