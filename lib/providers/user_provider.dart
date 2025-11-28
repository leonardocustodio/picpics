import 'dart:async';
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:devicelocale/devicelocale.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:picpics/constants.dart';
import 'package:picpics/database/app_database.dart';
import 'package:picpics/managers/analytics_manager.dart';
import 'package:picpics/managers/crypto_manager.dart';
import 'package:picpics/managers/push_notifications_manager.dart';
import 'package:picpics/providers/database_provider.dart';
import 'package:picpics/utils/app_logger.dart';
import 'package:picpics/utils/helpers.dart';
import 'package:picpics/utils/languages.dart';

class UserState {
  final String appVersion;
  final String deviceLocale;
  final bool notifications;
  final bool dailyChallenges;
  final bool isPinRegistered;
  final bool keepAskingToDelete;
  final bool shouldDeleteOnPrivate;
  final int picsTaggedToday;
  final DateTime? lastTaggedPicDate;
  final bool loggedIn;
  final bool tutorialCompleted;
  final bool hasGalleryPermission;
  final bool waitingAccessCode;
  final bool isMenuExpanded;
  final bool isBiometricActivated;
  final bool tourCompleted;
  final int requireSecret;
  final int hourOfDay;
  final int minutesOfDay;
  final double photoHeightInCardWidget;
  final String appLanguage;
  final String currentLanguage;
  final List<String> recentTags;
  final List<BiometricType> availableBiometrics;
  final String appLocale;
  final String? email;

  UserState({
    this.appVersion = '',
    this.deviceLocale = '',
    this.notifications = false,
    this.dailyChallenges = false,
    this.isPinRegistered = false,
    this.keepAskingToDelete = false,
    this.shouldDeleteOnPrivate = false,
    this.picsTaggedToday = 0,
    this.lastTaggedPicDate,
    this.loggedIn = false,
    this.tutorialCompleted = false,
    this.hasGalleryPermission = false,
    this.waitingAccessCode = false,
    this.isMenuExpanded = true,
    this.isBiometricActivated = false,
    this.tourCompleted = false,
    this.requireSecret = 0,
    this.hourOfDay = 20,
    this.minutesOfDay = 0,
    this.photoHeightInCardWidget = 500.0,
    this.appLanguage = 'en',
    this.currentLanguage = '',
    this.recentTags = const [],
    this.availableBiometrics = const [],
    this.appLocale = 'en',
    this.email,
  });

  UserState copyWith({
    String? appVersion,
    String? deviceLocale,
    bool? notifications,
    bool? dailyChallenges,
    bool? isPinRegistered,
    bool? keepAskingToDelete,
    bool? shouldDeleteOnPrivate,
    int? picsTaggedToday,
    DateTime? lastTaggedPicDate,
    bool? loggedIn,
    bool? tutorialCompleted,
    bool? hasGalleryPermission,
    bool? waitingAccessCode,
    bool? isMenuExpanded,
    bool? isBiometricActivated,
    bool? tourCompleted,
    int? requireSecret,
    int? hourOfDay,
    int? minutesOfDay,
    double? photoHeightInCardWidget,
    String? appLanguage,
    String? currentLanguage,
    List<String>? recentTags,
    List<BiometricType>? availableBiometrics,
    String? appLocale,
    String? email,
  }) {
    return UserState(
      appVersion: appVersion ?? this.appVersion,
      deviceLocale: deviceLocale ?? this.deviceLocale,
      notifications: notifications ?? this.notifications,
      dailyChallenges: dailyChallenges ?? this.dailyChallenges,
      isPinRegistered: isPinRegistered ?? this.isPinRegistered,
      keepAskingToDelete: keepAskingToDelete ?? this.keepAskingToDelete,
      shouldDeleteOnPrivate: shouldDeleteOnPrivate ?? this.shouldDeleteOnPrivate,
      picsTaggedToday: picsTaggedToday ?? this.picsTaggedToday,
      lastTaggedPicDate: lastTaggedPicDate ?? this.lastTaggedPicDate,
      loggedIn: loggedIn ?? this.loggedIn,
      tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
      hasGalleryPermission: hasGalleryPermission ?? this.hasGalleryPermission,
      waitingAccessCode: waitingAccessCode ?? this.waitingAccessCode,
      isMenuExpanded: isMenuExpanded ?? this.isMenuExpanded,
      isBiometricActivated: isBiometricActivated ?? this.isBiometricActivated,
      tourCompleted: tourCompleted ?? this.tourCompleted,
      requireSecret: requireSecret ?? this.requireSecret,
      hourOfDay: hourOfDay ?? this.hourOfDay,
      minutesOfDay: minutesOfDay ?? this.minutesOfDay,
      photoHeightInCardWidget: photoHeightInCardWidget ?? this.photoHeightInCardWidget,
      appLanguage: appLanguage ?? this.appLanguage,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      recentTags: recentTags ?? this.recentTags,
      availableBiometrics: availableBiometrics ?? this.availableBiometrics,
      appLocale: appLocale ?? this.appLocale,
      email: email ?? this.email,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final LocalAuthentication biometricAuth = LocalAuthentication();
  final AppDatabase database = AppDatabase();
  final Ref ref;

  UserNotifier(this.ref) : super(UserState());

  Future<void> initialize() async {
    AppLogger.i('[UserNotifier] Starting initialization...');
    
    // Get device locale
    final locale = await Devicelocale.currentLocale ?? 'en';
    state = state.copyWith(deviceLocale: locale);
    
    // Get app version
    final packageInfo = await PackageInfo.fromPlatform();
    state = state.copyWith(appVersion: packageInfo.version);
    
    // Load user from database
    final databaseController = DatabaseController();
    final user = await databaseController.getUser(deviceLocale: locale);
    
    // Create default tags if needed
    await createDefaultTags();
    
    AppLogger.i('[UserNotifier] User loaded from database:');
    AppLogger.d('  - tutorialCompleted: ${user.tutorialCompleted}');
    AppLogger.d('  - hasGalleryPermission (from DB): ${user.hasGalleryPermission}');
    AppLogger.d('  - isPinRegistered: ${user.isPinRegistered}');
    AppLogger.d('  - appLanguage: ${user.appLanguage}');
    
    // Update state with user data
    state = state.copyWith(
      notifications: user.notification,
      dailyChallenges: user.dailyChallenges,
      hourOfDay: user.hourOfDay,
      minutesOfDay: user.minuteOfDay,
      tutorialCompleted: user.tutorialCompleted,
      appLanguage: user.appLanguage ?? 'en',
      hasGalleryPermission: user.hasGalleryPermission,
      loggedIn: user.loggedIn,
      isPinRegistered: user.isPinRegistered,
      keepAskingToDelete: user.keepAskingToDelete,
      shouldDeleteOnPrivate: user.shouldDeleteOnPrivate,
      email: user.email,
      tourCompleted: user.tourCompleted,
      isBiometricActivated: user.isBiometricActivated,
    );
    
    // Set current language
    _updateCurrentLanguage(state.appLanguage);
    
    // Load recent tags
    // TODO: Uncomment when tags provider is fully implemented
    // final tagsController = ref.read(tagsProvider.notifier);
    // for (final tagKey in user.recentTags) {
    //   tagsController.addRecentTag(tagKey);
    // }
    
    // Check gallery permissions if tutorial is completed
    if (user.tutorialCompleted) {
      await checkGalleryPermissions();
    }
  }

  Future<void> checkGalleryPermissions() async {
    AppLogger.i('[UserNotifier] Checking actual gallery permission status...');
    final permissionStatus = await PhotoManager.requestPermissionExtend();
    
    AppLogger.i('[UserNotifier] PhotoManager permission status:');
    AppLogger.d('  - isAuth: ${permissionStatus.isAuth}');
    AppLogger.d('  - hasAccess: ${permissionStatus.hasAccess}');
    
    if (permissionStatus.isAuth || permissionStatus.hasAccess) {
      AppLogger.i('[UserNotifier] Permission granted! Setting hasGalleryPermission to true');
      state = state.copyWith(hasGalleryPermission: true);
      
      // Update database if permission status changed
      if (!state.hasGalleryPermission) {
        AppLogger.i('[UserNotifier] Updating database with new permission status...');
        // Update database here
      }
    } else {
      AppLogger.i('[UserNotifier] Permission denied. Setting hasGalleryPermission to false');
      state = state.copyWith(hasGalleryPermission: false);
    }
  }

  void _updateCurrentLanguage(String langCode) {
    var lang = langCode.split('_')[0];
    if (lang.trim().isEmpty) {
      lang = 'en';
    }
    state = state.copyWith(appLocale: lang);
    
    final local = LanguageLocal();
    final langName = local.getDisplayLanguage(lang)['nativeName'] ?? '';
    state = state.copyWith(currentLanguage: langName);
  }

  void setAppLanguage(String language) {
    state = state.copyWith(appLanguage: language);
    _updateCurrentLanguage(language);
    // TODO: Update language controller when fully migrated
    // ref.read(languageProvider.notifier).changeLanguageTo(language);
  }

  void setNotifications(bool value) {
    state = state.copyWith(notifications: value);
  }

  void setDailyChallenges(bool value) {
    state = state.copyWith(dailyChallenges: value);
  }

  void setHourOfDay(int value) {
    state = state.copyWith(hourOfDay: value);
  }

  void setMinutesOfDay(int value) {
    state = state.copyWith(minutesOfDay: value);
  }

  Future<void> setTutorialCompleted(bool value) async {
    state = state.copyWith(tutorialCompleted: value);
    
    // Update database
    final currentUser = await database.getSingleMoorUser();
    if (currentUser != null) {
      await database.updateMoorUser(
        currentUser.copyWith(tutorialCompleted: value)
      );
    }
    
    // Request gallery permission if tutorial is complete
    if (value) {
      await checkGalleryPermissions();
      await Analytics.sendTutorialComplete();
    }
  }

  void setHasGalleryPermission(bool value) {
    state = state.copyWith(hasGalleryPermission: value);
  }

  void setLoggedIn(bool value) {
    state = state.copyWith(loggedIn: value);
  }

  void setIsPinRegistered(bool value) {
    state = state.copyWith(isPinRegistered: value);
  }

  void setKeepAskingToDelete(bool value) {
    state = state.copyWith(keepAskingToDelete: value);
  }

  void setShouldDeleteOnPrivate(bool value) {
    state = state.copyWith(shouldDeleteOnPrivate: value);
  }

  void setEmail(String? value) {
    state = state.copyWith(email: value);
  }

  void setTourCompleted(bool value) {
    state = state.copyWith(tourCompleted: value);
  }

  void setIsBiometricActivated(bool value) {
    state = state.copyWith(isBiometricActivated: value);
  }

  void setIsMenuExpanded(bool value) {
    state = state.copyWith(isMenuExpanded: value);
  }

  void setWaitingAccessCode(bool value) {
    state = state.copyWith(waitingAccessCode: value);
  }

  void setRequireSecret(int value) {
    state = state.copyWith(requireSecret: value);
  }

  void setPicsTaggedToday(int value) {
    state = state.copyWith(picsTaggedToday: value);
  }

  void setLastTaggedPicDate(DateTime? value) {
    state = state.copyWith(lastTaggedPicDate: value);
  }

  void addRecentTag(String tag) {
    final tags = List<String>.from(state.recentTags);
    if (!tags.contains(tag)) {
      tags.add(tag);
      state = state.copyWith(recentTags: tags);
    }
  }

  void removeRecentTag(String tag) {
    final tags = List<String>.from(state.recentTags);
    tags.remove(tag);
    state = state.copyWith(recentTags: tags);
  }

  void setAvailableBiometrics(List<BiometricType> biometrics) {
    state = state.copyWith(availableBiometrics: biometrics);
  }

  Future<void> createDefaultTags() async {
    // This will be implemented when tags are fully migrated
    // For now, just log that we would create default tags
    AppLogger.d('Creating default tags (stub implementation)');
  }

  Future<void> requestGalleryPermission() async {
    AppLogger.i('[UserNotifier] Requesting gallery permission...');
    final permissionStatus = await PhotoManager.requestPermissionExtend();

    if (permissionStatus.isAuth || permissionStatus.hasAccess) {
      AppLogger.i('[UserNotifier] Gallery permission granted');
      state = state.copyWith(hasGalleryPermission: true);

      // Update database
      final currentUser = await database.getSingleMoorUser();
      if (currentUser != null) {
        await database.updateMoorUser(
          currentUser.copyWith(hasGalleryPermission: true)
        );
      }
    } else {
      AppLogger.i('[UserNotifier] Gallery permission denied');
      state = state.copyWith(hasGalleryPermission: false);
    }
  }

  Future<void> requestNotificationPermission() async {
    AppLogger.i('[UserNotifier] Requesting notification permission...');

    // Check if permission was granted
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final granted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    if (granted == true) {
      AppLogger.i('[UserNotifier] Notification permission granted');
      state = state.copyWith(notifications: true);
    }
  }

  Future<void> checkNotificationPermission({bool firstPermissionCheck = false}) async {
    AppLogger.i('[UserNotifier] Checking notification permission...');
    // TODO: Implement notification permission check
    // This is a placeholder to prevent compilation errors
  }
}

// Providers
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref);
});