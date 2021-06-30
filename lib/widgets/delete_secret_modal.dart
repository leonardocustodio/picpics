import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:picPics/stores/user_controller.dart';

class DeleteSecretModal extends StatefulWidget {
  final Function() onPressedClose;
  final Function() onPressedDelete;
  final Function() onPressedOk;

  DeleteSecretModal({
    required this.onPressedClose,
    required this.onPressedDelete,
    required this.onPressedOk,
  });

  @override
  _DeleteSecretModalState createState() => _DeleteSecretModalState();
}

class _DeleteSecretModalState extends State<DeleteSecretModal> {
  bool keepAsking = true;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //print('Width: $width');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: width < 360
          ? EdgeInsets.symmetric(horizontal: 20.0)
          : EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Color(0xFFF1F3F5),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(14),
            bottom: Radius.circular(19.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: 0.0,
                    child: CupertinoButton(
                      onPressed: () {
                        //print('teste');
                      },
                      child: Image.asset('lib/images/closegrayico.png'),
                    ),
                  ),
                  Text(
                    S.of(context).secret_photos,
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: Color(0xff979a9b),
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      letterSpacing: -0.4099999964237213,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: widget.onPressedClose,
                    child: Image.asset('lib/images/closegrayico.png'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 44.0),
                child: Image.asset('lib/images/lockmodalico.png'),
              ),
              Text(
                S.of(context).keep_safe,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff707070),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      onPressed: () {
                        setState(() {
                          keepAsking = true;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 20.0,
                            width: 20.0,
                            margin: const EdgeInsets.only(right: 8.0),
                            child: keepAsking
                                ? Image.asset('lib/images/checkwhiteico.png')
                                : null,
                            decoration: keepAsking
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    gradient: LinearGradient(
                                      colors: [
                                        kSecondaryColor,
                                        Color(0xffff7878)
                                      ],
                                      stops: [0, 1],
                                      begin: Alignment(-1.00, 0.00),
                                      end: Alignment(1.00, -0.00),
                                    ),
                                  )
                                : BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xFFB2C2C3),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                          ),
                          Text(
                            S.of(context).keep_asking,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xff707070),
                              fontSize: 11.0,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 16.0),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      onPressed: () {
                        setState(() {
                          keepAsking = false;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 20.0,
                            width: 20.0,
                            margin: const EdgeInsets.only(right: 8.0),
                            child: !keepAsking
                                ? Image.asset('lib/images/checkwhiteico.png')
                                : null,
                            decoration: !keepAsking
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    gradient: LinearGradient(
                                      colors: [
                                        kSecondaryColor,
                                        Color(0xffff7878)
                                      ],
                                      stops: [0, 1],
                                      begin: Alignment(-1.00, 0.00),
                                      end: Alignment(1.00, -0.00),
                                    ),
                                  )
                                : BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xFFB2C2C3),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                          ),
                          Text(
                            S.of(context).dont_ask_again,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xff707070),
                              fontSize: 11.0,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 26.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          if (keepAsking == false) {
                            UserController.to.setKeepAskingToDelete(false);
                          }
                          widget.onPressedDelete();
                        },
                        child: Container(
                          height: 44.0,
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: kSecondaryColor, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              S.of(context).no,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Lato',
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 16.0),
                    ),
                    Expanded(
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          if (keepAsking == false) {
                            UserController.to.setKeepAskingToDelete(false);
                          }
                          widget.onPressedOk();
                        },
                        child: Container(
                          height: 44.0,
                          decoration: BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              S.of(context).yes,
                              textScaleFactor: 1.0,
                              style: kLoginButtonTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                S.of(context).view_hidden_photos,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff707070),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
