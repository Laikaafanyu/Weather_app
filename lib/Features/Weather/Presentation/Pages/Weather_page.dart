import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';

import 'package:weather_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_event.dart';
import 'forecast_page.dart';
import '../../data/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late Timer timer;
  DateTime currentTime = DateTime.now();

  final List<String> cameroonCities = [
    'Buea',
    'Douala',
    'Yaoundé',
    'Garoua',
    'Limbe',
    'Bamenda',
  ];

  String selectedCity = 'Buea'; // default city

  @override
  void initState() {
    super.initState();
    _fetchWeather();

    // Update clock every second
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => currentTime = DateTime.now());
    });
  }

  void _fetchWeather() {
    context.read<WeatherBloc>().add(FetchWeather(selectedCity));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  LinearGradient _getBackground(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('sun') || desc.contains('clear') || desc.contains('shine')) {
      return const LinearGradient(
        colors: [Color(0xFFFFF176), Color(0xFFFFB74D)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (desc.contains('rain') || desc.contains('drizzle') || desc.contains('storm') || desc.contains('shower')) {
      return const LinearGradient(
        colors: [Color(0xFF4FC3F7), Color(0xFF81D4FA)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (desc.contains('cloud') || desc.contains('overcast')) {
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
    final desc = description.toLowerCase();
    if (desc.contains('sun') || desc.contains('clear') || desc.contains('shine')) return Icons.wb_sunny;
    if (desc.contains('rain') || desc.contains('drizzle') || desc.contains('shower')) return Icons.beach_access;
    if (desc.contains('storm') || desc.contains('thunder')) return Icons.flash_on;
    if (desc.contains('cloud') || desc.contains('overcast')) return Icons.cloud;
    return Icons.wb_sunny;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is WeatherLoaded) {
              final weather = state.weather;

              final formattedDate =
                  "${currentTime.day.toString().padLeft(2, '0')}/"
                  "${currentTime.month.toString().padLeft(2, '0')}/"
                  "${currentTime.year}";
              final formattedTime =
                  "${currentTime.hour.toString().padLeft(2, '0')}:"
                  "${currentTime.minute.toString().padLeft(2, '0')}:"
                  "${currentTime.second.toString().padLeft(2, '0')}";

              return _buildWeatherContent(weather, formattedDate, formattedTime);
            }

            if (state is WeatherError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchWeather,
                      child: const Text('Retry'),
                    )
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildWeatherContent(Weather weather, String formattedDate, String formattedTime) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: _getBackground(weather.description),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Native dropdown
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCity,
                  dropdownColor: Colors.blue,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  onChanged: (value) {
                    if (value != null && value != selectedCity) {
                      setState(() => selectedCity = value);
                      _fetchWeather();
                    }
                  },
                  items: cameroonCities
                      .map((city) => DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  ))
                      .toList(),
                ),
              ),

              // Logout button
              IconButton(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout, color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 30),

          Center(
            child: Icon(
              _getWeatherIcon(weather.description),
              size: 100,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),

          // Temperature
          Center(
            child: Text("${weather.temperature}°",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),

          Center(
            child: Text(weather.description,
                style: const TextStyle(color: Colors.white, fontSize: 20)),
          ),
          const SizedBox(height: 8),

          Center(
            child: Text("Today, $formattedDate at $formattedTime",
                style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ),
          const SizedBox(height: 20),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Icon(Icons.air, color: Colors.white),
                  const SizedBox(height: 4),
                  Text('Wind\n${weather.wind} km/h',
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.opacity, color: Colors.white),
                  const SizedBox(height: 4),
                  Text('Hum\n${weather.humidity}%',
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForecastPage()),
                );
              },
              child: const Text('Forecast report', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
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

