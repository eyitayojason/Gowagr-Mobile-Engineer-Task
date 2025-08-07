// Event card widget for presentation layer
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/colors.dart';
import '../../assets/image_assets.dart';
import '../../data/models/event.dart';
import '../../config/app_config.dart';
import 'tooltip_text.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    // Get the first two markets for Yes/No buttons
    final markets = event.markets.take(2).toList();
    final hasMarkets = markets.isNotEmpty;

    return Container(
      width: double.infinity,
      height: AppConfig.cardHeight,
      margin:
          EdgeInsets.symmetric(horizontal: AppConfig.cardMargin, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        border: Border.all(
          color: AppColors.figmaBorder,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppConfig.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with event image and title
            Row(
              children: [
                // Event Image
                Container(
                  width: AppConfig.imageSize,
                  height: AppConfig.imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: AppColors.lightGray,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CachedNetworkImage(
                        imageUrl: event.image128Url,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return Container(
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Icon(
                              Icons.error,
                              color: AppColors.primaryBlue,
                              size: 24,
                            ),
                          );
                        },
                      )),
                ),
                const SizedBox(width: 12),
                // Title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TooltipText(
                        text: event.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                        maxLines: 2,
                      ),
                      if (event.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        TooltipText(
                          text: event.description,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                          maxLines: 1,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Buy Yes/No Buttons - Using actual market data
            if (hasMarkets) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Buy Yes Button - Using first market data
                  Expanded(
                    child: Container(
                      height: 42,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                          color: AppColors.primaryBlue.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Buy Yes - ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                    height: 1.0,
                                    letterSpacing: 0,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                TextSpan(
                                  text: markets[0].yesPriceFormatted,
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
                    ),
                  ),
                  // Buy No Button - Using second market data if available
                  if (markets.length > 1)
                    Expanded(
                      child: Container(
                        height: 42,
                        margin: const EdgeInsets.only(left: 4),
                        decoration: BoxDecoration(
                          color: AppColors.red.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                            color: AppColors.red.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Buy No - ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: AppColors.red,
                                    ),
                                  ),
                                  TextSpan(
                                    text: markets[1].noPriceFormatted,
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
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Financial figures
              if (markets.length > 1)
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '₦10',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            TextSpan(
                              text: '  →  ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            TextSpan(
                              text: markets[0].yesProfitFormatted,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '₦10',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            TextSpan(
                              text: '  →  ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            TextSpan(
                              text: markets[1].noProfitFormatted,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 25),
            ],

            // Footer with stats and end date
            Row(
              children: [
                // Volume and Orders count
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
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.error,
                          color: AppColors.textSecondary,
                          size: 16,
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    TooltipText(
                      text: '${event.totalOrders} Trades',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                // End date
                Row(
                  children: [
                    TooltipText(
                      text: event.endDate,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      bookmarkIcon,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textSecondary,
                        BlendMode.srcIn,
                      ),
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.bookmark,
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
