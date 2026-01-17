import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/pin_provider_full.dart';
import 'package:picpics/providers/user_provider.dart';
import 'package:picpics/screens/pin_screen.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/color_animated_background.dart';

class EmailScreen extends ConsumerStatefulWidget {
  const EmailScreen({super.key});
  static const String id = 'email_screen';

  @override
  ConsumerState<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends ConsumerState<EmailScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> startRegistration() async {
    final pinState = ref.read<PinFullState>(pinFullProvider);
    final isValid = EmailValidator.validate(pinState.email);

    if (!isValid) {
      await ref.read<PinFullNotifier>(pinFullProvider.notifier).showErrorModal(
            context,
            'Please type a valid e-mail address to proceed.',
          );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await ref.read<PinFullNotifier>(pinFullProvider.notifier).register();

    setState(() {
      isLoading = false;
    });

    if (result['success'] == true) {
      ref.read<UserNotifier>(userProvider.notifier).setWaitingAccessCode(true);
      if (mounted) {
        await Navigator.of(context).pushNamed(PinScreen.id);
      }
    } else {
      AppLogger.d('Result: $result');
      if ((result['errorCode'] as FirebaseAuthException).code == 'email-already-in-use') {
        if (mounted) {
          await ref.read<PinFullNotifier>(pinFullProvider.notifier).showErrorModal(
                context,
                'This e-mail is already in use by another account.',
              );
        }
        AppLogger.d('Error !!!');
      } else {
        if (mounted) {
          await ref.read<PinFullNotifier>(pinFullProvider.notifier).showErrorModal(
                context,
                'An error has occured. Please try again!',
              );
        }
        AppLogger.d('Error !!!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final s = ref.watch(sProvider);
    AppLogger.d('Height: ${size.height} - Width: ${size.width}');

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Stack(
          children: <Widget>[
            const ColorAnimatedBackground(
              moveByX: 60,
              moveByY: 40,
              blurFilter: false,
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 10,
                        ),
                        onPressed: () {
                          ref.read(userProvider.notifier).setWaitingAccessCode(false);
                          Navigator.of(context).pop();
                        },
                        child: Image.asset('lib/images/backarrowwithdropshadow.png'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            s.confirm_email,
                            style: TextStyle(
                              fontFamily: 'Lato',
                              color: kWhiteColor,
                              fontSize: size.width < 400 ? 22.0 : 28.0,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 32,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.email,
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    color: Color(0xff606566),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.normal,
                                    letterSpacing: -0.4099999964237213,
                                  ),
                                ),
                                Container(
                                  height: 42,
                                  margin: const EdgeInsets.only(top: 6),
                                  child: TextField(
                                    onChanged: (value) {
                                      ref.read<PinFullNotifier>(pinFullProvider.notifier).setEmail(value);
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                        left: 10,
                                        right: 5,
                                      ),
                                      fillColor: const Color(0xFFF1F3F5).withValues(alpha: 0.3),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE2E4E5),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE2E4E5),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFFE2E4E5),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(flex: 2),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: startRegistration,
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                gradient: kPrimaryGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  s.continue_string,
                                  textScaler: TextScaler.noScaling,
                                  style: kLoginButtonTextStyle,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              ColoredBox(
                color: Colors.black.withValues(alpha: 0.7),
                child: const Center(
                  child: SpinKitChasingDots(
                    color: kPrimaryColor,
                    size: 80,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
