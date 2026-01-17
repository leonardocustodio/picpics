import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tabs_provider.dart';

class NoTaggedPicsInDevice extends ConsumerWidget {
  const NoTaggedPicsInDevice({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(sProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Image.asset('lib/images/notaggedphotos.png'),
        ),
        const SizedBox(
          height: 21,
        ),
        Text(
          s.no_tagged_photos,
          textScaler: TextScaler.noScaling,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Lato',
            color: Color(0xff979a9b),
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        const SizedBox(
          height: 17,
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => ref.read(tabsProvider.notifier).setCurrentTab(1),
          child: Container(
            width: 201,
            height: 44,
            decoration: BoxDecoration(
              gradient: kPrimaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                s.start_tagging,
                textScaler: TextScaler.noScaling,
                style: const TextStyle(
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
      ],
    );
  }
}
