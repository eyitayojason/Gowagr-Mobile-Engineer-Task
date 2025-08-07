// Database service for data layer
import 'package:gowagr_mobile/utils/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import '../models/event.dart';
import '../../config/app_config.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConfig.databaseName);
    return await openDatabase(
      path,
      version: AppConfig.cacheVersion, // Use configurable version
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE events (
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            imageUrl TEXT,
            image128Url TEXT,
            category TEXT,
            hashtags TEXT,
            status TEXT,
            resolutionDate TEXT,
            resolutionSource TEXT,
            supportedCurrencies TEXT,
            totalVolume REAL,
            totalOrders INTEGER,
            createdAt TEXT,
            markets TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < AppConfig.cacheVersion) {
          // Drop old table and recreate with new schema
          await db.execute('DROP TABLE IF EXISTS events');
          await db.execute('''
            CREATE TABLE events (
              id TEXT PRIMARY KEY,
              title TEXT,
              description TEXT,
              imageUrl TEXT,
              image128Url TEXT,
              category TEXT,
              hashtags TEXT,
              status TEXT,
              resolutionDate TEXT,
              resolutionSource TEXT,
              supportedCurrencies TEXT,
              totalVolume REAL,
              totalOrders INTEGER,
              createdAt TEXT,
              markets TEXT
            )
          ''');
        }
      },
    );
  }

  Future<void> cacheEvents(List<Event> events) async {
    try {
      final db = await database;
      final batch = db.batch();

      for (var event in events) {
        final eventMap = _eventToMap(event);
        batch.insert(
          'events',
          eventMap,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      // Log error but don't throw - caching failure shouldn't break the app
      Logger.error('Database caching error: $e');
    }
  }

  Future<List<Event>> getCachedEvents() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('events');
      return maps.map((map) => _mapToEvent(map)).toList();
    } catch (e) {
      Logger.error('Database retrieval error: $e');
      return [];
    }
  }

  // Helper method to convert Event to database map
  Map<String, dynamic> _eventToMap(Event event) {
    return {
      'id': event.id,
      'title': event.title,
      'description': event.description,
      'imageUrl': event.imageUrl,
      'image128Url': event.image128Url,
      'category': event.category,
      'hashtags': jsonEncode(event.hashtags), // Convert list to JSON string
      'status': event.status,
      'resolutionDate': event.resolutionDate?.toIso8601String(),
      'resolutionSource': event.resolutionSource,
      'supportedCurrencies':
          jsonEncode(event.supportedCurrencies), // Convert list to JSON string
      'totalVolume': event.totalVolume,
      'totalOrders': event.totalOrders,
      'createdAt': event.createdAt.toIso8601String(),
      'markets': jsonEncode(event.markets
          .map((m) => m.toMap())
          .toList()), // Convert markets to JSON string
    };
  }

  // Helper method to convert database map to Event
  Event _mapToEvent(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      image128Url: map['image128Url'] ?? '',
      category: map['category'] ?? '',
      hashtags: _parseJsonList(map['hashtags']),
      status: map['status'] ?? '',
      resolutionDate: map['resolutionDate'] != null
          ? DateTime.parse(map['resolutionDate'])
          : null,
      resolutionSource: map['resolutionSource'],
      supportedCurrencies: _parseJsonList(map['supportedCurrencies']),
      totalVolume: (map['totalVolume'] ?? 0).toDouble(),
      totalOrders: map['totalOrders'] ?? 0,
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      markets: _parseMarkets(map['markets']),
    );
  }

  // Helper method to parse JSON list
  List<String> _parseJsonList(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonString);
      return list.map((item) => item.toString()).toList();
    } catch (e) {
      Logger.error('Error parsing JSON list: $e');
      return [];
    }
  }

  // Helper method to parse markets from JSON
  List<Market> _parseMarkets(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return [];
    try {
      final List<dynamic> marketsList = jsonDecode(jsonString);
      return marketsList.map((marketMap) => Market.fromMap(marketMap)).toList();
    } catch (e) {
      Logger.error('Error parsing markets: $e');
      return [];
    }
  }

  // Clear all cached events
  Future<void> clearCache() async {
    try {
      final db = await database;
      await db.delete('events');
    } catch (e) {
      Logger.error('Error clearing cache: $e');
    }
  }
}
