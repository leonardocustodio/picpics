import 'package:flutter/material.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/stores/tabs_controller.dart';
import 'package:picPics/utils/helpers.dart';

class DateHeaderWidget extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isMonth;
  const DateHeaderWidget(
      {required this.date,
      required this.isSelected,
      required this.isMonth,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      height: 40.0,
      child: Row(
        children: [
          if (TabsController.to.multiPicBar.value)
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 10),
              decoration: isSelected
                  ? BoxDecoration(
                      gradient: kSecondaryGradient,
                      borderRadius: BorderRadius.circular(10.0),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey, width: 1.0)),
              child: isSelected
                  ? Image.asset('lib/images/checkwhiteico.png')
                  : null,
            ),
          Text(
            '${Helpers.dateFormat(date, isMonth: isMonth)}',
            textScaleFactor: 1.0,
            style: TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff606566),
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
        ],
      ),
    );
  }
}
