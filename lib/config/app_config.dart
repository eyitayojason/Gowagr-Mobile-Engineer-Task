/// Application configuration management
/// Centralizes all configurable values for easy maintenance and testing
class AppConfig {
  // API Configuration
  static const String baseUrl = 'https://api.gowagr.app/pm/events';
  static const String eventsEndpoint = '/public-events';
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // Pagination Configuration
  static const int paginationThreshold =
      200; // pixels from bottom to trigger load more
  static const int initialPage = 1;

  // Search Configuration
  static const int searchDebounceMs =
      500; // milliseconds to wait before executing search
  static const int minSearchLength = 1; // minimum characters for search

  // Cache Configuration
  static const int cacheVersion = 2; // database schema version
  static const String databaseName = 'events.db';
  static const int maxCachedEvents = 1000; // maximum events to keep in cache

  // UI Configuration
  static const double cardHeight = 225.0;
  static const double cardMargin = 16.0;
  static const double cardPadding = 16.0;
  static const double borderRadius = 5.0;
  static const double imageSize = 48.0;

  // Animation Configuration
  static const int refreshAnimationDuration = 1000; // milliseconds
  static const int buttonAnimationDuration = 200; // milliseconds

  // Error Configuration
  static const int snackBarDuration = 3; // seconds
  static const int maxRetryAttempts = 3;

  // Network Configuration
  static const int requestTimeout = 30000; // milliseconds
  static const int connectTimeout = 10000; // milliseconds

  /// Get the full API URL for events
  static String get eventsUrl => '$baseUrl$eventsEndpoint';

  /// Check if the given page size is valid
  static bool isValidPageSize(int size) {
    return size > 0 && size <= maxPageSize;
  }

  /// Get a safe page size (clamped to valid range)
  static int getSafePageSize(int size) {
    if (size <= 0) return defaultPageSize;
    if (size > maxPageSize) return maxPageSize;
    return size;
  }
}
