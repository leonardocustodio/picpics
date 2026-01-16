import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/utils/helpers.dart';

class DateHeaderWidget extends ConsumerWidget {
  const DateHeaderWidget(
      {required this.date,
      required this.isSelected,
      required this.isMonth,
      super.key,});
  final DateTime date;
  final bool isSelected;
  final bool isMonth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final multiPicBar = ref.watch(tabsProvider).multiPicBar;
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      height: 40,
      child: Row(
        children: [
          if (multiPicBar)
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 10),
              decoration: isSelected
                  ? BoxDecoration(
                      gradient: kSecondaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),),
              child: isSelected
                  ? Image.asset('lib/images/checkwhiteico.png')
                  : null,
            ),
          Text(
            Helpers.dateFormat(date, isMonth: isMonth),
            textScaler: const TextScaler.linear(1),
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff606566),
              fontSize: 14,
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
