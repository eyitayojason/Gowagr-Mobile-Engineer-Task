import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/colors.dart';
import '../../assets/image_assets.dart';
import '../../data/models/event.dart';
import 'tooltip_text.dart';

/// Specialized event card for contestant-based events like awards, sports events, etc.
/// This card displays multiple markets with Yes/No options for each contestant/option.
class MultiEventCard extends StatelessWidget {
  final Event event;

  const MultiEventCard({
    super.key,
    required this.event,
  });

  /// Check if this is specifically a Headies award event
  bool get _isHeadiesEvent => event.title.contains('Headies');

  /// Determine the appropriate icon based on the event type
  /// This helps users quickly identify what kind of event they're looking at
  IconData get _eventIcon {
    if (_isHeadiesEvent) {
      return Icons.emoji_events; // Trophy icon for Headies awards
    } else if (event.title.toLowerCase().contains('award')) {
      return Icons.emoji_events; // Trophy icon for other awards
    } else if (event.title.toLowerCase().contains('posts')) {
      return Icons.post_add; // Post icon for social media events
    } else if (event.title.toLowerCase().contains('players')) {
      return Icons.sports_soccer; // Soccer ball for sports events
    } else {
      return Icons.people; // Default people icon for other events
    }
  }

  /// Get the event type label to display in the header
  /// This gives users a quick visual indicator of the event category
  String get _eventLabel {
    if (_isHeadiesEvent) {
      return 'HEADIES'; // Special label for Headies awards
    } else if (event.title.toLowerCase().contains('award')) {
      return 'AWARD'; // Generic award events
    } else if (event.title.toLowerCase().contains('posts')) {
      return 'POSTS'; // Social media related events
    } else if (event.title.toLowerCase().contains('players')) {
      return 'SPORTS'; // Sports-related events
    } else {
      return 'EVENT'; // Default label for other events
    }
  }

  /// Build the icon-based fallback design when no image is available or image fails to load
  /// This maintains the distinctive multi-event design with event label and appropriate icon
  Widget _buildIconFallback() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _eventLabel,
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: 8,
                fontFamily: 'Archivo',
              ),
            ),
            Icon(
              _eventIcon,
              color: AppColors.primaryBlue,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract markets data for easier access
    final markets = event.markets;
    final hasMarkets = markets.isNotEmpty;

    return Container(
      width: double.infinity,
      height: 225,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: AppColors.figmaBorder,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with event image/icon and title
            Row(
              children: [
                // Event image container - shows actual image or fallback icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: AppColors.lightGray, // Background for image loading
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: event.image128Url.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: event.image128Url,
                            fit: BoxFit.cover,
                            // Fallback to icon-based design if image fails to load
                            errorWidget: (context, url, error) {
                              return _buildIconFallback();
                            },
                          )
                        : _buildIconFallback(), // Use icon design if no image URL
                  ),
                ),
                const SizedBox(width: 12),
                // Event title - shows the main event name
                Expanded(
                  child: TooltipText(
                    text: event.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                    maxLines: 2, // Allow up to 2 lines for longer titles
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Markets section - shows contestant options with Yes/No betting buttons
            if (hasMarkets) ...[
              Column(
                children: [
                  // Display up to 2 markets (contestants/options) with their Yes/No prices
                  ...markets.take(2).map((market) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            // Market/contestant name
                            Expanded(
                              child: TooltipText(
                                text: market.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                maxLines:
                                    1, // Keep it on one line to save space
                              ),
                            ),
                            const SizedBox(width: 8),
                            // "Yes" betting button - shows the price for betting "Yes" on this option
                            Container(
                              height: 32,
                              width: 80,
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withValues(
                                    alpha: 0.05), // Light blue background
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: AppColors.primaryBlue
                                      .withValues(alpha: 0.2), // Blue border
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Yes ', // "Yes" label
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                      TextSpan(
                                        text: market
                                            .yesPriceFormatted, // Formatted price
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // "No" betting button - shows the price for betting "No" on this option
                            Container(
                              height: 32,
                              width: 80,
                              decoration: BoxDecoration(
                                color: AppColors.red.withValues(
                                    alpha: 0.05), // Light red background
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: AppColors.red
                                      .withValues(alpha: 0.2), // Red border
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'No ', // "No" label
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11,
                                          color: AppColors.red,
                                        ),
                                      ),
                                      TextSpan(
                                        text: market
                                            .noPriceFormatted, // Formatted price
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                          color: AppColors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 16),
            ],
            // Footer section with trade count and end date
            Row(
              children: [
                // Trade count indicator
                Row(
                  children: [
                    SvgPicture.asset(
                      signalIcon,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textSecondary,
                        BlendMode.srcIn,
                      ),
                      // Fallback to icon if SVG fails to load
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.signal_cellular_alt,
                          color: AppColors.textSecondary,
                          size: 16,
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    TooltipText(
                      text:
                          '${event.totalOrders} Trades', // Show total number of trades
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                // End date and bookmark indicator
                Row(
                  children: [
                    TooltipText(
                      text: event.endDate, // Show when the event ends
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      heartIcon,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textSecondary,
                        BlendMode.srcIn,
                      ),
                      // Fallback to heart icon if SVG fails to load
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.favorite,
                          color: AppColors.textSecondary,
                          size: 16,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
