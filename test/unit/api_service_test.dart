import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:gowagr_mobile/data/services/api_service.dart';
import 'package:mockito/mockito.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ApiService apiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiService = ApiService();
  });

  test('fetchEvents returns list of events', () async {
    // Mock the Dio response for the specific path '/public-events'
    when(mockDio.get('/public-events',
            queryParameters: anyNamed('queryParameters')))
        .thenAnswer((_) async => Response(
              data: {
                'events': [
                  {
                    'id': 1,
                    'title': 'Concert',
                    'description': 'Live music event',
                    'imageUrl': 'https://via.placeholder.com/150',
                    'category': 'Music',
                    'isTrending': true,
                  }
                ]
              },
              statusCode: 200,
              requestOptions: RequestOptions(path: '/public-events'),
            ));

    // Create a new ApiService instance with the mocked Dio
    apiService = ApiService(
        dio: mockDio); // Assuming ApiService accepts Dio in constructor

    final events = await apiService.fetchEvents(page: 1, size: 10);
    expect(events.length, 1);
    expect(events[0].title, 'Concert');
  });
}
