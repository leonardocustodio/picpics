import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/screens/settings_screen.dart';
import 'package:picPics/stores/private_photos_controller.dart';
import 'package:picPics/stores/tags_controller.dart';
import 'package:picPics/widgets/secret_switch.dart';

typedef OnUntag = Function();

class TopBar extends StatelessWidget {
  /* final GalleryStore galleryStore; */
  final FocusNode? searchFocusNode;
  final bool showUntag;
  final OnUntag? onUntag;
  final TextEditingController? searchEditingController;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;
  final List<Widget> children;
  final bool showSecretSwitch;

  TopBar({
    required this.showSecretSwitch,
    this.searchEditingController,
    this.showUntag = false,
    this.searchFocusNode,
    this.onUntag,
    this.onSubmitted,
    this.onChanged,
    required this.children,
  }) : assert((searchEditingController == null
            ? (onChanged == null && onSubmitted == null)
            : (onChanged != null && onSubmitted != null)));

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
                        /* if (TagsController.to.isSearching.value == false) {
                          TagsController.to.setIsSearching(true);
                          TagsController.to.tagsSuggestionsCalculate();
                        } else {
                          TagsController.to.selectedFilteringTagsKeys.clear();
                          TagsController.to.setIsSearching(false);
                          searchFocusNode?.unfocus();
                        } */
                      },
                      child: GestureDetector(
                        onTap: () {
                          if (TagsController.to.isSearching.value == false) {
                            TagsController.to.setIsSearching(true);
                            TagsController.to.tagsSuggestionsCalculate();
                          }
                        },
                        child: TextField(
                          controller: searchEditingController,
                          focusNode: searchFocusNode,
                          onChanged: (text) {
                            //print('searching: $text');
                            onChanged?.call(text);
                            /* TagsController.to.searchText.value = text; */
                          },
                          onSubmitted: (text) {
                            //print('return');
                            onSubmitted?.call(text);
                            searchEditingController?.clear();
                            /* TagsController.to.searchTagsResults.clear(); */
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
                ),
              if (showSecretSwitch == true)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SecretSwitch(
                      value: true,
                      onChanged: (value) {
                        //print('turn off');
                        PrivatePhotosController.to.switchSecretPhotos();

                        /// TODO: implement this functionality
                        // galleryStore.removeAllPrivatePics();
                      }),
                ),
              showUntag
                  ? GestureDetector(
                      onTap: () {
                        onUntag?.call();
                      },
                      child: Text('Untag'))
                  : CupertinoButton(
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
