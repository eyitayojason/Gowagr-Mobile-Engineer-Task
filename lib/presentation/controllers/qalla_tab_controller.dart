import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/enums/tab_type.dart';
import '../../config/app_config.dart';
import '../providers/event_provider.dart';

/// Controller for managing the Qalla tab screen business logic
class QallaTabController {
  final BuildContext context;
  final TextEditingController searchController;
  final ScrollController scrollController;

  QallaTabController({
    required this.context,
    required this.searchController,
    required this.scrollController,
  });

  /// Initialize the controller and set up listeners
  void initialize() {
    _setupScrollListener();
    _initializeEventProvider();
  }

  /// Set up scroll listener for pagination
  void _setupScrollListener() {
    scrollController.addListener(() {
      if (_shouldLoadMore()) {
        _loadMoreEvents();
      }
    });
  }

  /// Check if more events should be loaded
  bool _shouldLoadMore() {
    return scrollController.position.pixels >=
        scrollController.position.maxScrollExtent -
            AppConfig.paginationThreshold;
  }

  /// Load more events
  void _loadMoreEvents() {
    context.read<EventProvider>().fetchEvents();
  }

  /// Initialize the event provider with offline-first caching
  void _initializeEventProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<EventProvider>().initialize();
    });
  }

  /// Handle tab selection
  void onTabTapped(TabType tabType) {
    // Future: Add tab-specific logic here
    // For now, just log the tab change
    debugPrint('Tab changed to: ${tabType.title}');
  }

  /// Handle search text changes
  void onSearchChanged(String value) {
    context.read<EventProvider>().updateSearch(value);
  }

  /// Handle category selection
  void onCategorySelected(String category) {
    context.read<EventProvider>().updateCategory(category);
  }

  /// Handle refresh
  Future<void> onRefresh() async {
    await context.read<EventProvider>().refresh();
  }

  /// Handle clear cache
  void onClearCache() {
    context.read<EventProvider>().clearCache();
  }

  /// Dispose resources
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
  }
}
