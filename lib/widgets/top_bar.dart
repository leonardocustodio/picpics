import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/screens/settings_screen.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/private_photos_controller.dart';
import 'package:picpics/stores/tags_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/secret_switch.dart';

typedef OnUntag = Function();

class TopBar extends StatelessWidget {

  const TopBar({
    required this.children, super.key,
    this.searchEditingController,
    this.showUntag = false,
    this.searchFocusNode,
    this.onUntag,
    this.onSubmitted,
    this.onChanged,
  }) : assert((searchEditingController == null
            ? (onChanged == null && onSubmitted == null)
            : (onChanged != null && onSubmitted != null)),);
  /* final GalleryStore galleryStore; */
  final FocusNode? searchFocusNode;
  final bool showUntag;
  final OnUntag? onUntag;
  final TextEditingController? searchEditingController;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (searchEditingController != null)
                Expanded(
                  child: FocusScope(
                    child: Focus(
                      onFocusChange: (focus) {
                        AppLogger.d('hasFocus: $focus');
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
                        child: Obx(
                          () => TextField(
                            controller: searchEditingController,
                            focusNode: searchFocusNode,
                            onChanged: (text) {
                              AppLogger.d('searching: $text');
                              onChanged?.call(text);
                              /* TagsController.to.searchText.value = text; */
                            },
                            onSubmitted: (text) {
                              AppLogger.d('return');
                              onSubmitted?.call(text);
                              searchEditingController?.clear();
                              /* TagsController.to.searchTagsResults.clear(); */
                              //                          DatabaseManager.instance.searchResults = null;
                            },
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xff606566),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.4099999964237213,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(right: 2),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,),
                              prefixIcon:
                                  Image.asset('lib/images/searchico.png'),
                              hintText: LangControl.to.S.value.search,
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
                      ),
                    ),
                  ),
                ),
              GetX<PrivatePhotosController>(builder: (privateController) {
                return privateController.showPrivate.value
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SecretSwitch(
                            value: privateController.showPrivate.value,
                            onChanged: (value) {
                              AppLogger.d('turn off');
                              privateController.switchSecretPhotos();
                            },),
                      )
                    : Container();
              },),
              if (showUntag) GestureDetector(
                      onTap: () {
                        onUntag?.call();
                      },
                      child: const Text('Untag'),) else CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      onPressed: () {
                        Get.to<void>(() => const SettingsScreen());
                      },
                      child: Image.asset('lib/images/settings.png'),
                    ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}
