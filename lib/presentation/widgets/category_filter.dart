import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/categories.dart';
import 'tooltip_text.dart';

class CategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final List<CategoryData>? categories;

  const CategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.categories,
  });

  @override
  Widget build(BuildContext context) {
    // Use provided categories or fall back to default categories
    final categoryList = categories;

    // Create categories with selection state
    final categoriesWithState = categoryList!
        .map((category) => {
              'name': category.name,
              'icon': category.icon,
              'isSelected': selectedCategory == category.name,
            })
        .toList();

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categoriesWithState.length,
        itemBuilder: (context, index) {
          final category = categoriesWithState[index];
          final isSelected = category['isSelected'] as bool;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onCategorySelected(category['name'] as String),
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 90,
                  maxWidth: 140,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.unselectedCategoryBG,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.borderLight.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // For selected (Trending): icon on the left
                    if (isSelected) ...[
                      if (category['icon'] is IconData)
                        Icon(
                          category['icon'] as IconData,
                          size: 16,
                          color: AppColors.white,
                        )
                      else
                        Text(
                          category['icon'] as String,
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.white),
                        ),
                      const SizedBox(width: 8),
                    ],

                    // Text
                    Flexible(
                      child: TooltipText(
                        text: category['name'] as String,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.darkBlue,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // For unselected: icon on the right
                    if (!isSelected) ...[
                      const SizedBox(width: 2),
                      if (category['icon'] is IconData)
                        Icon(
                          category['icon'] as IconData,
                          size: 16,
                          color: AppColors.darkBlue,
                        )
                      else
                        Text(
                          category['icon'] as String,
                          style: const TextStyle(fontSize: 14),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
