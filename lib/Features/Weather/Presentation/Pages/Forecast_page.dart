import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';
import '../../data/models/weather_model.dart'; // Import the correct weather and Forecast models

class ForecastPage extends StatelessWidget {
  const ForecastPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3-Day Forecast'),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WeatherLoaded) {
            final forecast = state.weather.forecast; // ✅ Access forecast via weather

            if (forecast.isEmpty) {
              return const Center(
                child: Text('No forecast data available'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: forecast.length,
              itemBuilder: (context, index) {
                final day = forecast[index];

                final date =
                    "${day.dateTime.day.toString().padLeft(2, '0')}/"
                    "${day.dateTime.month.toString().padLeft(2, '0')}/"
                    "${day.dateTime.year}";

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Icon(
                      _getWeatherIcon(day.condition),
                      color: Colors.blue,
                      size: 32,
                    ),
                    title: Text(
                      date,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(day.condition),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${day.maxTemp.toStringAsFixed(0)}°",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          "${day.minTemp.toStringAsFixed(0)}°",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is WeatherError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }

  IconData _getWeatherIcon(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('sun') || desc.contains('clear')) return Icons.wb_sunny;
    if (desc.contains('rain') || desc.contains('drizzle') || desc.contains('shower')) return Icons.beach_access;
    if (desc.contains('storm') || desc.contains('thunder')) return Icons.flash_on;
    if (desc.contains('cloud') || desc.contains('overcast')) return Icons.cloud;
    return Icons.wb_cloudy;
  }
}
