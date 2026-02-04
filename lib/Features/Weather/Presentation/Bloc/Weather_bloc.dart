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

      final Weather weather = await weatherRepository.getWeather(event.city);

      if (weather.forecast.isEmpty) {
        emit(const WeatherError('No forecast data available for this city.'));
        return;
      }

      emit(WeatherLoaded(weather: weather));
    } on DioException catch (dioError) {
      emit(WeatherError('Network error: ${dioError.message}'));
    } catch (e) {
      emit(WeatherError('Unexpected error: $e'));
    }
  }
}

