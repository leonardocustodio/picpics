import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/widgets/secret_switch.dart';

class TopBar extends StatelessWidget {
  final AppStore appStore;
  final GalleryStore galleryStore;
  final FocusNode searchFocusNode;
  final TextEditingController searchEditingController;
  final List<Widget> children;
  final bool showSecretSwitch;

  TopBar({
    @required this.appStore,
    @required this.galleryStore,
    @required this.showSecretSwitch,
    this.searchEditingController,
    this.searchFocusNode,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (searchEditingController != null)
                Expanded(
                  child: FocusScope(
                    child: Focus(
                      onFocusChange: (focus) {
                        print('hasFocus: ${searchFocusNode.hasFocus}');
                        if (searchFocusNode.hasFocus == true) {
                          galleryStore.setIsSearching(true);
                        } else if (searchFocusNode.hasFocus == false && galleryStore.searchingTagsKeys.length == 0) {
                          galleryStore.setIsSearching(false);
                        }
                      },
                      child: TextField(
                        controller: searchEditingController,
                        focusNode: searchFocusNode,
                        onChanged: (text) {
                          print('searching: $text');
                          galleryStore.searchResultsTags(text);
                        },
                        onSubmitted: (text) {
                          print('return');
                          searchEditingController.clear();
                          galleryStore.searchTagsResults.clear();
//                          DatabaseManager.instance.searchResults = null;
                        },
                        keyboardType: TextInputType.text,
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
                          prefixIcon: Image.asset('lib/images/searchico.png'),
                          hintText: S.of(context).search,
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
                  ),
                ),
              if (showSecretSwitch == true)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SecretSwitch(
                      value: true,
                      onChanged: (value) {
                        print('turn off');
                        appStore.switchSecretPhotos();
                        galleryStore.removeAllPrivatePics();
                      }),
                ),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                onPressed: () {
                  Navigator.pushNamed(context, SettingsScreen.id);
                },
                child: Image.asset('lib/images/settings.png'),
              ),
            ],
          ),
        ),
        ...children
      ],
    );
  }
}
