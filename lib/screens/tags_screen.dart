import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:picPics/constants.dart';

class TagsScreen extends StatefulWidget {
  static String id = 'tags_screen';

  @override
  _TagsScreenState createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
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
                      Expanded(
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
            ],
          ),
        ),
      ),
    );
  }
}
