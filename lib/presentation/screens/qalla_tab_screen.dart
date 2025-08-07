// Qalla tab screen for presentation layer
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/qalla_logo.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_filter.dart';
import '../widgets/tab_navigation.dart';
import '../widgets/events_list_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/coming_soon_widget.dart';
import '../controllers/qalla_tab_controller.dart';
import '../../constants/colors.dart';
import '../../domain/enums/tab_type.dart';
import '../../utils/snack_bar_utils.dart';

/// Main tab screen for the Qalla app
class QallaTabScreen extends StatefulWidget {
  const QallaTabScreen({super.key});

  @override
  QallaTabScreenState createState() => QallaTabScreenState();
}

class QallaTabScreenState extends State<QallaTabScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  late QallaTabController _controller;

  String _selectedCategory = 'Trending';
  TabType _currentTab = TabType.explore;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Initialize the controller
  void _initializeController() {
    _controller = QallaTabController(
      context: context,
      searchController: _searchController,
      scrollController: _scrollController,
    );
    _controller.initialize();
  }

  /// Handle tab selection
  void _onTabTapped(TabType tabType) {
    setState(() {
      _currentTab = tabType;
    });
    _controller.onTabTapped(tabType);
  }

  /// Handle category selection
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _controller.onCategorySelected(category);
  }

  /// Handle refresh
  Future<void> _onRefresh() async {
    await _controller.onRefresh();
  }

  /// Handle clear cache
  void _onClearCache() {
    _controller.onClearCache();
    SnackBarUtils.showSuccessSnackBar(context, 'Cache cleared successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 21),
              _buildTabNavigation(),
              const SizedBox(height: 16),
              _buildTabContent(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the header with logo
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: const QallaLogo(),
    );
  }

  /// Build the tab navigation
  Widget _buildTabNavigation() {
    return TabNavigation(
      currentTab: _currentTab,
      onTabTapped: _onTabTapped,
    );
  }

  /// Build the content based on the current tab
  Widget _buildTabContent() {
    return Expanded(
      child: _buildTabContentByType(),
    );
  }

  /// Build content based on tab type
  Widget _buildTabContentByType() {
    switch (_currentTab) {
      case TabType.explore:
        return _buildExploreContent();
      case TabType.portfolio:
        return const ComingSoonWidget(
          title: 'Portfolio',
          description: 'Your portfolio will appear here',
          icon: Icons.account_balance_wallet_outlined,
        );
      case TabType.activity:
        return const ComingSoonWidget(
          title: 'Activity',
          description: 'Your activity history will appear here',
          icon: Icons.history_outlined,
        );
    }
  }

  /// Build the explore tab content
  Widget _buildExploreContent() {
    return Column(
      children: [
        _buildSearchBar(),
        const SizedBox(height: 16),
        _buildCategoryFilter(),
        const SizedBox(height: 16),
        _buildEventsContent(),
      ],
    );
  }

  /// Build the search bar
  Widget _buildSearchBar() {
    return CustomSearchBar(
      controller: _searchController,
      onChanged: _controller.onSearchChanged,
    );
  }

  /// Build the category filter
  Widget _buildCategoryFilter() {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        return CategoryFilter(
          selectedCategory: _selectedCategory,
          categories: provider.categories,
          onCategorySelected: _onCategorySelected,
        );
      },
    );
  }

  /// Build the events content
  Widget _buildEventsContent() {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        if (provider.events.isEmpty && !provider.isLoading) {
          return Expanded(
            child: EmptyStateWidget(
              isLoading: provider.isLoading,
              onRefresh: _onRefresh,
              onClearCache: _onClearCache,
            ),
          );
        }

        return Expanded(
          child: EventsListWidget(
            scrollController: _scrollController,
          ),
        );
      },
    );
  }
}
