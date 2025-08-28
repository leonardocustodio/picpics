// Temporary stub screens for Riverpod migration
// These will be replaced with proper implementations

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picpics/model/pic.dart';

class AllTagsScreen extends ConsumerWidget {
  static const id = 'all_tags_screen';
  final Pic? picStore;
  
  AllTagsScreen({super.key, this.picStore});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Tags')),
      body: const Center(child: Text('All Tags Screen - To be migrated')),
    );
  }
}

class PhotoScreen extends ConsumerWidget {
  static const id = 'photo_screen';
  final String picId;
  final List<String> picIdList;
  
  PhotoScreen({
    super.key,
    required this.picId,
    required this.picIdList,
  });
  
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
  static const id = 'add_location_screen';
  final Pic? pic;
  
  const AddLocationScreen(this.pic, {super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Location')),
      body: const Center(child: Text('Add Location Screen - To be migrated')),
    );
  }
}

class PinScreen extends ConsumerWidget {
  static const id = 'pin_screen';
  
  PinScreen({super.key});
  
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
  static const id = 'access_code_screen';
  
  AccessCodeScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Access Code')),
      body: const Center(child: Text('Access Code Screen - To be migrated')),
    );
  }
}