import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import '../models/event.dart';
import '../../config/app_config.dart';

class ApiService {
  final Dio dio;

  ApiService({Dio? dio})
      : dio = dio ??
            Dio(BaseOptions(
              baseUrl: AppConfig.baseUrl,
              connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
              receiveTimeout: Duration(milliseconds: AppConfig.requestTimeout),
            ));

  Future<List<Event>> fetchEvents({
    int page = AppConfig.initialPage,
    int size = AppConfig.defaultPageSize,
    String? keyword,
    bool? trending,
    String? category,
  }) async {
    try {
      // Validate and sanitize parameters
      final safePage = page > 0 ? page : AppConfig.initialPage;
      final safeSize = AppConfig.getSafePageSize(size);

      final response =
          await dio.get(AppConfig.eventsEndpoint, queryParameters: {
        'page': safePage,
        'size': safeSize,
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        if (trending != null) 'trending': trending,
        if (category != null && category.isNotEmpty) 'category': category,
      });

      // Log the raw API response
      developer.log('API Response Status: ${response.statusCode}',
          name: 'ApiService');
      developer.log('API Response Data: ${response.data}', name: 'ApiService');

      // Validate response structure
      if (response.data == null) {
        throw Exception('Invalid API response: null data');
      }

      final data = response.data as Map<String, dynamic>;
      if (!data.containsKey('events')) {
        throw Exception('Invalid API response: missing events field');
      }

      final eventsList = data['events'] as List;
      final events = eventsList
          .map((json) {
            try {
              return Event.fromJson(json);
            } catch (e) {
              developer.log('Error parsing event: $e', name: 'ApiService');
              return null; // Return null for invalid events
            }
          })
          .where((event) => event != null) // Filter out null events
          .cast<Event>()
          .toList();

      // Log the parsed events
      developer.log('Parsed Events Count: ${events.length}',
          name: 'ApiService');
      for (int i = 0; i < events.length; i++) {
        developer.log('Event $i: ${events[i].title} (ID: ${events[i].id})',
            name: 'ApiService');
      }

      return events;
    } on DioException catch (e) {
      developer.log('Dio error: ${e.message}', name: 'ApiService', error: e);
      if (e.response != null) {
        developer.log('Response status: ${e.response!.statusCode}',
            name: 'ApiService');
        developer.log('Response data: ${e.response!.data}', name: 'ApiService');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      developer.log('API Error: $e', name: 'ApiService', error: e);
      throw Exception('Failed to fetch events: $e');
    }
  }
}
