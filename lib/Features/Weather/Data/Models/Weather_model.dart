import 'package:equatable/equatable.dart';
import 'forecast_day.dart';


class Weather extends Equatable {
  final String city;
  final double temperature;
  final String description;
  final double wind;
  final int humidity;
  final DateTime dateTime;
  final List<Forecast> forecast;

  const Weather({
    required this.city,
    required this.temperature,
    required this.description,
    required this.wind,
    required this.humidity,
    required this.dateTime,
    this.forecast = const [],
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    final current = json['current'];

    final cityName = location['name'];
    final localTimeStr = location['localtime']; // e.g., "2026-02-02 14:30"
    final dateTime = DateTime.parse(localTimeStr.replaceAll(' ', 'T'));

    final temp = (current['temp_c'] as num).toDouble();
    final desc = current['condition']['text'];
    final wind = (current['wind_kph'] as num).toDouble();
    final humidity = current['humidity'] as int;

    // Parse forecast if available
    final forecastList = <Forecast>[];
    if (json['forecast']?['forecastday'] != null) {
      for (var f in json['forecast']['forecastday']) {
        forecastList.add(Forecast.fromJson(f));
      }
    }

    return Weather(
      city: cityName,
      temperature: temp,
      description: desc,
      wind: wind,
      humidity: humidity,
      dateTime: dateTime,
      forecast: forecastList,
    );
  }

  @override
  List<Object?> get props => [city, temperature, description, wind, humidity, dateTime, forecast];
}

