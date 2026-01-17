import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/generated/l10n.dart' as language;
import 'package:picpics/providers/language_provider.dart';
import 'package:picpics/providers/tagged_provider.dart';
import 'package:picpics/providers/tags_provider.dart';
import 'package:picpics/screens/tabs/tagged/tagged_photo_grouping.dart';
import 'package:picpics/screens/tabs/tagged/tagged_tab_date.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/enum.dart';
import 'package:picpics/widgets/tags_list.dart';

class TaggedPicsInDeviceWithSearchOption extends ConsumerWidget {
  const TaggedPicsInDeviceWithSearchOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsState = ref.watch(tagsProvider);
    final taggedState = ref.watch(taggedProvider);
    final s = ref.watch(sProvider);

    return Column(
      children: [
        // Search results dropdown (shown when searching)
        if (tagsState.isSearching) _buildSearchDropdown(context, ref, tagsState, s),
        // Main content
        Expanded(
          child: taggedState.toggleIndexTagged == 0 ? TaggedTabDate() : const TaggedPhotosGrouping(),
        ),
      ],
    );
  }

  Widget _buildSearchDropdown(
    BuildContext context,
    WidgetRef ref,
    TagsState tagsState,
    language.S s,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (tagsState.selectedFilteringTagsKeys.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: TagsList(
              tagsKeyList: tagsState.selectedFilteringTagsKeys.keys.toList(),
              tagStyle: TagStyle.multiColored,
              onTap: (String tagKey) {
                ref.read(tagsProvider.notifier).removeTagKeyFromFiltering(tagKey);
              },
              onPanEnd: (String tagKey) {
                ref.read(tagsProvider.notifier).removeTagKeyFromFiltering(tagKey);
              },
              onDoubleTap: (String tagKey) {
                AppLogger.d('do nothing');
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            tagsState.searchText != '' ? s.search_results : s.recent_tags,
            textScaler: const TextScaler.linear(1),
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff979a9b),
              fontSize: 12,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
        ),
        if (tagsState.searchTagsResults.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: TagsList(
              tagsKeyList: tagsState.searchTagsResults.map((e) => e.key).toList(),
              tagStyle: TagStyle.grayOutlined,
              onTap: (tagKey) {
                ref.read(tagsProvider.notifier).addTagKeyForFiltering(tagKey);
              },
              onDoubleTap: (String tagKey) {
                AppLogger.d('do nothing');
              },
              onPanEnd: (String tagKey) {
                AppLogger.d('do nothing');
              },
            ),
          )
        else
          Container(
            padding: const EdgeInsets.only(top: 10, left: 26, bottom: 10),
            child: Text(
              s.no_tags_found,
              textScaler: const TextScaler.linear(1),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Lato',
                color: Color(0xff979a9b),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.4099999964237213,
              ),
            ),
          ),
        Container(
          height: 1,
          color: kLightGrayColor,
        ),
      ],
    );
  }

  String dateFormat(DateTime dateTime) {
    return DateFormat.yMMMM().format(dateTime);
  }

  Widget buildDateHeader(DateTime date, bool isSelected) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      height: 40,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 10),
            decoration: isSelected
                ? BoxDecoration(
                    gradient: kSecondaryGradient,
                    borderRadius: BorderRadius.circular(10),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
            child: isSelected ? Image.asset('lib/images/checkwhiteico.png') : null,
          ),
          Text(
            dateFormat(date),
            textScaler: const TextScaler.linear(1),
            style: const TextStyle(
              fontFamily: 'Lato',
              color: Color(0xff606566),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: -0.4099999964237213,
            ),
          ),
        ],
      ),
    );
  }
}
