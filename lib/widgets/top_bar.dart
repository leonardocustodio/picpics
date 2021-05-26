import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:picPics/widgets/secret_switch.dart';

class TopBar extends StatelessWidget {
  final UserController appStore;
  /* final GalleryStore galleryStore; */
  final TagsController tagsController;
  final FocusNode searchFocusNode;
  final TextEditingController searchEditingController;
  final List<Widget> children;
  final bool showSecretSwitch;

  TopBar({
    @required this.appStore,
    @required this.tagsController,
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
                        //print('hasFocus: ${searchFocusNode.hasFocus}');
                        if (focus) {
                          tagsController.setIsSearching(true);
                          tagsController.tagsSuggestionsCalculate(null);
                        } else {
                          tagsController.selectedFilteringTagsKeys.clear();
                          tagsController.setIsSearching(false);
                        }
                      },
                      child: TextField(
                        controller: searchEditingController,
                        focusNode: searchFocusNode,
                        onChanged: (text) {
                          //print('searching: $text');
                          tagsController.searchText.value = text;
                        },
                        onSubmitted: (text) {
                          //print('return');
                          searchEditingController.clear();
                          tagsController.searchTagsResults.clear();
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
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
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
                        //print('turn off');
                        appStore.switchSecretPhotos();

                        /// TODO: implement this functionality
                        // galleryStore.removeAllPrivatePics();
                      }),
                ),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                onPressed: () {
                  Get.to(() => SettingsScreen());
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
