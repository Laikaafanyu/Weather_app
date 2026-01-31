import 'package:dio/dio.dart';
import '../models/weather_model.dart';

class WeatherRepository {
  final Dio _dio = Dio();
  final String apiKey = 'cc38398ef30e4262919152946263101';

  /// Fetch current weather and forecast
  Future<Weather> getWeather(String city, {int days = 3}) async {
    try {
      final response = await _dio.get(
        'https://api.weatherapi.com/v1/forecast.json',
        queryParameters: {
          'key': apiKey,
          'q': city,
          'days': days,       // Number of forecast days
          'aqi': 'no',        // Optional: air quality
          'alerts': 'no',     // Optional: alerts
        },
      );

      return Weather.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}
