import 'package:equatable/equatable.dart';
import '../../data/models/weather_model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather; // Store full Weather object

  const WeatherLoaded({required this.weather});

  // Convenience getters for UI
  String get city => weather.city;
  double get temperature => weather.temperature;
  String get description => weather.description;
  double get wind => weather.wind;
  int get humidity => weather.humidity;
  DateTime get dateTime => weather.dateTime;

  @override
  List<Object?> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}
