import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:picPics/components/arrow_painter.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/database_manager.dart';
import 'package:platform_alert_dialog/platform_alert_dialog.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:picPics/generated/l10n.dart';

class PremiumScreen extends StatefulWidget {
  static const id = 'premium_screen';

  @override
  _PremiumScreenState createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  List<Package> _items = [];
  bool isLoading = false;

  void getOffers() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null && offerings.current.availablePackages.isNotEmpty) {
        print(offerings.current.availablePackages);
        setState(() {
          _items = offerings.current.availablePackages;
        });
      }
    } on PlatformException catch (e) {
      // optional error handling
    }
  }

  void makePurchase(BuildContext context, Package package) async {
    setState(() {
      isLoading = true;
    });

    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      if (purchaserInfo.entitlements.all["Premium"].isActive) {
        // Unlock that great "pro" content
        setState(() {
          isLoading = false;
        });

        print('know you are fucking pro!');
        DatabaseManager.instance.setUserAsPremium();
        Navigator.pop(context);
      }
    } on PlatformException catch (e) {
      setState(() {
        isLoading = false;
      });

      var errorCode = PurchasesErrorHelper.getErrorCode(e);
//      print('Error Code: $errorCode');
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print(e);
//        showError(e);
      }
    }
  }

  void restorePurchase() async {
    setState(() {
      isLoading = true;
    });

    try {
      PurchaserInfo restoredInfo = await Purchases.restoreTransactions();
      // ... check restored purchaserInfo to see if entitlement is now active
      if (restoredInfo.entitlements.all["Premium"].isActive) {
        setState(() {
          isLoading = false;
        });
        // Unlock that great "pro" content
        print('know you are fucking pro!');
        DatabaseManager.instance.setUserAsPremium();
        Navigator.pop(context);
      } else {
        setState(() {
          isLoading = false;
        });

        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return PlatformAlertDialog(
              title: Text(S.of(context).no_previous_purchase),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(S.of(context).no_valid_subscription),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                PlatformDialogAction(
                  child: Text(S.of(context).ok),
                  actionType: ActionType.Preferred,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } on PlatformException catch (e) {
      // Error restoring purchases
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getOffers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _premiumBenefits(BuildContext context) {
    //    var isPremium = DatabaseManager.instance.userSettings.isPremium;

    List<Widget> widgets = [
      Spacer(
        flex: 1,
      ),
      Text(
        S.of(context).get_premium_title,
        textScaleFactor: 1.0,
        style: const TextStyle(
          color: kPinkColor,
          fontWeight: FontWeight.w400,
          fontFamily: "Lato",
          fontStyle: FontStyle.normal,
          fontSize: 36.0,
        ),
      ),
      SizedBox(
        height: 12.0,
      ),
      Text(
        S.of(context).get_premium_description,
        style: TextStyle(
          color: kPrimaryColor.withOpacity(0.8),
          fontWeight: FontWeight.w400,
          fontFamily: "Lato",
          fontStyle: FontStyle.normal,
          fontSize: 18.0,
        ),
      ),
      Spacer(
        flex: 4,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 18.0, bottom: 21.0),
        child: Row(
          children: <Widget>[
            Image.asset('lib/images/pinkstar.png'),
            SizedBox(
              width: 16.0,
            ),
            Text(
              S.of(context).no_ads,
              textScaleFactor: 1.0,
              style: TextStyle(
                fontFamily: 'Lato',
                color: Color(0xff707070),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 18.0, bottom: 21.0),
        child: Row(
          children: <Widget>[
            Image.asset('lib/images/pinkstar.png'),
            SizedBox(
              width: 16.0,
            ),
            Text(
              S.of(context).infinite_tags,
              textScaleFactor: 1.0,
              style: TextStyle(
                fontFamily: 'Lato',
                color: Color(0xff707070),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 18.0, bottom: 21.0),
        child: Row(
          children: <Widget>[
            Image.asset('lib/images/pinkstar.png'),
            SizedBox(
              width: 16.0,
            ),
            Text(
              S.of(context).tag_multiple_photos_at_once,
              textScaleFactor: 1.0,
              style: TextStyle(
                fontFamily: 'Lato',
                color: Color(0xff707070),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Row(
          children: <Widget>[
            Image.asset('lib/images/pinkstar.png'),
            SizedBox(
              width: 16.0,
            ),
            Text(
              'Cancel anytime',
              textScaleFactor: 1.0,
              style: TextStyle(
                fontFamily: 'Lato',
                color: Color(0xff707070),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
      Spacer(
        flex: 4,
      ),
    ];

    return widgets;
  }

  Widget _renderInApps(BuildContext context) {
    if (_items.length == 0) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
      );
    }

    var yearSubs = _items.firstWhere((e) => e.packageType == PackageType.annual, orElse: null);
    var monthSubs = _items.firstWhere((e) => e.packageType == PackageType.monthly, orElse: null);

    double save = 100 - (yearSubs.product.price / (monthSubs.product.price * 12) * 100);
    print('Save: $save');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              makePurchase(context, monthSubs);
            },
            child: Container(
              height: 65.0,
              decoration: BoxDecoration(
                gradient: kPrimaryGradient,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  "${S.of(context).sign} ${monthSubs.product.priceString}\n${S.of(context).month}",
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: kPremiumButtonTextStyle.copyWith(color: kWhiteColor),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              makePurchase(context, yearSubs);
            },
            child: Container(
              height: 102.0,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 19,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 65.0,
                      decoration: BoxDecoration(
                        color: Color(0x4cffffff),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: kPinkColor, width: 1.0),
                      ),
                      child: Center(
                        child: Text(
                          "${S.of(context).sign} ${yearSubs.product.priceString}\n${S.of(context).year}",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: kPremiumButtonTextStyle,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 6,
                    child: CustomPaint(
                      painter: ArrowPainter(
                        strokeColor: kYellowColor,
                        strokeWidth: 10,
                        paintingStyle: PaintingStyle.fill,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        height: 24.0,
                        child: Center(
                          child: Text(
                            "   ${S.of(context).save} ${save.round()}%",
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: Color(0xff606566),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(),
              decoration: new BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5FAFA).withOpacity(0.76),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CupertinoButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset('lib/images/backarrowgray.png'),
                          ),
                          CupertinoButton(
                            onPressed: () {
                              restorePurchase();
                            },
                            child: Text(
                              S.of(context).restore_purchase,
                              textScaleFactor: 1.0,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xff979a9b),
                                decoration: TextDecoration.underline,
                                fontFamily: "Lato",
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                                letterSpacing: -0.4099999964237213,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 4.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ...this._premiumBenefits(context),
                              this._renderInApps(context),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          style: const TextStyle(
                                              color: const Color(0xff606566),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Lato",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0),
                                          text: "The subscription is "),
                                      TextSpan(
                                          style: const TextStyle(
                                              color: const Color(0xff606566),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Lato",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0),
                                          text: "auto-renewable.")
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(
                                flex: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 24.0),
                        decoration: BoxDecoration(
                          color: Color(0x99ffffff),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            topRight: Radius.circular(12.0),
                          ),
                        ),
                        child: SafeArea(
                          top: false,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              "Privacy Policy & Terms of use",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: const Color(0xff606566),
                                fontWeight: FontWeight.w600,
                                fontFamily: "Lato",
                                fontStyle: FontStyle.normal,
                                fontSize: 9.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Loading(indicator: BallPulseIndicator(), size: 100.0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
