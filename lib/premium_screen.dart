import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picPics/components/arrow_painter.dart';
import 'package:picPics/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class PremiumScreen extends StatefulWidget {
  static const id = 'premium_screen';

  @override
  _PremiumScreenState createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;

  final List<String> _subscriptionsLists = Platform.isAndroid
      ? [
          'rs9_90_monthly_subscription',
          'rs99_90_yearly_subscription',
        ]
      : [
          'rs9_90_monthly_subscription',
          'rs99_90_yearly_subscription',
        ];

  String _platformVersion = 'Unknown';
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];

  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_conectionSubscription != null) {
      _conectionSubscription.cancel();
      _conectionSubscription = null;
    }
  }

  void asyncInitState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterInappPurchase.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // prepare
    var result = await FlutterInappPurchase.instance.initConnection;
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    _getSubscriptions();

    // refresh items for android
//    try {
//      String msg = await FlutterInappPurchase.instance.consumeAllItems;
//      print('find items: $msg');
//
////      await FlutterInappPurchase.instance.getSubscriptions(skus)
//
//    } catch (err) {
//      print('consumeAllItems error: $err');
//    }

    _conectionSubscription = FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      print('purchase-updated: $productItem');
    });

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
    });
  }

  Future _getSubscriptions() async {
    List<IAPItem> items = await FlutterInappPurchase.instance.getSubscriptions(_subscriptionsLists);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }

    setState(() {
      this._items = items;
      this._purchases = [];
    });
  }

  Future _getPurchaseHistory() async {
    List<PurchasedItem> items = await FlutterInappPurchase.instance.getPurchaseHistory();
    for (var item in items) {
      print('${item.toString()}');
      this._purchases.add(item);
    }

    setState(() {
      this._items = [];
      this._purchases = items;
    });
  }

  void _requestPurchase(IAPItem item) {
    FlutterInappPurchase.instance.requestPurchase(item.productId);
  }

  List<Widget> _renderInApps() {
    List<Widget> widgets = [
      Spacer(
        flex: 1,
      ),
      Image.asset('lib/images/bigpremiumlogo.png'),
      Text(
        "Get Premium",
        style: TextStyle(
          fontFamily: 'Lato',
          color: kPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.4099999964237213,
        ),
      ),
      Text(
        "ONE-YEAR PREMIUM ACCOUNT",
        style: TextStyle(
          fontFamily: 'Lato',
          color: kPrimaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      ),
      Spacer(
        flex: 3,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 18.0, bottom: 21.0),
        child: Row(
          children: <Widget>[
            Image.asset('lib/images/starrateapp.png'),
            SizedBox(
              width: 16.0,
            ),
            Text(
              "No Ads!",
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
            Image.asset('lib/images/starrateapp.png'),
            SizedBox(
              width: 16.0,
            ),
            Text(
              "Export all galery",
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
            Image.asset('lib/images/starrateapp.png'),
            SizedBox(
              width: 16.0,
            ),
            Text(
              "Infinite Tags",
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
            Image.asset('lib/images/starrateapp.png'),
            SizedBox(
              width: 16.0,
            ),
            Text(
              "Multiple select to tag",
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
        flex: 5,
      ),
      // Add buttons (position 10)
      Spacer(
        flex: 1,
      ),
    ];

    if (_items.length == 0) {
      widgets.insert(
          10,
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
          ));

      return widgets;
    }

    var yearSubs = _items.firstWhere((e) => e.subscriptionPeriodUnitIOS == 'YEAR');
    var monthSubs = _items.firstWhere((e) => e.subscriptionPeriodUnitIOS == 'MONTH');

    double monthPrice = double.parse(monthSubs.price);
    double yearPrice = double.parse(yearSubs.price);
    double save = 100 - (yearPrice / (monthPrice * 12) * 100);
    print('Save: $save');

    widgets.insert(
      10,
      Column(
        children: <Widget>[
          CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              this._requestPurchase(yearSubs);
            },
            child: Container(
              height: 63.0,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 19,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 44.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: kPinkColor, width: 1.0),
                      ),
                      child: Center(
                        child: Text(
                          "Sign ${yearSubs.localizedPrice}/year",
                          style: TextStyle(
                            fontFamily: 'Lato',
                            color: kPinkColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.4099999964237213,
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
                        width: 69.0,
                        height: 24.0,
                        child: Center(
                          child: Text(
                            "   save ${save.round()}%",
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
          SizedBox(
            height: 16.0,
          ),
          CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              this._requestPurchase(monthSubs);
            },
            child: Container(
              height: 44.0,
              decoration: BoxDecoration(
                gradient: kPrimaryGradient,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  "Sign ${monthSubs.localizedPrice}/month",
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
          SizedBox(
            height: 16.0,
          ),
          Text(
            "Restaurar compra",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: kPrimaryColor,
              decoration: TextDecoration.underline,
              fontFamily: "Lato",
              fontStyle: FontStyle.normal,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Color(0xffff6666),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: new BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFFF5FAFA).withOpacity(0.76),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: this._renderInApps(),
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
            ),
          ),
        ),
      ),
    );
  }
}
