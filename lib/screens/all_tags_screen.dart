import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:picPics/stores/gallery_store.dart';
import 'package:picPics/stores/pic_store.dart';
import 'package:picPics/stores/tabs_store.dart';
import 'package:picPics/stores/tags_store.dart';
import 'package:picPics/utils/enum.dart';
import 'package:picPics/utils/show_edit_label_dialog.dart';
import 'package:picPics/widgets/customised_tags_list.dart';
import 'package:picPics/widgets/show_watch_ad_modal.dart';
import 'package:picPics/widgets/tags_list.dart';
import 'package:provider/provider.dart';

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
  var textEditingController = TextEditingController();
  var tagStore = <TagsStore>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = Provider.of<AppStore>(context);
    tabsStore = Provider.of<TabsStore>(context);
    galleryStore = Provider.of<GalleryStore>(context);
    tagStore = List<TagsStore>.from(
        galleryStore.tagsFromPic(picStore: widget.picStore));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset('lib/images/backarrowgray.png'),
                      ),
                      Image.asset('lib/images/searchico.png'),
                      SizedBox(
                        width: 10.0,
                      ),
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
                                  child: SimpleAutoCompleteTextField(
                                    key: widget.key,
                                    controller: textEditingController,
                                    suggestions: appStore.tags.values
                                        .map((e) => e.name)
                                        .toList(),
                                    clearOnSubmit: false,
                                    textSubmitted: (text) {
                                      if (text.trim() != '') {
                                        setState(() {});
                                      }
                                    },
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
                            ],
                          ),
                        ),
                      ),
                      Container(width: 15.0),
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
                        tags: appStore.tags.values.toList(),
                        selectedTags: tagStore,
                        onTap: (String tagId, String tagName) {
                          //print('do nothing');
                          /* if (!appStore.canTagToday) {
                          showWatchAdModal(context);
                          return;
                        } */
                          if (tagStore.firstWhere(
                                  (element) => element.id == tagId,
                                  orElse: () => null) !=
                              null) {
                            galleryStore.removeTagFromPic(
                                picStore: widget.picStore, tagKey: tagId);
                          } else {
                            galleryStore.addTagToPic(
                                picStore: widget.picStore, tagName: tagName);
                          }
                          setState(() {
                            tagStore = List<TagsStore>.from(galleryStore
                                .tagsFromPic(picStore: widget.picStore));
                            print(tagStore.map((e) => e.name).toList());
                          });
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
    );
  }
}
