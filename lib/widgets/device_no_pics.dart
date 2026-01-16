import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picpics/utils/app_logger.dart';

class DeviceHasNoPics extends StatelessWidget {

  const DeviceHasNoPics({required this.message, super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    AppLogger.d('Device Height: $height');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(
              maxHeight: height / 2,
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Image.asset('lib/images/nogalleryauth.png'),
            ),
          ),
          const SizedBox(
            height: 21,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              message,
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
