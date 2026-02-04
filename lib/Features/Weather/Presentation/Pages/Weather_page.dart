import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';

import 'package:weather_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_event.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Timer timer;
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Fetch weather
    context.read<WeatherBloc>().add(const FetchWeather("Semarang"));

    // Live clock
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => currentTime = DateTime.now());
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  LinearGradient _getBackground(String description) {
    description = description.toLowerCase();
    if (description.contains('sun')) {
      return const LinearGradient(
        colors: [Color(0xFFFFF176), Color(0xFFFFB74D)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (description.contains('rain') || description.contains('storm')) {
      return const LinearGradient(
        colors: [Color(0xFF4FC3F7), Color(0xFF81D4FA)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (description.contains('cloud')) {
      return const LinearGradient(
        colors: [Color(0xFF90A4AE), Color(0xFFB0BEC5)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFF4FC3F7), Color(0xFF81D4FA)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  IconData _getWeatherIcon(String description) {
    description = description.toLowerCase();
    if (description.contains('sun')) return Icons.wb_sunny;
    if (description.contains('rain')) return Icons.beach_access;
    if (description.contains('storm')) return Icons.flash_on;
    if (description.contains('cloud')) return Icons.cloud;
    return Icons.wb_sunny;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WeatherLoaded) {
            final dateTime = state.dateTime; // ✅ Uses Weather.dateTime
            final formattedDate =
                "${dateTime.day.toString().padLeft(2,'0')}/${dateTime.month.toString().padLeft(2,'0')}/${dateTime.year}";
            final formattedTime =
                "${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}";

            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: _getBackground(state.description),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: location + logout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(state.city,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          const Icon(Icons.arrow_drop_down, color: Colors.white),
                        ],
                      ),
                      IconButton(
                        onPressed: () => _showLogoutDialog(context),
                        icon: const Icon(Icons.logout, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Weather Icon
                  Center(
                    child: Icon(
                      _getWeatherIcon(state.description),
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Temperature & description
                  Center(
                    child: Text("${state.temperature}°",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(state.description,
                        style: const TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text("Today, $formattedDate at $formattedTime",
                        style: const TextStyle(color: Colors.white70, fontSize: 16)),
                  ),
                  const SizedBox(height: 20),

                  // Wind & Humidity
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

                  // Forecast button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        elevation: 5,
                      ),
                      onPressed: () {},
                      child: const Text('Forecast report', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is WeatherError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.white, fontSize: 18)));
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const LogoutRequested());
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/login");
              },
              child: const Text("Logout")),
        ],
      ),
    );
  }
}

