import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/user_provider.dart';
import 'package:picpics/utils/app_logger.dart';

class DeleteSecretModal extends ConsumerStatefulWidget {
  const DeleteSecretModal({
    required this.onPressedClose,
    required this.onPressedDelete,
    required this.onPressedOk,
    super.key,
  });
  final void Function() onPressedClose;
  final void Function() onPressedDelete;
  final void Function() onPressedOk;

  @override
  ConsumerState<DeleteSecretModal> createState() => _DeleteSecretModalState();
}

class _DeleteSecretModalState extends ConsumerState<DeleteSecretModal> {
  bool keepAsking = true;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final s = ref.watch(sProvider);
    AppLogger.d('Width: $width');

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding:
          width < 360 ? const EdgeInsets.symmetric(horizontal: 20) : const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          color: Color(0xFFF1F3F5),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(14),
            bottom: Radius.circular(19),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: 0,
                    child: CupertinoButton(
                      onPressed: () {
                        AppLogger.d('teste');
                      },
                      child: Image.asset('lib/images/closegrayico.png'),
                    ),
                  ),
                  Text(
                    s.secret_photos,
                    style: const TextStyle(
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
                padding: const EdgeInsets.symmetric(vertical: 44),
                child: Image.asset('lib/images/lockmodalico.png'),
              ),
              Text(
                s.keep_safe,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff707070),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      onPressed: () {
                        setState(() {
                          keepAsking = true;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: keepAsking
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        kSecondaryColor,
                                        Color(0xffff7878),
                                      ],
                                      stops: [0, 1],
                                      end: Alignment(1, -0),
                                    ),
                                  )
                                : BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFB2C2C3),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                            child: keepAsking ? Image.asset('lib/images/checkwhiteico.png') : null,
                          ),
                          Text(
                            s.keep_asking,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xff707070),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 16),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      onPressed: () {
                        setState(() {
                          keepAsking = false;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: !keepAsking
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        kSecondaryColor,
                                        Color(0xffff7878),
                                      ],
                                      stops: [0, 1],
                                      end: Alignment(1, -0),
                                    ),
                                  )
                                : BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFB2C2C3),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                            child: !keepAsking ? Image.asset('lib/images/checkwhiteico.png') : null,
                          ),
                          Text(
                            s.dont_ask_again,
                            style: const TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xff707070),
                              fontSize: 11,
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
                padding: const EdgeInsets.only(bottom: 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (!keepAsking) {
                            ref.read(userProvider.notifier).setKeepAskingToDelete(value: false);
                          }
                          widget.onPressedDelete();
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border.all(color: kSecondaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              s.no,
                              textScaler: TextScaler.noScaling,
                              style: const TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Lato',
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 16),
                    ),
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (!keepAsking) {
                            ref.read(userProvider.notifier).setKeepAskingToDelete(value: false);
                          }
                          widget.onPressedOk();
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: kPrimaryGradient,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              s.yes,
                              textScaler: TextScaler.noScaling,
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
                s.view_hidden_photos,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
