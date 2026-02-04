import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/weather_model.dart';
import '../../data/repositories/weather_repository.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
      FetchWeather event,
      Emitter<WeatherState> emit,
      ) async {
    emit(WeatherLoading());

    try {
      // Fetch weather from repository
      final Weather weather = await weatherRepository.getWeather(event.city);

      // Check if forecast is empty (optional validation)
      if (weather.forecast.isEmpty) {
        emit(const WeatherError('No forecast data available for this city.'));
        return;
      }

      emit(WeatherLoaded(weather: weather));
    } on DioException catch (dioError) {
      // Handle Dio-specific errors (network, timeout, etc.)
      emit(WeatherError('Network error: ${dioError.message}'));
    } catch (e) {
      // Handle all other errors
      emit(WeatherError('Unexpected error: $e'));
    }
  }
}

