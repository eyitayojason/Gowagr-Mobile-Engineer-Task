import '../../data/models/event.dart';

/// Service for classifying events based on their characteristics
class EventClassificationService {
  /// Keywords that indicate a contestant-based event
  static const List<String> _contestantKeywords = [
    'wins',
    'winner',
    'award',
    'contestant',
    'candidate',
    'nominee',
    'number of',
    'posts',
    'players',
    'team',
    'artist',
    'singer',
  ];

  /// Keywords that indicate non-contestant markets
  static const List<String> _nonContestantKeywords = [
    'yes',
    'no',
    'up',
    'down',
    'above',
    'below',
    'between',
    'less than',
    'more than',
  ];

  /// Determine if an event should use the contestant-based card format
  static bool isContestantBasedEvent(Event event) {
    // Check if it's a Headies event
    if (event.title.contains('Headies')) {
      return true;
    }

    // Check if it's a contestant-based event (multiple markets with contestant names)
    if (event.markets.length >= 2) {
      return _hasContestantKeywords(event.title) ||
          _hasContestantMarkets(event.markets);
    }

    return false;
  }

  /// Check if the event title contains contestant-related keywords
  static bool _hasContestantKeywords(String title) {
    final titleLower = title.toLowerCase();
    return _contestantKeywords.any((keyword) => titleLower.contains(keyword));
  }

  /// Check if markets have contestant-like titles (not just Yes/No)
  static bool _hasContestantMarkets(List<Market> markets) {
    return markets.any((market) {
      final marketTitle = market.title.toLowerCase();
      return marketTitle.length > 5 && // Not just "Yes" or "No"
          !_nonContestantKeywords
              .any((keyword) => marketTitle.contains(keyword));
    });
  }
}
