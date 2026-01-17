// Temporary stub screens for Riverpod migration
// These will be replaced with proper implementations

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/model/pic.dart';

class AllTagsScreen extends ConsumerWidget {
  const AllTagsScreen({super.key, this.picStore});
  static const id = 'all_tags_screen';
  final Pic? picStore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Tags')),
      body: const Center(child: Text('All Tags Screen - To be migrated')),
    );
  }
}

class PhotoScreen extends ConsumerWidget {
  const PhotoScreen({
    required this.picId,
    required this.picIdList,
    super.key,
  });
  static const id = 'photo_screen';
  final String picId;
  final List<String> picIdList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo')),
      body: const Center(child: Text('Photo Screen - To be migrated')),
    );
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  static const id = 'settings_screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen - To be migrated')),
    );
  }
}

class AddLocationScreen extends ConsumerWidget {
  const AddLocationScreen(this.pic, {super.key});
  static const id = 'add_location_screen';
  final Pic? pic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Location')),
      body: const Center(child: Text('Add Location Screen - To be migrated')),
    );
  }
}

class PinScreen extends ConsumerWidget {
  const PinScreen({super.key});
  static const id = 'pin_screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('PIN')),
      body: const Center(child: Text('PIN Screen - To be migrated')),
    );
  }
}

class EmailScreen extends ConsumerWidget {
  const EmailScreen({super.key});
  static const id = 'email_screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email')),
      body: const Center(child: Text('Email Screen - To be migrated')),
    );
  }
}

class AccessCodeScreen extends ConsumerWidget {
  const AccessCodeScreen({super.key});
  static const id = 'access_code_screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Access Code')),
      body: const Center(child: Text('Access Code Screen - To be migrated')),
    );
  }
}
