/// Enum representing the different tab types in the Qalla app
enum TabType {
  explore(0, 'Explore'),
  portfolio(1, 'Portfolio'),
  activity(2, 'Activity');

  const TabType(this.tabIndex, this.title);

  final int tabIndex;
  final String title;

  /// Get tab type from index
  static TabType fromIndex(int index) {
    return TabType.values.firstWhere(
      (tab) => tab.tabIndex == index,
      orElse: () => TabType.explore,
    );
  }

  /// Get tab type from title
  static TabType fromTitle(String title) {
    return TabType.values.firstWhere(
      (tab) => tab.title == title,
      orElse: () => TabType.explore,
    );
  }
}
