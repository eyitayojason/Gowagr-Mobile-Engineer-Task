import 'package:flutter/material.dart';

class CategoryData {
  final String name;
  final dynamic icon;

  const CategoryData({
    required this.name,
    required this.icon,
  });
}

class Categories {
  static const List<CategoryData> all = [
    CategoryData(
      name: 'Trending',
      icon: Icons.trending_up,
    ),
    CategoryData(
      name: 'Watchlist',
      icon: Icons.bookmark_outline,
    ),
    CategoryData(
      name: 'Entertainment',
      icon: '🎶',
    ),
    CategoryData(
      name: 'Sports',
      icon: '⚽️',
    ),
  ];

  static List<String> get names =>
      all.map((category) => category.name).toList();
}
