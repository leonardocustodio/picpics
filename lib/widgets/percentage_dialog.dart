import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:picPics/stores/percentage_dialog_controller.dart';

class PercentageDialog extends GetWidget<PercentageDialogController> {
  const PercentageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.show.value == false) {
        return Container();
      }
      return Container(
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(color: Colors.black.withOpacity(.7))),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                height: 80,
                child: Obx(() {
                  var percentage = 0.0;
                  if (controller.total.value > 0.0) {
                    percentage =
                        controller.value.value / controller.total.value;
                  }

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: CircularPercentIndicator(
                            radius: 70,
                            percent: percentage,
                            progressColor: Colors.green,
                            backgroundColor: Colors.grey.withOpacity(.4)),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${(percentage * 100).floor()}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              inherit: false,
                              color: Colors.black,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            if (controller.text.value != null)
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(top: 130),
                  child: Text(
                    '${controller.text.value}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        inherit: false, color: Colors.white, fontSize: 17),
                  ),
                ),
              )
          ],
        ),
      );
    });
  }
}
