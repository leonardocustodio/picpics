import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DeviceHasNoPics extends StatelessWidget {
  final String message;

  const DeviceHasNoPics({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    print('Device Height: $height');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxHeight: height / 2,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: Image.asset('lib/images/nogalleryauth.png'),
            ),
          ),
          const SizedBox(
            height: 21.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              message,
              textScaler: TextScaler.linear(1.0),
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
//          SizedBox(
//            height: 17.0,
//          ),
//          CupertinoButton(
//            padding: const EdgeInsets.all(0),
//            onPressed: () {
//              PhotoManager.openSetting()
//            },
//            child: Container(
//              width: 201.0,
//              height: 44.0,
//              decoration: BoxDecoration(
//                gradient: kPrimaryGradient,
//                borderRadius: BorderRadius.circular(8),
//              ),
//              child: Center(
//                child: Text(
//                  LangControl.to.S.value.open_gallery,
//                  textScaler: TextScaler.linear(1.0),
//                  style: TextStyle(
//                    fontFamily: 'Lato',
//                    color: kWhiteColor,
//                    fontSize: 16,
//                    fontWeight: FontWeight.w700,
//                    fontStyle: FontStyle.normal,
//                    letterSpacing: -0.4099999964237213,
//                  ),
//                ),
//              ),
//            ),
//          ),
        ],
      ),
    );
  }
}
