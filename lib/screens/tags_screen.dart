import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';

class TagsScreen_ extends StatefulWidget {

  const TagsScreen_({super.key});
  static String id = 'tags_screen';

  @override
  _TagsScreen_State createState() => _TagsScreen_State();
}

class _TagsScreen_State extends State<TagsScreen_> {
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
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.only(left: 5, right: 10),
                        onPressed: () => Get.back<void>(),
                        child: Image.asset('lib/images/backarrowgray.png'),
                      ),
                      Image.asset('lib/images/searchico.png'),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: TextField(
                          // focusNode: _fn,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xff606566),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.4099999964237213,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
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
                      Container(width: 15),
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
