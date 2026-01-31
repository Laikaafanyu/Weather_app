import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
      FetchWeather event,
      Emitter<WeatherState> emit,
      ) async {
    emit(WeatherLoading());

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Fake weather data
      emit(
        WeatherLoaded(
          city: event.city,
          temperature: 27.5,
          description: "Sunny",
          wind: 10.0,
          humidity: 65,
          date: "31 Jan 2026",
        ),
      );
    } catch (e) {
      emit(const WeatherError("Failed to load weather"));
    }
  }
}
