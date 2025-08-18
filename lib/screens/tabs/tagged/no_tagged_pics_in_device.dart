import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/stores/language_controller.dart';
import 'package:picpics/stores/tabs_controller.dart';
import 'package:picpics/widgets/top_bar.dart';

class NoTaggedPicsInDevice extends StatelessWidget {
  const NoTaggedPicsInDevice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const TopBar(
          children: <Widget>[],
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: Get.height / 2,
                child: Image.asset('lib/images/notaggedphotos.png'),
              ),
              const SizedBox(
                height: 21,
              ),
              Obx(
                () => Text(
                  LangControl.to.S.value.no_tagged_photos,
                  textScaler: const TextScaler.linear(1),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    color: Color(0xff979a9b),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              const SizedBox(
                height: 17,
              ),
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: () => TabsController.to.setCurrentTab(1),
                child: Container(
                  width: 201,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Obx(
                      () => Text(
                        LangControl.to.S.value.start_tagging,
                        textScaler: const TextScaler.linear(1),
                        style: const TextStyle(
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
