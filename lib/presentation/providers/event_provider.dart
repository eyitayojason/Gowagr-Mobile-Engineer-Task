// Event provider for presentation layer
import 'package:flutter/foundation.dart';
import '../../data/models/event.dart';
import '../../data/services/api_service.dart';
import '../../data/services/database_service.dart';
import '../../constants/categories.dart';
import '../../utils/debounce.dart';
import '../../utils/logger.dart';
import '../../config/app_config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class EventProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();
  List<Event> events = [];
  bool isLoading = false;
  bool hasMore = true;
  String? error;
  int page = AppConfig.initialPage;
  final int size = AppConfig.defaultPageSize;
  String searchQuery = '';
  String? selectedCategory;
  bool showTrending = false;
  bool _isInitialized = false;

  // Debouncer for search to reduce API calls
  final Debouncer _searchDebouncer =
      Debouncer(milliseconds: AppConfig.searchDebounceMs);

  // Get available categories
  List<CategoryData> get categories => Categories.all;

  // Get selected category data
  CategoryData? get selectedCategoryData {
    if (selectedCategory == null) return null;
    return categories.firstWhere(
      (category) => category.name == selectedCategory,
      orElse: () => Categories.all.first,
    );
  }

  /// Initialize the provider with cached data
  Future<void> initialize() async {
    if (_isInitialized) return;

    Logger.info('Initializing EventProvider with cached data',
        name: 'EventProvider');

    // Load cached data immediately for offline-first experience
    await _loadCachedData();

    // Then try to fetch fresh data if online
    await _fetchFreshDataIfOnline();

    _isInitialized = true;
  }

  /// Load cached data from database
  Future<void> _loadCachedData() async {
    try {
      Logger.info('Loading cached events from database', name: 'EventProvider');
      final cachedEvents = await _databaseService.getCachedEvents();

      if (cachedEvents.isNotEmpty) {
        events = cachedEvents;
        Logger.info('Loaded ${cachedEvents.length} cached events',
            name: 'EventProvider');
        notifyListeners();
      } else {
        Logger.info('No cached events found', name: 'EventProvider');
      }
    } catch (e) {
      Logger.error('Error loading cached data: $e',
          name: 'EventProvider', error: e);
    }
  }

  /// Fetch fresh data if online
  Future<void> _fetchFreshDataIfOnline() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (!connectivityResult.contains(ConnectivityResult.none)) {
        Logger.info('Online - fetching fresh data', name: 'EventProvider');
        await fetchEvents(reset: true, showCachedFirst: false);
      } else {
        Logger.info('Offline - using cached data only', name: 'EventProvider');
      }
    } catch (e) {
      Logger.error('Error checking connectivity: $e',
          name: 'EventProvider', error: e);
    }
  }

  Future<void> fetchEvents(
      {bool reset = false, bool showCachedFirst = true}) async {
    // Prevent concurrent requests
    if (isLoading) {
      Logger.info('Skipping fetch - already loading', name: 'EventProvider');
      return;
    }

    if (reset) {
      Logger.info('Resetting events list', name: 'EventProvider');
      page = 1;
      events.clear();
      hasMore = true;
    } else if (!hasMore) {
      Logger.info('Skipping fetch - no more data available',
          name: 'EventProvider');
      return;
    }

    Logger.info(
        'Fetching events - Page: $page, Search: "$searchQuery", Category: $selectedCategory, Trending: $showTrending',
        name: 'EventProvider');

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      Logger.info('Connectivity result: $connectivityResult',
          name: 'EventProvider');

      if (connectivityResult.contains(ConnectivityResult.none)) {
        // Offline: Use cached data only
        Logger.info('No internet connection, using cached data',
            name: 'EventProvider');

        if (showCachedFirst && events.isEmpty) {
          await _loadCachedData();
        }

        if (events.isEmpty) {
          Logger.info('No cached data available', name: 'EventProvider');
        }
      } else {
        // Online: Fetch fresh data and cache it
        Logger.info('Internet available, fetching from API',
            name: 'EventProvider');

        final newEvents = await _apiService.fetchEvents(
          page: page,
          size: size,
          keyword: searchQuery.isNotEmpty ? searchQuery : null,
          trending: showTrending,
          category: selectedCategory,
        );

        Logger.info('API returned ${newEvents.length} events',
            name: 'EventProvider');

        // Update events list
        if (reset) {
          events = newEvents;
        } else {
          events.addAll(newEvents);
        }

        Logger.info('Total events after update: ${events.length}',
            name: 'EventProvider');

        // Cache events silently - don't let caching errors break the app
        await _cacheEvents(newEvents);

        page++;
        if (newEvents.length < size) {
          hasMore = false;
          Logger.info('No more events available (hasMore set to false)',
              name: 'EventProvider');
        }
      }
    } catch (e) {
      Logger.error('Error in fetchEvents: $e', name: 'EventProvider', error: e);

      // If we have cached data, don't show error
      if (events.isNotEmpty) {
        Logger.info('Showing cached data despite API error',
            name: 'EventProvider');
      } else {
        error = 'Failed to load events';
      }
    } finally {
      isLoading = false;
      Logger.info(
          'Fetch completed - Total events: ${events.length}, Error: $error',
          name: 'EventProvider');
      notifyListeners();
    }
  }

  /// Cache events with error handling
  Future<void> _cacheEvents(List<Event> eventsToCache) async {
    try {
      await _databaseService.cacheEvents(eventsToCache);
      Logger.info('Events cached to database', name: 'EventProvider');
    } catch (cacheError) {
      Logger.error('Failed to cache events: $cacheError',
          name: 'EventProvider', error: cacheError);

      // If it's a schema error, try to clear cache and retry once
      if (cacheError.toString().contains('DatabaseException') ||
          cacheError.toString().contains('schema')) {
        try {
          await _databaseService.clearCache();
          Logger.info('Cache cleared due to schema error',
              name: 'EventProvider');
          // Try caching again
          await _databaseService.cacheEvents(eventsToCache);
          Logger.info('Events cached successfully after cache clear',
              name: 'EventProvider');
        } catch (retryError) {
          Logger.error('Failed to cache events after retry: $retryError',
              name: 'EventProvider', error: retryError);
        }
      }
      // Don't set error - caching failure shouldn't break the app
    }
  }

  void updateSearch(String query) {
    Logger.info('Updating search query: "$query"', name: 'EventProvider');
    searchQuery = query;

    // Use debouncer to avoid excessive API calls while typing
    _searchDebouncer.run(() {
      Logger.info('Executing debounced search for: "$query"',
          name: 'EventProvider');
      fetchEvents(reset: true);
    });
  }

  void updateCategory(String? category) {
    Logger.info('Updating category: $category', name: 'EventProvider');
    selectedCategory = category;
    // Schedule the fetch to avoid build phase issues
    Future.microtask(() => fetchEvents(reset: true));
  }

  void toggleTrending(bool value) {
    Logger.info('Toggling trending: $value', name: 'EventProvider');
    showTrending = value;
    // Schedule the fetch to avoid build phase issues
    Future.microtask(() => fetchEvents(reset: true));
  }

  // Clear any stored error
  void clearError() {
    error = null;
    notifyListeners();
  }

  // Refresh events
  Future<void> refresh() async {
    await fetchEvents(reset: true, showCachedFirst: false);
  }

  // Clear database cache (useful for fixing schema issues)
  Future<void> clearCache() async {
    try {
      await _databaseService.clearCache();
      Logger.info('Database cache cleared', name: 'EventProvider');

      // Clear events from memory as well
      events.clear();
      notifyListeners();
    } catch (e) {
      Logger.error('Error clearing cache: $e', name: 'EventProvider', error: e);
    }
  }

  /// Check if we have cached data
  bool get hasCachedData => events.isNotEmpty;
}
