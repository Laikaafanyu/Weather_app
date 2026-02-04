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
      // Fetch real weather data from repository
      final Weather weather = await weatherRepository.getWeather(event.city);

      emit(
        WeatherLoaded(
          city: weather.city,
          temperature: weather.temperature,
          description: weather.description,
          wind: weather.wind,
          humidity: weather.humidity,
          date: weather.date, // ✅ Use 'date' from model
        ),
      );
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}

