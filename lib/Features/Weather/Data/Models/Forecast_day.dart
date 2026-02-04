import 'package:equatable/equatable.dart';

class Forecast extends Equatable {
  final DateTime dateTime;
  final double maxTemp;
  final double minTemp;
  final String condition;

  const Forecast({
    required this.dateTime,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date']; // e.g., "2026-02-03"
    final dateTime = DateTime.parse(dateStr);
    final day = json['day'];

    return Forecast(
      dateTime: dateTime,
      maxTemp: (day['maxtemp_c'] as num).toDouble(),
      minTemp: (day['mintemp_c'] as num).toDouble(),
      condition: day['condition']['text'],
    );
  }

  @override
  List<Object?> get props => [dateTime, maxTemp, minTemp, condition];
}

