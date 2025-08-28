import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/providers/tabs_provider.dart';
import 'package:picpics/providers/user_provider.dart';

class TabsScreen extends ConsumerWidget {
  const TabsScreen({super.key});
  static const id = 'tabs_screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabsState = ref.watch(tabsProvider);
    final userState = ref.watch(userProvider);

    return Scaffold(
      body: IndexedStack(
        index: tabsState.currentIndex,
        children: [
          // Pic Tab
          Center(
            child: Text('Pic Tab - Index: ${tabsState.currentIndex}'),
          ),
          // Tagged Tab
          Center(
            child: Text('Tagged Tab - Index: ${tabsState.currentIndex}'),
          ),
          // Untagged Tab
          Center(
            child: Text('Untagged Tab - Index: ${tabsState.currentIndex}'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabsState.currentIndex,
        onTap: (index) {
          ref.read(tabsProvider.notifier).setCurrentIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Pics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.label),
            label: 'Tagged',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.label_off),
            label: 'Untagged',
          ),
        ],
      ),
    );
  }
}