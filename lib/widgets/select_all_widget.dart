import 'package:flutter/material.dart';
import 'package:picPics/constants.dart';

class SelectAllWidget extends StatelessWidget {
  final bool isSelected;
  const SelectAllWidget({required this.isSelected, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      height: 40,
      child: Row(
        children: [
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
                    border: Border.all(color: Colors.grey, width: 1)),
            child:
                isSelected ? Image.asset('lib/images/checkwhiteico.png') : null,
          ),
          const Text(
            'Select All',
            textScaleFactor: 1,
            style: TextStyle(
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
