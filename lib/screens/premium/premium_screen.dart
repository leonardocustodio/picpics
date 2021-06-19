import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:picPics/managers/analytics_manager.dart';
import 'package:picPics/components/arrow_painter.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:picPics/screens/premium/premium_background.dart';
import 'package:picPics/stores/user_controller.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:picPics/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:picPics/screens/tabs_screen.dart';

class PremiumScreen extends StatefulWidget {
  static const id = 'premium_screen';

  @override
  _PremiumScreenState createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final _items = <Package>[];
  bool isLoading = false;
  PurchasesErrorCode? getOfferingError;

  void showError({required String title, required String description}) {
    setState(() {
      isLoading = false;
    });

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return PlatformAlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(description),
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

  void getOffers() async {
    try {
      var offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current.availablePackages.isNotEmpty) {
        getOfferingError = null;

        //print(offerings.current.availablePackages);
        //print(offerings.getOffering("full_subscription").availablePackages);

        setState(() {
          _items = offerings.getOffering('full_subscription').availablePackages;
        });

        for (var item in _items) {
          await Analytics.sendPresentOffer(
            itemId: item.product.identifier,
            itemName: item.product.title,
            itemCategory: item.packageType == PackageType.annual
                ? 'Annual Subscription'
                : 'Monthly Subscription',
            quantity: 1,
            price: item.product.price,
            currency: item.product.currencyCode,
          );
        }

        if (UserController.to.tryBuyId != null) {
          var getPackage = _items.firstWhere(
              (element) => element.product.identifier == UserController.to.tryBuyId,
              orElse: () => null);

          if (getPackage != null) {
            //print(getPackage);
            //print('making purchase!!!');
            makePurchase(context, getPackage);

            appStore.setTryBuyId(null);
          }
        }
      }
    } catch (e) {
      makePurchase(context, null);
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      //print('#### Error Code: ${errorCode}');
      /* setState(() {
        getOfferingError = errorCode;
      }); */
    }
  }

  void makePurchase(BuildContext context, Package package) async {
    // TODO: remove true
    if (true || kDebugMode) {
      appStore.setIsPremium(true);
      await UserController.to.setTutorialCompleted(true);
      await Get.offNamedUntil(TabsScreen.id, (route) => false);
      //Navigator.pushNamedAndRemoveUntil(context, TabsScreen.id, (route) => false);
      // Get.back();
      //return;
    } else {
      setState(() {
        isLoading = true;
      });
      await Analytics.sendBeginCheckout(
        currency: package.product.currencyCode,
        price: package.product.price,
      );

      try {
        var purchaserInfo = await Purchases.purchasePackage(package);

        if (purchaserInfo.entitlements.all['Premium'] != null) {
          if (purchaserInfo.entitlements.all['Premium'].isActive) {
            // Unlock that great "pro" content
            setState(() {
              isLoading = false;
            });

            await Analytics.sendPurchase(
              currency: package.product.currencyCode,
              price: package.product.price,
            );
            appStore.setIsPremium(true);
            // Get.back();
            await Navigator.pushNamedAndRemoveUntil(
                context, TabsScreen.id, (route) => false);
            return;
          }
        }
        showError(
            title: 'Error has occurred',
            description: 'An error has occurred, please try again!');
      } on PlatformException catch (e) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          showError(
              title: 'Error has occurred',
              description: 'An error has occurred, please try again!');
        }
      }
    }
  }

  void restorePurchase() async {
    setState(() {
      isLoading = true;
    });

    try {
      var restoredInfo = await Purchases.restoreTransactions();
      // ... check restored purchaserInfo to see if entitlement is now active
      if (restoredInfo.entitlements.all['Premium'] != null) {
        if (restoredInfo.entitlements.all['Premium'].isActive) {
          setState(() {
            isLoading = false;
          });
          // Unlock that great "pro" content
          //print('know you are fucking pro!');
          appStore.setIsPremium(true);
          // Get.back();
          await Navigator.pushNamedAndRemoveUntil(
              context, TabsScreen.id, (route) => false);
          return;
        }
      }
      showError(
          title: S.of(context).no_previous_purchase,
          description: S.of(context).no_valid_subscription);
    } on PlatformException catch (e) {
      //print(e);
      showError(
          title: 'Error has occurred',
          description: 'An error has occurred, please try again!');
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      //print('Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
    Analytics.sendCurrentScreen(Screen.premium_screen);
    getOffers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _premiumBenefits(BuildContext context) {
    //    var isPremium = DatabaseManager.instance.userSettings.isPremium;

    var widgets = <Widget>[
      // Spacer(
      //   flex: 1,
      // ),

      // Text(
      //   S.of(context).get_premium_title,
      //   textScaleFactor: 1.0,
      //   maxLines: 2,
      //   textAlign: TextAlign.left,
      //   overflow: TextOverflow.visible,
      //   style: const TextStyle(
      //     color: kPinkColor,
      //     fontWeight: FontWeight.w400,
      //     fontFamily: "Lato",
      //     fontStyle: FontStyle.normal,
      //     fontSize: 36.0,
      //   ),
      // ),
      // SizedBox(
      //   height: 12.0,
      // ),
      // Flexible(
      //   child: Text(
      //     S.of(context).get_premium_description,
      //     maxLines: 2,
      //     textAlign: TextAlign.left,
      //     textScaleFactor: 1.0,
      //     overflow: TextOverflow.visible,
      //     style: TextStyle(
      //       color: kPrimaryColor.withOpacity(0.8),
      //       fontWeight: FontWeight.w400,
      //       fontFamily: "Lato",
      //       fontStyle: FontStyle.normal,
      //       fontSize: 18.0,
      //     ),
      //   ),
      // ),
      // Spacer(
      //   flex: 4,
      // ),
      Padding(
        padding: const EdgeInsets.only(left: 18.0, bottom: 21.0),
        child: Row(
          children: <Widget>[
            Image.asset('lib/images/pinkstar.png'),
            SizedBox(
              width: 16.0,
            ),
            Flexible(
              child: Text(
                'Fast find all your memories',
                textScaleFactor: 1.0,
                maxLines: 2,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff707070),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
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
            Flexible(
              child: Text(
                S.of(context).unlimited_private_pics,
                textScaleFactor: 1.0,
                maxLines: 2,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff707070),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.only(left: 18.0, bottom: 21.0),
      //   child: Row(
      //     children: <Widget>[
      //       Image.asset('lib/images/pinkstar.png'),
      //       SizedBox(
      //         width: 16.0,
      //       ),
      //       Flexible(
      //         child: Text(
      //           S.of(context).no_ads,
      //           textScaleFactor: 1.0,
      //           maxLines: 2,
      //           textAlign: TextAlign.left,
      //           style: TextStyle(
      //             fontFamily: 'Lato',
      //             color: Color(0xff707070),
      //             fontSize: 16,
      //             fontWeight: FontWeight.w400,
      //             fontStyle: FontStyle.normal,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      Padding(
        padding: const EdgeInsets.only(left: 18.0, bottom: 21.0),
        child: Row(
          children: <Widget>[
            Image.asset('lib/images/pinkstar.png'),
            SizedBox(
              width: 16.0,
            ),
            Flexible(
              child: Text(
                S.of(context).infinite_tags,
                maxLines: 2,
                textAlign: TextAlign.left,
                textScaleFactor: 1.0,
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff707070),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
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
            Flexible(
              child: Text(
                S.of(context).tag_multiple_photos_at_once,
                textScaleFactor: 1.0,
                maxLines: 2,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xff707070),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.only(left: 18.0),
      //   child: Row(
      //     children: <Widget>[
      //       Image.asset('lib/images/pinkstar.png'),
      //       SizedBox(
      //         width: 16.0,
      //       ),
      //       Flexible(
      //         child: Text(
      //           S.of(context).cancel_anytime,
      //           maxLines: 2,
      //           textAlign: TextAlign.left,
      //           textScaleFactor: 1.0,
      //           style: TextStyle(
      //             fontFamily: 'Lato',
      //             color: Color(0xff707070),
      //             fontSize: 16,
      //             fontWeight: FontWeight.w400,
      //             fontStyle: FontStyle.normal,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // Spacer(
      //   flex: 4,
      // ),
    ];

    return widgets;
  }

  List<Widget> _renderInAppPurchase(BuildContext context) {
    if (getOfferingError != null) {
      return [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Center(
            child: Text(
              'Um erro ocorreu ao tentar se conectar a loja, por favor, tente novamente mais tarde.',
              textScaleFactor: 1.0,
              textAlign: TextAlign.center,
              style: kPremiumButtonTextStyle,
            ),
          ),
        )
      ];
    }

    if (_items.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(bottom: 32.0, top: 32.0),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
            ),
          ),
        )
      ];
    }

    var yearSub = _items.firstWhere((e) => e.packageType == PackageType.annual,
        orElse: null);

    //print(yearSub);
    var daysFree = yearSub.product.introductoryPrice == null
        ? 3
        : yearSub.product.introductoryPrice.introPricePeriodNumberOfUnits;

    return [
      Container(
        width: double.maxFinite,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Try $daysFree days for free\n',
                style: const TextStyle(
                  color: const Color(0xff606566),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato',
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0,
                ),
              ),
              TextSpan(
                text:
                    'Then ${yearSub.product.priceString}/${S.of(context).year}',
                style: const TextStyle(
                  color: const Color(0xff606566),
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Lato',
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
      // Spacer(
      //   flex: 1,
      // ),
      CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        onPressed: () {
          makePurchase(context, yearSub);
        },
        child: Container(
          height: 95.0,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 19,
                left: 0,
                right: 0,
                child: Container(
                  height: 65.0,
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      'Subscribe Now',
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Lato',
                        color: kWhiteColor,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      ),
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
                        'Special Offer',
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
      // Spacer(
      //   flex: 2,
      // ),
      CupertinoButton(
        // padding: const EdgeInsets.all(0),
        onPressed: () {
          restorePurchase();
          // makePurchase(context, yearSubs);
        },
        child: Center(
          child: Text(
            S.of(context).restore_purchase,
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Lato',
              color: kPinkColor,
              fontSize: 13.0,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      ),
    ];
  }

  Widget _renderInApps(BuildContext context) {
//    Error fetching offerings - PurchasesError(code=StoreProblemError, underlyingErrorMessage=Error when fetching products. DebugMessage: An internal error occurred.. ErrorCode: SERVICE_UNAVAILABLE., message='There was a problem with the Play Store.')

    if (getOfferingError != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Center(
          child: Text(
            'Um erro ocorreu ao tentar se conectar a loja, por favor, tente novamente mais tarde.',
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style: kPremiumButtonTextStyle,
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
          ),
        ),
      );
    }

    var yearSubs = _items.firstWhere((e) => e.packageType == PackageType.annual,
        orElse: null);
    var monthSubs = _items
        .firstWhere((e) => e.packageType == PackageType.monthly, orElse: null);

    var save =
        100 - (yearSubs.product.price / (monthSubs.product.price * 12) * 100);
    //print('Save: $save');

    return Column(
      children: [
        Row(
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
                      '${S.of(context).sign} ${monthSubs.product.priceString}\n${S.of(context).month}',
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style:
                          kPremiumButtonTextStyle.copyWith(color: kWhiteColor),
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
                              '${S.of(context).sign} ${yearSubs.product.priceString}\n${S.of(context).year}',
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            height: 24.0,
                            child: Center(
                              child: Text(
                                '   ${S.of(context).save} ${save.round()}%',
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
        ),
        Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: S.of(context).auto_renewable_first_part,
                  style: const TextStyle(
                    color: const Color(0xff606566),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Lato',
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0,
                  ),
                ),
                TextSpan(
                  text: S.of(context).auto_renewable_second_part,
                  style: const TextStyle(
                    color: const Color(0xff606566),
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Lato',
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStore = UserController.to;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: <Widget>[
            PremiumBackground(),
            SafeArea(
              bottom: false,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Image.asset('lib/images/backarrowgray.png'),
                      ),
                      // Image.asset('lib/images/picpicssmallred.png'),
                      // Opacity(
                      //   opacity: 0,
                      //   child: CupertinoButton(
                      //     onPressed: null,
                      //     child: Image.asset('lib/images/backarrowgray.png'),
                      //   ),
                      // ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      // padding: const EdgeInsets.symmetric(
                      //   horizontal: 24.0,
                      //   vertical: 4.0,
                      // ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Stack(
                          //   children: [
                          //     ClipRect(
                          //       child: Container(
                          //         child: Align(
                          //           alignment: Alignment.topLeft,
                          //           widthFactor: 1.0,
                          //           heightFactor: 0.60,
                          //           child: Lottie.asset(
                          //             'lib/anims/2523-loading.json',
                          //             width:
                          //                 MediaQuery.of(context).size.width,
                          //             fit: BoxFit.fill,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //     Positioned(
                          //       top: 0,
                          //       right: 20,
                          //       child: Container(
                          //         height: 80.0,
                          //         child: Image.asset(
                          //             'lib/images/bigpremiumlogo.png'),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: [
                          //     Image.asset('lib/images/bigpremiumlogo.png'),
                          //     Spacer(),
                          //     Lottie.asset(
                          //       'lib/anims/2523-loading.json',
                          //       width: 200,
                          //       height: 200,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ],
                          // ),
                          // Center(
                          //     child: Image.asset(
                          //         'lib/images/picpicssmallred.png')),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   children: [
                          //     Image.asset('lib/images/bigpremiumlogo.png'),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: MediaQuery.of(context).size.height / 3,
                          // ),

                          // Spacer(
                          //   flex: 2,
                          // ),
                          Spacer(
                            flex: 1,
                          ),
                          ...this._premiumBenefits(context),
                          ...this._renderInAppPurchase(context),
                          // this._renderInApps(context),
                          // Spacer(
                          //   flex: 2,
                          // ),
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
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CupertinoButton(
                              onPressed: () {
                                _launchURL('https://picpics.link/e/privacy');
                              },
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              minSize: 32.0,
                              child: Text(
                                S.of(context).privacy_policy,
                                style: const TextStyle(
                                  color: const Color(0xff606566),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Lato',
                                  fontStyle: FontStyle.normal,
                                  decoration: TextDecoration.underline,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            Text(
                              '  &   ',
                              style: const TextStyle(
                                color: const Color(0xff606566),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Lato',
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0,
                              ),
                            ),
                            CupertinoButton(
                              onPressed: () {
                                _launchURL('https://picpics.link/e/terms');
                              },
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              minSize: 32.0,
                              child: Text(
                                S.of(context).terms_of_use,
                                style: const TextStyle(
                                  color: const Color(0xff606566),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Lato',
                                  fontStyle: FontStyle.normal,
                                  decoration: TextDecoration.underline,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: SpinKitChasingDots(
                    color: kPrimaryColor,
                    size: 80.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
