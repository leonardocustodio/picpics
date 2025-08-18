import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/model/tag_model.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/pic_store.dart';
import 'package:picpics/stores/tagged_controller.dart';
import 'package:picpics/stores/tags_controller.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/helpers.dart';
import 'package:picpics/widgets/customised_tags_list.dart';

// ignore_for_file: invalid_use_of_protected_member
class AllTagsController extends GetxController {
  final selectedTags = <String, TagModel>{}.obs;
  final allTagsAvailable = <String, TagModel>{}.obs;
  final searchedTags = <String, TagModel>{}.obs;

  final searchedText = ''.obs;
  //final doFullSearching = true.obs;

  void doSearching() {
    searchedText.value = searchedText.trim();
    if (searchedText.value == '') return;
    /* var tempTags;
    if (!doFullSearching.value) {
      // copy the already searched tags into temporary variable
      tempTags = Map<String, TagModel>.from(searchedTags.value);
    } */
    searchedTags.value.clear();
    final listOfLetters = searchedText.value.toLowerCase().split('');
    /* !doFullSearching.value ? tempTags : */ TagsController.to.allTags
        .forEach(
      (key, value) => doCustomisedSearching(
        value.value,
        listOfLetters,
        (matched) {
          if (matched) {
            searchedTags[key] = value.value;
          }
        },
      ),
    );
  }
}

/* typedef CompletionHandler = Function(); */

// ignore_for_file: must_be_immutable, unused_field, prefer_final_fields
class AllTagsScreen extends GetWidget<AllTagsController> {
  AllTagsScreen({
    this.picStore,
    super.key,
  });
  static const id = 'all_tags_screen';
  final PicStore? picStore;

  var _ = Get.put(AllTagsController());

  FocusNode focusNode = FocusNode();
  TextEditingController searchEditingController = TextEditingController();

/* 
  @override
  void initState() {
    super.initState();
  }
 */
/*   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    UserController.to = Provider.of<UserController>(context);
    UserController.to.loadTags();
    tabsStore = Provider.of<TabsStore>(context);
    GalleryStore.to = Provider.of<GalleryStore>(context);

    GalleryStore.to
        .tagsFromPic(picStore: picStore)
        .forEach((TagsStore tag_element) {
      selectedTags[tag_element.id] = tag_element;
    });
  } */

  bool loadTagsFromPicStore = true;

  @override
  Widget build(BuildContext context) {
    if (loadTagsFromPicStore) {
      //WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedTags.value = Map<String, TagModel>.from(
          picStore!.tags.value.map((key, value) => MapEntry(key, value.value)),);
      loadTagsFromPicStore = false;
      // });
    }
    return Obx(
      () => Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => Get.back<void>(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, right: 10),
                              child:
                                  Image.asset('lib/images/backarrowgray.png'),
                            ),
                          ),
                          /* 
                        GestureDetector(
                            onTap: () {
                              if (!focusNode.hasFocus)
                                FocuLangControl.to.S.value.requestFocus(focusNode);
                            },
                            child:  */
                          Image.asset('lib/images/searchico.png'),
                          //),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 50,
                              width: 200,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: TextFormField(
                                        key: key,
                                        controller: searchEditingController,
                                        focusNode: focusNode,
                                        onChanged: (text) {
                                          controller.searchedText.value = text;
                                          controller.doSearching();
                                          /* if (text != '') {
                                              // New letter came
                                              controller.searchedText.value =
                                                  text;
                                              controller.doFullSearching.value =
                                                  true;
                                              controller.doSearching();
                                            }
                                          } else {
                                            // searchedText already has some data
                                            if (text == '') {
                                              controller.searchedText.value = '';
                                              controller.doFullSearching.value =
                                                  true;
                                              controller.searchedTags.clear();
                                            } else if (controller
                                                    .searchedText.value.length <
                                                text.length) {
                                              // more new letters added
                                              controller.doFullSearching.value =
                                                  false;
                                            } else if (controller
                                                    .searchedText.value.length >
                                                text.length) {
                                              // letters deleted
                                              controller.searchedText.value =
                                                  text;
                                              controller.doFullSearching.value =
                                                  true;
                                              controller.doSearching();
                                            } else {
                                              // New letter came
                                              controller.searchedText.value =
                                                  text;
                                              controller.doFullSearching.value =
                                                  true;
                                              controller.doSearching();
                                            } */
                                        },
                                        onFieldSubmitted: (text) {
                                          /* 
                                          searchedText = text.trim();
                                          if (searchedText != '') {
                                            UserController.to.tags.forEach((key, value) {
                                              if (value.name
                                                  .toLowerCase()
                                                  .startsWith(searchedText
                                                      .toLowerCase())) {
                                                searchedTags[key] = value;
                                              }
                                            });
                                          } else {
                                            searchedTags.clear();
                                          }
                                          // */
                                        },
                                        /* suggestions: UserController.to.tags.values
                                            .map((e) => e.name)
                                            .toList(),
                                        clearOnSubmit: false,
                                        textSubmitted: (text) {
                                          if (text.trim() != '') {
                                            //
                                          }
                                        }, */

                                        style: const TextStyle(
                                          fontFamily: 'Lato',
                                          color: Color(0xff606566),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: -0.4099999964237213,
                                        ),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,),
                                          hintText: 'Search...',
                                          hintStyle: TextStyle(
                                            fontFamily: 'Lato',
                                            color: kGrayColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (controller.searchedText.value != '')
                                    GestureDetector(
                                        onTap: () {
                                          /* if (controller.searchedText.value !=
                                              '') { */
                                          controller.searchedText.value = '';
                                          /* controller.doFullSearching.value =
                                                true; */
                                          controller.searchedTags.clear();
                                          focusNode.unfocus();
                                          searchEditingController.clear();
                                          /* } */
                                        },
                                        child: const SizedBox(
                                            width: 60,
                                            child: Icon(Icons.clear),),),
                                ],
                              ),
                            ),
                          ),
                          // if (widget.hasClearButton)
                          //   GestureDetector(
                          //     onTap: () {
                          //       if (_crossFadeState == CrossFadeState.showSecond) _textEditingController.clear();
                          //     },
                          //     // child: Icon(_inputIcon, color: this.widget.iconColor),
                          //     child: AnimatedCrossFade(
                          //       crossFadeState: _crossFadeState,
                          //       duration: Duration(milliseconds: 300),
                          //       firstChild: Container(),
                          //       secondChild: Icon(Icons.clear, color: widget.iconColor),
                          //     ),
                          //   ),
                          // if (!widget.hasClearButton) Container()
                        ],
                      ),
                    ),
                  ),
                  if (controller.searchedText.value != '')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Searched',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xff979a9b),
                              fontSize: 33,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.4099999964237213,
                            ),
                          ),
                        ),
                        CustomisedTagsList(
                          tagsKeyList:
                              controller.searchedTags.value.keys.toList(),
                          selectedTags: controller.selectedTags.value,
                          onTap: (String tagId, String tagName, int count,
                                  DateTime time,) async =>
                              doTagging(tagId, tagName, count, time),
                          onDoubleTap: () {
                            AppLogger.d('do nothing');
                          },
                          //showEditTagModal: () => showEditTagModal(context),
                        ),
                      ],
                    ),
                  if (controller.searchedText.value == '')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Most used',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xff979a9b),
                              fontSize: 33,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.4099999964237213,
                            ),
                          ),
                        ),
                        CustomisedTagsList(
                          tagsKeyList:
                              TagsController.to.mostUsedTags.keys.toList(),
                          selectedTags: controller.selectedTags.value,
                          onTap: (String tagId, String tagName, int count,
                                  DateTime time,) async =>
                              doTagging(tagId, tagName, count, time),
                          onDoubleTap: () {
                            AppLogger.d('do nothing');
                          },
                          // showEditTagModal: () => showEditTagModal(context),
                        ),
                      ],
                    ),
                  if (TagsController.to.lastWeekUsedTags.isNotEmpty &&
                      controller.searchedText.value == '')
                    const SizedBox(height: 20),
                  if (TagsController.to.lastWeekUsedTags.isNotEmpty &&
                      controller.searchedText.value == '')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Last Week Used',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xff979a9b),
                              fontSize: 33,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.4099999964237213,
                            ),
                          ),
                        ),
                        CustomisedTagsList(
                          tagsKeyList:
                              TagsController.to.lastWeekUsedTags.keys.toList(),
                          selectedTags: controller.selectedTags.value,
                          onTap: (String tagId, String tagName, int count,
                                  DateTime time,) async =>
                              doTagging(tagId, tagName, count, time),
                          onDoubleTap: () {
                            AppLogger.d('do nothing');
                          },
                          //showEditTagModal: () => showEditTagModal(context),
                        ),
                      ],
                    ),
                  if (TagsController.to.lastMonthUsedTags.isNotEmpty &&
                      controller.searchedText.value == '')
                    const SizedBox(height: 20),
                  if (TagsController.to.lastMonthUsedTags.isNotEmpty &&
                      controller.searchedText.value == '')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Last Month Used',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xff979a9b),
                              fontSize: 33,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.4099999964237213,
                            ),
                          ),
                        ),
                        CustomisedTagsList(
                          tagsKeyList: TagsController
                              .to.lastWeekUsedTags.value.keys
                              .toList(),
                          selectedTags: controller.selectedTags.value,
                          onTap: (String tagId, String tagName, int count,
                                  DateTime time,) async =>
                              doTagging(tagId, tagName, count, time),
                          onDoubleTap: () {
                            AppLogger.d('do nothing');
                          },
                          //showEditTagModal: () => showEditTagModal(context),
                        ),
                      ],
                    ),
                  if (controller.searchedText.value == '')
                    const SizedBox(height: 20),
                  if (controller.searchedText.value == '')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Obx(
                            () => Text(
                              LangControl.to.S.value.allTags,
                              style: const TextStyle(
                                fontFamily: 'Lato',
                                color: Color(0xff979a9b),
                                fontSize: 33,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                letterSpacing: -0.4099999964237213,
                              ),
                            ),
                          ),
                        ),
                        CustomisedTagsList(
                          tagsKeyList: TagsController.to.allTags.keys.toList(),
                          selectedTags: controller.selectedTags.value,
                          onTap: (String tagId, String tagName, int count,
                                  DateTime time,) async =>
                              doTagging(tagId, tagName, count, time),
                          onDoubleTap: () {
                            AppLogger.d('do nothing');
                          },
                          //showEditTagModal: () => showEditTagModal(context),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> doTagging(
      String tagId, String tagName, int count, DateTime time,) async {
    AppLogger.d('do nothing');

    if (controller.selectedTags.value[tagId] != null) {
      controller.selectedTags.value.remove(tagId);
      //
      await TagsController.to.removeTagFromPic(
          picId: picStore!.photoId.value, tagKey: tagId,);
    } else {
      controller.selectedTags.value[tagId] =
          TagModel(key: tagId, title: tagName, count: count, time: time);

      await picStore?.addMultipleTagsToPic(acceptedTagKeys: {tagId: ''});
    }
    await TagsController.to.loadAllTags();
    await TaggedController.to.refreshTaggedPhotos();
  }
}
