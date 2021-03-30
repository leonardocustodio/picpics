import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/stores/tags_store.dart';
import 'package:picPics/utils/helpers.dart';
import 'package:picPics/utils/show_edit_label_dialog.dart';
import 'package:picPics/widgets/customised_tags_list.dart';
import 'package:picPics/widgets/show_watch_ad_modal.dart';
import '../constants.dart';

class AllTagsScreen extends StatefulWidget {
  static const id = 'all_tags_screen';
  final PicStore picStore;
  AllTagsScreen({@required this.picStore, Key key}) : super(key: key);

  @override
  _AllTagsScreenState createState() => _AllTagsScreenState();
}

class _AllTagsScreenState extends State<AllTagsScreen> {
  AppStore appStore;
  TabsStore tabsStore;
  GalleryStore galleryStore;
  FocusNode focusNode = FocusNode();
  String searchedText = '';
  bool doFullSearching = true;
  var searchEditingController = TextEditingController();
  var selectedTags = <String, TagsStore>{},
      allTagsAvailable = <String, TagsStore>{},
      searchedTags = <String, TagsStore>{};

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
    appStore.loadTags();
    tabsStore = Provider.of<TabsStore>(context);
    galleryStore = Provider.of<GalleryStore>(context);

    galleryStore
        .tagsFromPic(picStore: widget.picStore)
        .forEach((TagsStore tag_element) {
      selectedTags[tag_element.id] = tag_element;
    });
  }

  void doSearching() {
    searchedText = searchedText.trim();
    if (searchedText == '') return;
    var tempTags;
    if (!doFullSearching) {
      // copy the already searched tags into temporary variable
      tempTags = Map<String, TagsStore>.from(searchedTags);
    }
    searchedTags.clear();
    var listOfLetters = searchedText.toLowerCase().split('');
    (!doFullSearching ? tempTags : appStore.tags).forEach(
      (key, value) => doCustomisedSearching(
        value,
        listOfLetters,
        (matched) {
          if (matched) searchedTags[key] = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 10),
                            child: Image.asset('lib/images/backarrowgray.png'),
                          ),
                        ),
                        /* 
                        GestureDetector(
                            onTap: () {
                              if (!focusNode.hasFocus)
                                Focus.of(context).requestFocus(focusNode);
                            },
                            child:  */
                        Image.asset('lib/images/searchico.png'),
                        //),
                        const SizedBox(width: 10),
                        /*  Expanded(
                          child: TextField(
                            // controller: _textEditingController,
                            // onSubmitted: (_) => _selectPlace(),
                            // onEditingComplete: _selectPlace,
                            autofocus: false,
                            // focusNode: _fn,
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
                              contentPadding: const EdgeInsets.all(0),
                              border:
                                  OutlineInputBorder(borderSide: BorderSide.none),
                              enabledBorder:
                                  OutlineInputBorder(borderSide: BorderSide.none),
                              focusedBorder:
                                  OutlineInputBorder(borderSide: BorderSide.none),
                              hintText: 'Search...',
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
                        ), */
                        Expanded(
                          child: Container(
                            height: 50,
                            width: 200,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: TextFormField(
                                      key: widget.key,
                                      controller: searchEditingController,
                                      focusNode: focusNode,
                                      onChanged: (t) {
                                        var text = t.trim();
                                        if (searchedText == '') {
                                          if (text != '') {
                                            // New letter came
                                            searchedText = text;
                                            doFullSearching = true;
                                            doSearching();
                                          }
                                        } else {
                                          // searchedText already has some data
                                          if (text == '') {
                                            searchedText = '';
                                            doFullSearching = true;
                                            searchedTags.clear();
                                          } else if (searchedText.length <
                                              text.length) {
                                            // more new letters added
                                            searchedText = text;
                                            doFullSearching = false;
                                            doSearching();
                                          } else if (searchedText.length >
                                              text.length) {
                                            // letters deleted
                                            searchedText = text;
                                            doFullSearching = true;
                                            doSearching();
                                          } else {
                                            // New letter came
                                            searchedText = text;
                                            doFullSearching = true;
                                            doSearching();
                                          }
                                        }
                                        setState(() {});
                                      },
                                      onFieldSubmitted: (text) {
                                        /* 
                                        searchedText = text.trim();
                                        if (searchedText != '') {
                                          appStore.tags.forEach((key, value) {
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
                                        setState(() {}); */
                                      },
                                      /* suggestions: appStore.tags.values
                                          .map((e) => e.name)
                                          .toList(),
                                      clearOnSubmit: false,
                                      textSubmitted: (text) {
                                        if (text.trim() != '') {
                                          setState(() {});
                                        }
                                      }, */

                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        color: Color(0xff606566),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: -0.4099999964237213,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(0),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none),
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
                                if (searchedText != '')
                                  GestureDetector(
                                      onTap: () {
                                        if (searchedText != '') {
                                          searchedText = '';
                                          doFullSearching = true;
                                          searchedTags.clear();
                                          focusNode.unfocus();
                                          searchEditingController.clear();
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                          width: 60, child: Icon(Icons.clear))),
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
                if (searchedText != '')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
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
                        tags: searchedTags.values.toList(),
                        selectedTags: selectedTags,
                        onTap: (String tagId, String tagName, int count,
                            DateTime time) async {
                          //print('do nothing');
                          if (!appStore.canTagToday) {
                            showWatchAdModal(context);
                            return;
                          }
                          if (selectedTags[tagId] != null) {
                            selectedTags.remove(tagId);
                            setState(() {});
                            await galleryStore.removeTagFromPic(
                                picStore: widget.picStore, tagKey: tagId);
                          } else {
                            selectedTags[tagId] = TagsStore(
                                id: tagId,
                                name: tagName,
                                count: count,
                                time: time);
                            setState(() {});
                            await galleryStore.addTagToPic(
                                picStore: widget.picStore, tagName: tagName);
                          }
                          appStore.loadTags();
                        },
                        onDoubleTap: () {
                          //print('do nothing');
                        },
                        showEditTagModal: () =>
                            showEditTagModal(context, galleryStore),
                      ),
                    ],
                  ),
                if (searchedText == '')
                  Observer(
                    builder: (_) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
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
                            tags: appStore.mostUsedTags,
                            selectedTags: selectedTags,
                            onTap: (String tagId, String tagName, int count,
                                DateTime time) async {
                              //print('do nothing');
                              /* if (!appStore.canTagToday) {
                            showWatchAdModal(context);
                            return;
                          } */
                              if (selectedTags[tagId] != null) {
                                selectedTags.remove(tagId);
                                setState(() {});
                                await galleryStore.removeTagFromPic(
                                    picStore: widget.picStore, tagKey: tagId);
                              } else {
                                selectedTags[tagId] = TagsStore(
                                    id: tagId,
                                    name: tagName,
                                    count: count,
                                    time: time);
                                setState(() {});
                                await galleryStore.addTagToPic(
                                    picStore: widget.picStore,
                                    tagName: tagName);
                              }
                              appStore.loadTags();
                            },
                            onDoubleTap: () {
                              //print('do nothing');
                            },
                            showEditTagModal: () =>
                                showEditTagModal(context, galleryStore),
                          ),
                        ],
                      );
                    },
                  ),
                if (appStore.lastWeekUsedTags.isNotEmpty && searchedText == '')
                  const SizedBox(height: 20),
                if (appStore.lastWeekUsedTags.isNotEmpty && searchedText == '')
                  Observer(
                    builder: (_) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
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
                            tags: appStore.lastWeekUsedTags,
                            selectedTags: selectedTags,
                            onTap: (String tagId, String tagName, int count,
                                DateTime time) async {
                              //print('do nothing');
                              /* if (!appStore.canTagToday) {
                            showWatchAdModal(context);
                            return;
                          } */
                              if (selectedTags[tagId] != null) {
                                selectedTags.remove(tagId);
                                setState(() {});
                                await galleryStore.removeTagFromPic(
                                    picStore: widget.picStore, tagKey: tagId);
                              } else {
                                selectedTags[tagId] = TagsStore(
                                    id: tagId,
                                    name: tagName,
                                    count: count,
                                    time: time);
                                setState(() {});
                                await galleryStore.addTagToPic(
                                    picStore: widget.picStore,
                                    tagName: tagName);
                              }
                              appStore.loadTags();
                            },
                            onDoubleTap: () {
                              //print('do nothing');
                            },
                            showEditTagModal: () =>
                                showEditTagModal(context, galleryStore),
                          ),
                        ],
                      );
                    },
                  ),
                if (appStore.lastMonthUsedTags.isNotEmpty && searchedText == '')
                  const SizedBox(height: 20),
                if (appStore.lastMonthUsedTags.isNotEmpty && searchedText == '')
                  Observer(
                    builder: (_) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
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
                            tags: appStore.lastWeekUsedTags,
                            selectedTags: selectedTags,
                            onTap: (String tagId, String tagName, int count,
                                DateTime time) async {
                              //print('do nothing');
                              /* if (!appStore.canTagToday) {
                            showWatchAdModal(context);
                            return;
                          } */
                              if (selectedTags[tagId] != null) {
                                selectedTags.remove(tagId);
                                setState(() {});
                                await galleryStore.removeTagFromPic(
                                    picStore: widget.picStore, tagKey: tagId);
                              } else {
                                selectedTags[tagId] = TagsStore(
                                    id: tagId,
                                    name: tagName,
                                    count: count,
                                    time: time);
                                setState(() {});
                                await galleryStore.addTagToPic(
                                    picStore: widget.picStore,
                                    tagName: tagName);
                              }
                              appStore.loadTags();
                            },
                            onDoubleTap: () {
                              //print('do nothing');
                            },
                            showEditTagModal: () =>
                                showEditTagModal(context, galleryStore),
                          ),
                        ],
                      );
                    },
                  ),
                if (searchedText == '') const SizedBox(height: 20),
                if (searchedText == '')
                  Observer(
                    builder: (_) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'All Tags',
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
                            tags: appStore.tags.values.toList(),
                            selectedTags: selectedTags,
                            onTap: (String tagId, String tagName, int count,
                                DateTime time) async {
                              //print('do nothing');
                              /* if (!appStore.canTagToday) {
                            showWatchAdModal(context);
                            return;
                          } */
                              if (selectedTags[tagId] != null) {
                                selectedTags.remove(tagId);
                                setState(() {});
                                await galleryStore.removeTagFromPic(
                                    picStore: widget.picStore, tagKey: tagId);
                              } else {
                                selectedTags[tagId] = TagsStore(
                                    id: tagId,
                                    name: tagName,
                                    count: count,
                                    time: time);
                                setState(() {});
                                await galleryStore.addTagToPic(
                                    picStore: widget.picStore,
                                    tagName: tagName);
                              }
                              appStore.loadTags();
                            },
                            onDoubleTap: () {
                              //print('do nothing');
                            },
                            showEditTagModal: () =>
                                showEditTagModal(context, galleryStore),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
