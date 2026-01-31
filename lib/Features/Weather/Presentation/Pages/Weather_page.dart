import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherBloc()..add(const FetchWeather("Semarang")),
      child: Scaffold(
        body: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is WeatherLoaded) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4FC3F7), Color(0xFF81D4FA)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Location + Notification
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              state.city,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Icon(Icons.arrow_drop_down, color: Colors.white),
                          ],
                        ),
                        Stack(
                          children: const [
                            Icon(Icons.notifications_none,
                                color: Colors.white, size: 28),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.red,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 50),
                    // Weather Icon
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: const [
                          Icon(Icons.cloud, size: 100, color: Colors.white),
                          Positioned(
                            top: 0,
                            left: 20,
                            child: Icon(Icons.wb_sunny, size: 50, color: Colors.yellow),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Temperature Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Today, ${state.date}",
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${state.temperature}°",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.description,
                            style: const TextStyle(color: Colors.white, fontSize: 20),
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
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Forecast Button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          elevation: 5,
                        ),
                        onPressed: () {
                          // Trigger forecast or navigate
                        },
                        child: const Text('Forecast report', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is WeatherError) {
              return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
