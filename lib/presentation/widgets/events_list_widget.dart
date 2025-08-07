import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../data/models/event.dart';
import '../../domain/services/event_classification_service.dart';
import '../providers/event_provider.dart';
import 'event_card.dart';
import 'multi_event_card.dart';

/// Reusable widget for displaying the list of events
class EventsListWidget extends StatelessWidget {
  const EventsListWidget({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.events.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryBlue,
            ),
          );
        }

        if (provider.events.isEmpty) {
          return const SizedBox.shrink(); // Empty state is handled by parent
        }

        return RefreshIndicator(
          onRefresh: () => provider.refresh(),
          color: AppColors.primaryBlue,
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: provider.events.length + (provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.events.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                );
              }

              final event = provider.events[index];
              return _buildEventCard(event);
            },
          ),
        );
      },
    );
  }

  Widget _buildEventCard(Event event) {
    // Use different card types based on event classification
    if (EventClassificationService.isContestantBasedEvent(event)) {
      return MultiEventCard(event: event);
    } else {
      return EventCard(event: event);
    }
  }
}
