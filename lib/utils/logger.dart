import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Log levels for different types of messages
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// Structured logging utility for consistent logging across the app
/// Provides different log levels and structured data logging
class Logger {
  static const String _defaultName = 'GowagrApp';

  /// Log a debug message
  static void debug(String message, {String? name, Object? data}) {
    _log(LogLevel.debug, message, name: name, data: data);
  }

  /// Log an info message
  static void info(String message, {String? name, Object? data}) {
    _log(LogLevel.info, message, name: name, data: data);
  }

  /// Log a warning message
  static void warning(String message,
      {String? name, Object? data, Object? error}) {
    _log(LogLevel.warning, message, name: name, data: data, error: error);
  }

  /// Log an error message
  static void error(String message,
      {String? name, Object? data, Object? error}) {
    _log(LogLevel.error, message, name: name, data: data, error: error);
  }

  /// Internal logging method
  static void _log(
    LogLevel level,
    String message, {
    String? name,
    Object? data,
    Object? error,
  }) {
    final logName = name ?? _defaultName;
    final timestamp = DateTime.now().toIso8601String();
    final levelString = level.name.toUpperCase();

    // Create structured log message
    final logMessage = '[$levelString] $message';

    // Log to console in debug mode
    if (kDebugMode) {
      print('$timestamp $logMessage');
      if (data != null) {
        print('Data: $data');
      }
      if (error != null) {
        print('Error: $error');
      }
    }

    // Use developer.log for production logging
    switch (level) {
      case LogLevel.debug:
        developer.log(logMessage, name: logName, level: 500);
        break;
      case LogLevel.info:
        developer.log(logMessage, name: logName, level: 800);
        break;
      case LogLevel.warning:
        developer.log(logMessage, name: logName, level: 900, error: error);
        break;
      case LogLevel.error:
        developer.log(logMessage, name: logName, level: 1000, error: error);
        break;
    }
  }

  /// Log API request details
  static void logApiRequest({
    required String endpoint,
    required Map<String, dynamic> parameters,
    String? name,
  }) {
    info(
      'API Request: $endpoint',
      name: name ?? 'ApiService',
      data: {'parameters': parameters},
    );
  }

  /// Log API response details
  static void logApiResponse({
    required String endpoint,
    required int statusCode,
    required int responseTime,
    String? name,
  }) {
    info(
      'API Response: $endpoint',
      name: name ?? 'ApiService',
      data: {
        'statusCode': statusCode,
        'responseTime': responseTime,
      },
    );
  }

  /// Log cache operations
  static void logCacheOperation({
    required String operation,
    required String details,
    String? name,
  }) {
    info(
      'Cache $operation',
      name: name ?? 'DatabaseService',
      data: {'details': details},
    );
  }

  /// Log user interactions
  static void logUserAction({
    required String action,
    required String details,
    String? name,
  }) {
    info(
      'User Action: $action',
      name: name ?? 'UserInteraction',
      data: {'details': details},
    );
  }

  /// Log performance metrics
  static void logPerformance({
    required String operation,
    required int duration,
    String? name,
  }) {
    info(
      'Performance: $operation',
      name: name ?? 'Performance',
      data: {'duration': duration},
    );
  }
}
