import 'package:dio/dio.dart';
import '../models/weather_model.dart';

class WeatherRepository {
  final Dio _dio = Dio();
  final String apiKey = 'cc38398ef30e4262919152946263101';

  // fetch weather and forecast
  Future<Weather> getWeather(String city, {int days = 3}) async {
    try {
      final response = await _dio.get(
        'https://api.weatherapi.com/v1/forecast.json',
        queryParameters: {
          'key': apiKey,
          'q': city,
          'days': days,
          'aqi': 'no',
          'alerts': 'no',
        },
      );

      // Check HTTP status
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load weather. Status code: ${response.statusCode}'
        );
      }

      // Check if API returned an error inside JSON
      if (response.data['error'] != null) {
        throw Exception(
            'API Error: ${response.data['error']['message']}'
        );
      }
      return Weather.fromJson(response.data);

    } on DioException catch (dioError) {
      // Handle Dio-specific errors
      String message = '';
      switch (dioError.type) {
        case DioExceptionType.connectionTimeout:
          message = 'Connection timeout. Please try again.';
          break;
        case DioExceptionType.receiveTimeout:
          message = 'Receive timeout. Please try again.';
          break;
        case DioExceptionType.badResponse:
          message =
          'Server error: ${dioError.response?.statusCode} ${dioError.response?.statusMessage}';
          break;
        case DioExceptionType.unknown:
          message = 'Network error. Check your connection.';
          break;
        default:
          message = 'Something went wrong: ${dioError.message}';
      }
      throw Exception(message);
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}

