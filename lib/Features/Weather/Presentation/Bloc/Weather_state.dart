import 'package:equatable/equatable.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final String city;
  final double temperature;
  final String description;
  final double wind;      // km/h
  final int humidity;     // %
  final String date;      // formatted date string

  const WeatherLoaded({
    required this.city,
    required this.temperature,
    required this.description,
    required this.wind,
    required this.humidity,
    required this.date,
  });

  @override
  List<Object?> get props => [city, temperature, description, wind, humidity, date];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}
