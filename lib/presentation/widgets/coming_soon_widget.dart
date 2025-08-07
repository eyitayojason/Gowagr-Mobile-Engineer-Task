import 'package:flutter/material.dart';
import '../../constants/colors.dart';

/// Reusable widget for displaying "coming soon" content
class ComingSoonWidget extends StatelessWidget {
  const ComingSoonWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIcon(),
          const SizedBox(height: 24),
          _buildTitle(),
          const SizedBox(height: 12),
          _buildDescription(),
          const SizedBox(height: 8),
          _buildComingSoonText(),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 64,
        color: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.darkBlue,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      description,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildComingSoonText() {
    return Text(
      'Coming soon...',
      style: TextStyle(
        color: AppColors.textSecondary.withValues(alpha: 0.7),
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
    );
  }
}
