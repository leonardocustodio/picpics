import 'package:flutter/material.dart';
import 'package:picPics/screens/premium/premium_colorful.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:lottie/lottie.dart';

class PremiumBackground extends StatefulWidget {
  PremiumBackground();

  @override
  _PremiumBackgroundState createState() => _PremiumBackgroundState();
}

class _PremiumBackgroundState extends State<PremiumBackground>
    with AnimationMixin {
  var scrollController = ScrollController(initialScrollOffset: 100);
/* 
  @override
  void initState() {
    super.initState();
  } */

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Transform.scale(
          scale: 1.4,
          child: Lottie.asset(
            'lib/anims/2523-loading.json',
            width: MediaQuery.of(context).size.width * 3 / 2,
            fit: BoxFit.fill,
          ),
        ),
        // SingleChildScrollView(
        //   controller: scrollController,
        //   scrollDirection: Axis.horizontal,
        //   child:
        // ),
        ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: CustomPaint(
            painter: ColorfulPremium(
              withOpacity: 0.8,
            ),
          ),
        ),
      ],
    );
  }
}
