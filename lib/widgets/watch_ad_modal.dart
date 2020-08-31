import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/constants.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:picPics/stores/app_store.dart';
import 'package:provider/provider.dart';

class WatchAdModal extends StatelessWidget {
  final Function onPressedWatchAdd;
  final Function onPressedGetPremium;

  WatchAdModal({
    this.onPressedWatchAdd,
    this.onPressedGetPremium,
  });

  @override
  Widget build(BuildContext context) {
    final AppStore appStore = Provider.of<AppStore>(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            width: 343.0,
            height: 379.0,
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: <Widget>[
                Spacer(),
                Image.asset('lib/images/bigpremiumlogo.png'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 52.0, vertical: 32.0),
                  child: Text(
                    S.of(context).premium_modal_description(appStore.dailyPicsForAds),
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: 16,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: onPressedWatchAdd,
                    child: Container(
                      height: 44.0,
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          S.of(context).premium_modal_watch_ad,
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
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0, top: 17.0),
                  child: CupertinoButton(
                    onPressed: onPressedGetPremium,
                    padding: const EdgeInsets.all(0),
                    child: OutlineGradientButton(
                      child: Container(
                        height: 44.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              S.of(context).premium_modal_get_premium_title,
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Lato",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              S.of(context).premium_modal_get_premium_description,
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 12,
                                fontFamily: 'Lato',
                              ),
                            ),
                          ],
                        ),
                      ),
                      gradient: LinearGradient(colors: [Color(0xFFFFA4D1), Color(0xFFFFCC00)]),
                      strokeWidth: 2.0,
                      radius: Radius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: CupertinoButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Image.asset('lib/images/closegrayico.png'),
            ),
          ),
        ],
      ),
    );
  }
}
