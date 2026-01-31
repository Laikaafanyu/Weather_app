import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';

  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WeatherLoaded) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white),
                          const SizedBox(width: 8),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                          const Icon(Icons.arrow_drop_down, color: Colors.white),
                        ],
                      ),
                      ),
                    ],
                  ),
                  // Weather Icon
                  Center(
                    ),
                  ),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                  ),
                  const SizedBox(height: 8),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.air, color: Colors.white),
                          const SizedBox(height: 4),
                          Text('Wind\n${state.wind} km/h',
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(Icons.opacity, color: Colors.white),
                          const SizedBox(height: 4),
                          Text('Hum\n${state.humidity}%',
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        elevation: 5,
                      ),
                      child: const Text('Forecast report', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is WeatherError) {
            return Center(
          }

          return const SizedBox();
        },
      ),
      ),
    );
  }
}
