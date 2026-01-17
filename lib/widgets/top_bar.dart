import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/private_photos_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/screens/settings_screen.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/widgets/secret_switch.dart';

typedef OnUntag = void Function();

class TopBar extends ConsumerWidget {
  const TopBar({
    required this.children,
    super.key,
    this.searchEditingController,
    this.showUntag = false,
    this.searchFocusNode,
    this.onUntag,
    this.onSubmitted,
    this.onChanged,
  }) : assert((searchEditingController == null
            ? (onChanged == null && onSubmitted == null)
            : (onChanged != null && onSubmitted != null)),);

  final FocusNode? searchFocusNode;
  final bool showUntag;
  final OnUntag? onUntag;
  final TextEditingController? searchEditingController;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsState = ref.watch(tagsProvider);
    final privatePhotosState = ref.watch(privatePhotosProvider);
    final s = ref.watch(sProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (searchEditingController != null)
                Expanded(
                  child: FocusScope(
                    child: Focus(
                      onFocusChange: (focus) {
                        AppLogger.d('hasFocus: $focus');
                      },
                      child: GestureDetector(
                        onTap: () {
                          if (!tagsState.isSearching) {
                            ref.read(tagsProvider.notifier).setIsSearching(true);
                            unawaited(ref.read(tagsProvider.notifier).tagsSuggestionsCalculate());
                          }
                        },
                        child: TextField(
                          controller: searchEditingController,
                          focusNode: searchFocusNode,
                          onChanged: (text) {
                            AppLogger.d('searching: $text');
                            onChanged?.call(text);
                          },
                          onSubmitted: (text) {
                            AppLogger.d('return');
                            onSubmitted?.call(text);
                            searchEditingController?.clear();
                          },
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            fontFamily: 'Lato',
                            color: Color(0xff606566),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            letterSpacing: -0.4099999964237213,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(right: 2),
                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            border: const OutlineInputBorder(borderSide: BorderSide.none),
                            prefixIcon: Image.asset('lib/images/searchico.png'),
                            hintText: s.search,
                            hintStyle: const TextStyle(
                              fontFamily: 'Lato',
                              color: kGrayColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: -0.4099999964237213,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (privatePhotosState.showPrivate)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: SecretSwitch(
                    value: privatePhotosState.showPrivate,
                    onChanged: (value) {
                      AppLogger.d('turn off');
                      ref.read(privatePhotosProvider.notifier).toggleShowPrivate();
                    },
                  ),
                ),
              if (showUntag)
                GestureDetector(
                  onTap: () {
                    onUntag?.call();
                  },
                  child: const Text('Untag'),
                )
              else
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  onPressed: () {
                    unawaited(Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => const SettingsScreen())));
                  },
                  child: Image.asset('lib/images/settings.png'),
                ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}
