import 'package:flutter/cupertino.dart';
import 'package:picPics/constants.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class SecretSwitch extends StatefulWidget {
  final bool value;
  final Function onChanged;

  SecretSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  _SecretSwitchState createState() => _SecretSwitchState();
}

class _SecretSwitchState extends State<SecretSwitch> with AnimationMixin {
  CustomAnimationControl control = CustomAnimationControl.PLAY;
  bool goingRight = true;
  bool initRight;
  bool positionRight;

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
      control = (control == CustomAnimationControl.PLAY)
          ? CustomAnimationControl.PLAY_REVERSE
          : CustomAnimationControl.PLAY;
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
          activeColor: kYellowColor,
          onChanged: (value) {
            widget.onChanged(value);
          },
        ),
        CustomAnimation<double>(
          control: control,
          tween: (-11.0).tweenTo(11.0),
          duration: 200.milliseconds,
          curve: goingRight ? Curves.easeOutCubic : Curves.easeInCubic,
          builder: (context, child, value) {
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
