// Event model for data layer
class Event {
  final String id; // Changed to String as API uses UUID
  final String title;
  final String description;
  final String imageUrl;
  final String image128Url;
  final String category;
  final List<String> hashtags;
  final String status;
  final DateTime? resolutionDate;
  final String? resolutionSource;
  final List<String> supportedCurrencies;
  final double totalVolume;
  final int totalOrders;
  final DateTime createdAt;
  final List<Market> markets;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.image128Url,
    required this.category,
    required this.hashtags,
    required this.status,
    this.resolutionDate,
    this.resolutionSource,
    required this.supportedCurrencies,
    required this.totalVolume,
    required this.totalOrders,
    required this.createdAt,
    required this.markets,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      image128Url: json['image128Url'] ?? '',
      category: json['category'] ?? '',
      hashtags: List<String>.from(json['hashtags'] ?? []),
      status: json['status'] ?? '',
      resolutionDate: json['resolutionDate'] != null
          ? DateTime.parse(json['resolutionDate'])
          : null,
      resolutionSource: json['resolutionSource'],
      supportedCurrencies: List<String>.from(json['supportedCurrencies'] ?? []),
      totalVolume: (json['totalVolume'] ?? 0).toDouble(),
      totalOrders: json['totalOrders'] ?? 0,
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      markets: (json['markets'] as List? ?? [])
          .map((marketJson) => Market.fromJson(marketJson))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'image128Url': image128Url,
      'category': category,
      'hashtags': hashtags,
      'status': status,
      'resolutionDate': resolutionDate?.toIso8601String(),
      'resolutionSource': resolutionSource,
      'supportedCurrencies': supportedCurrencies,
      'totalVolume': totalVolume,
      'totalOrders': totalOrders,
      'createdAt': createdAt.toIso8601String(),
      'markets': markets.map((market) => market.toMap()).toList(),
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      image128Url: map['image128Url'] ?? '',
      category: map['category'] ?? '',
      hashtags: List<String>.from(map['hashtags'] ?? []),
      status: map['status'] ?? '',
      resolutionDate: map['resolutionDate'] != null
          ? DateTime.parse(map['resolutionDate'])
          : null,
      resolutionSource: map['resolutionSource'],
      supportedCurrencies: List<String>.from(map['supportedCurrencies'] ?? []),
      totalVolume: (map['totalVolume'] ?? 0).toDouble(),
      totalOrders: map['totalOrders'] ?? 0,
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      markets: (map['markets'] as List? ?? [])
          .map((marketMap) => Market.fromMap(marketMap))
          .toList(),
    );
  }

  // Helper getters
  bool get isTrending => totalVolume > 100; // Consider trending if volume > 100
  String get formattedVolume => _formatVolume(totalVolume);
  String get formattedOrders => totalOrders.toString();
  String get endDate =>
      resolutionDate != null ? _formatDate(resolutionDate!) : 'TBD';

  String _formatVolume(double volume) {
    if (volume >= 1000000) {
      return '₦${(volume / 1000000).toStringAsFixed(1)}M';
    } else if (volume >= 1000) {
      return '₦${(volume / 1000).toStringAsFixed(1)}K';
    } else {
      return '₦${volume.toStringAsFixed(0)}';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Ends Today';
    } else if (difference == 1) {
      return 'Ends Tomorrow';
    } else if (difference > 0) {
      // Format as "Ends 14th Oct."
      final day = date.day;
      final month = _getAbbreviatedMonth(date.month);
      final ordinalSuffix = _getOrdinalSuffix(day);

      return 'Ends $day$ordinalSuffix $month';
    } else {
      return 'Ended';
    }
  }

  String _getAbbreviatedMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  String _getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

// Market model for individual betting markets within an event
class Market {
  final String id;
  final String title;
  final String rules;
  final String imageUrl;
  final String image128Url;
  final double yesBuyPrice;
  final double noBuyPrice;
  final double yesPriceForEstimate;
  final double noPriceForEstimate;
  final String status;
  final String? resolvedOutcome;
  final double volumeValueYes;
  final double volumeValueNo;
  final double yesProfitForEstimate;
  final double noProfitForEstimate;

  Market({
    required this.id,
    required this.title,
    required this.rules,
    required this.imageUrl,
    required this.image128Url,
    required this.yesBuyPrice,
    required this.noBuyPrice,
    required this.yesPriceForEstimate,
    required this.noPriceForEstimate,
    required this.status,
    this.resolvedOutcome,
    required this.volumeValueYes,
    required this.volumeValueNo,
    required this.yesProfitForEstimate,
    required this.noProfitForEstimate,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      rules: json['rules'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      image128Url: json['image128Url'] ?? '',
      yesBuyPrice: (json['yesBuyPrice'] ?? 0).toDouble(),
      noBuyPrice: (json['noBuyPrice'] ?? 0).toDouble(),
      yesPriceForEstimate: (json['yesPriceForEstimate'] ?? 0).toDouble(),
      noPriceForEstimate: (json['noPriceForEstimate'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      resolvedOutcome: json['resolvedOutcome'],
      volumeValueYes: (json['volumeValueYes'] ?? 0).toDouble(),
      volumeValueNo: (json['volumeValueNo'] ?? 0).toDouble(),
      yesProfitForEstimate: (json['yesProfitForEstimate'] ?? 0).toDouble(),
      noProfitForEstimate: (json['noProfitForEstimate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'rules': rules,
      'imageUrl': imageUrl,
      'image128Url': image128Url,
      'yesBuyPrice': yesBuyPrice,
      'noBuyPrice': noBuyPrice,
      'yesPriceForEstimate': yesPriceForEstimate,
      'noPriceForEstimate': noPriceForEstimate,
      'status': status,
      'resolvedOutcome': resolvedOutcome,
      'volumeValueYes': volumeValueYes,
      'volumeValueNo': volumeValueNo,
      'yesProfitForEstimate': yesProfitForEstimate,
      'noProfitForEstimate': noProfitForEstimate,
    };
  }

  factory Market.fromMap(Map<String, dynamic> map) {
    return Market(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      rules: map['rules'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      image128Url: map['image128Url'] ?? '',
      yesBuyPrice: (map['yesBuyPrice'] ?? 0).toDouble(),
      noBuyPrice: (map['noBuyPrice'] ?? 0).toDouble(),
      yesPriceForEstimate: (map['yesPriceForEstimate'] ?? 0).toDouble(),
      noPriceForEstimate: (map['noPriceForEstimate'] ?? 0).toDouble(),
      status: map['status'] ?? '',
      resolvedOutcome: map['resolvedOutcome'],
      volumeValueYes: (map['volumeValueYes'] ?? 0).toDouble(),
      volumeValueNo: (map['volumeValueNo'] ?? 0).toDouble(),
      yesProfitForEstimate: (map['yesProfitForEstimate'] ?? 0).toDouble(),
      noProfitForEstimate: (map['noProfitForEstimate'] ?? 0).toDouble(),
    );
  }

  // Helper getters
  String get yesPriceFormatted => '₦${yesPriceForEstimate.toStringAsFixed(0)}';
  String get noPriceFormatted => '₦${noPriceForEstimate.toStringAsFixed(0)}';
  String get yesProfitFormatted =>
      '₦${yesProfitForEstimate.toStringAsFixed(0)}';
  String get noProfitFormatted => '₦${noProfitForEstimate.toStringAsFixed(0)}';
}
