import 'package:flutter/cupertino.dart';
import 'package:picPics/constants.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class SecretSwitch extends StatefulWidget {
  final bool value;
  final Function onChanged;

  const SecretSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  _SecretSwitchState createState() => _SecretSwitchState();
}

class _SecretSwitchState extends State<SecretSwitch> with AnimationMixin {
  Control control = Control.play;
  bool goingRight = true;
  late bool initRight;
  late bool positionRight;

  @override
  void initState() {
    super.initState();
    initRight = widget.value;
    positionRight = widget.value;
  }

  void toggleDirection() {
    setState(() {
      goingRight = !goingRight;
      positionRight = widget.value;
      control = (control == Control.play ? Control.playReverse : Control.play);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != positionRight) {
      toggleDirection();
    }
    return Stack(
      children: [
        CupertinoSwitch(
          value: widget
              .value, // Provider.of<DatabaseManager>(context).userSettings.dailyChallenges,
          activeTrackColor: kYellowColor,
          onChanged: (value) {
            widget.onChanged(value);
          },
        ),
        CustomAnimationBuilder<double>(
          control: control,
          tween: (-11.0).tweenTo(11.0),
          duration: 200.milliseconds,
          curve: goingRight ? Curves.easeOutCubic : Curves.easeInCubic,
          builder: (context, value, _) {
            return Positioned(
              right: 25 + (initRight ? -value : value),
              top: 12,
              child: Image.asset('lib/images/lockcupertinogray.png'),
            );
          },
        ),
      ],
    );
  }
}
