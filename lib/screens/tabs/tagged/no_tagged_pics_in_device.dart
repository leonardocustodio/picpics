import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/stores/language_controller.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/widgets/top_bar.dart';

class NoTaggedPicsInDevice extends StatelessWidget {
  const NoTaggedPicsInDevice({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TopBar(
          children: <Widget>[],
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: Get.height / 2,
                child: Image.asset('lib/images/notaggedphotos.png'),
              ),
              SizedBox(
                height: 21.0,
              ),
              Obx(
                () => Text(
                  LangControl.to.S.value.no_tagged_photos,
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Lato',
                    color: Color(0xff979a9b),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              SizedBox(
                height: 17.0,
              ),
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () => TabsController.to.setCurrentTab(1),
                child: Container(
                  width: 201.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Obx(
                      () => Text(
                        LangControl.to.S.value.start_tagging,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          color: kWhiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          letterSpacing: -0.4099999964237213,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
