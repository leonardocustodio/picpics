import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  factory AppLogger() => _instance;
  AppLogger._internal();
  static final AppLogger _instance = AppLogger._internal();

  late final Logger _logger;

  static Logger get log => _instance._logger;

  static void init() {
    _instance._logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 100,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: kDebugMode ? Level.trace : Level.off, // Only log in debug mode
      filter: kDebugMode ? DevelopmentFilter() : ProductionFilter(),
    );
  }

  // Convenience methods for direct access
  static void d(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace,}) {
    if (kDebugMode) {
      log.d(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  static void i(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace,}) {
    if (kDebugMode) {
      log.i(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  static void w(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace,}) {
    if (kDebugMode) {
      log.w(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  static void e(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace,}) {
    if (kDebugMode) {
      log.e(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  static void t(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace,}) {
    if (kDebugMode) {
      log.t(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  static void f(dynamic message,
      {DateTime? time, Object? error, StackTrace? stackTrace,}) {
    if (kDebugMode) {
      log.f(message, time: time, error: error, stackTrace: stackTrace);
    }
  }
}

// Custom filter that only allows logs in debug mode
class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return false; // Never log in production
  }
}
