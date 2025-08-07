import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../providers/event_provider.dart';

/// Reusable empty state widget for displaying when no content is available
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.isLoading,
    required this.onRefresh,
    required this.onClearCache,
  });

  final bool isLoading;
  final VoidCallback onRefresh;
  final VoidCallback onClearCache;

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedIcon(provider.isLoading),
              const SizedBox(height: 24),
              _buildTitle(provider.isLoading),
              const SizedBox(height: 8),
              _buildSubtitle(provider.isLoading),
              const SizedBox(height: 32),
              _buildRefreshButton(provider.isLoading),
              if (!provider.isLoading) ...[
                const SizedBox(height: 16),
                _buildClearCacheButton(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedIcon(bool isLoading) {
    return AnimatedRotation(
      turns: isLoading ? 1 : 0,
      duration: const Duration(seconds: 1),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isLoading ? Icons.refresh : Icons.event_busy,
          size: 48,
          color: isLoading ? AppColors.primaryBlue : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildTitle(bool isLoading) {
    return Text(
      isLoading ? 'Refreshing events...' : 'No events available',
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(bool isLoading) {
    return Text(
      isLoading
          ? 'Please wait while we fetch the latest events'
          : 'Pull down to refresh or tap the button below',
      style: TextStyle(
        color: AppColors.textSecondary.withValues(alpha: 0.8),
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildRefreshButton(bool isLoading) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isLoading ? null : _handleRefresh,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isLoading
                    ? [
                        AppColors.primaryBlue.withValues(alpha: 0.6),
                        AppColors.primaryBlue.withValues(alpha: 0.4),
                      ]
                    : [
                        AppColors.primaryBlue,
                        AppColors.primaryBlue.withValues(alpha: 0.8),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryBlue.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading) ...[
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                ] else ...[
                  const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  isLoading ? 'Refreshing...' : 'Refresh Events',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClearCacheButton() {
    return TextButton.icon(
      onPressed: _handleClearCache,
      icon: Icon(
        Icons.clear_all,
        size: 16,
        color: AppColors.textSecondary.withValues(alpha: 0.7),
      ),
      label: Text(
        'Clear Cache',
        style: TextStyle(
          color: AppColors.textSecondary.withValues(alpha: 0.7),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleRefresh() {
    HapticFeedback.lightImpact();
    onRefresh();
  }

  void _handleClearCache() {
    HapticFeedback.lightImpact();
    onClearCache();
  }
}
