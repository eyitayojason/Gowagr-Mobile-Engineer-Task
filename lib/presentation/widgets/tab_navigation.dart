import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../domain/enums/tab_type.dart';

/// Reusable tab navigation widget
class TabNavigation extends StatelessWidget {
  const TabNavigation({
    super.key,
    required this.currentTab,
    required this.onTabTapped,
  });

  final TabType currentTab;
  final ValueChanged<TabType> onTabTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: TabType.values.map((tab) {
          final isActive = tab == currentTab;
          return Row(
            children: [
              _TabItem(
                tab: tab,
                isActive: isActive,
                onTap: () => onTabTapped(tab),
              ),
              if (tab != TabType.values.last) const SizedBox(width: 26),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final TabType tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        tab.title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isActive ? AppColors.darkBlue : AppColors.textInactive,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
      ),
    );
  }
}
