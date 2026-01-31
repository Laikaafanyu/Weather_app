import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:weather_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:weather_app/features/auth/presentation/pages/login_page.dart';
import 'package:weather_app/features/auth/presentation/pages/register_page.dart';

// ✅ WEATHER DASHBOARD PAGE
import 'package:weather_app/features/weather/presentation/pages/weather_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc(FirebaseAuth.instance),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',

        // ✅ START AT LOGIN
        initialRoute: '/login',

        routes: {
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),

          // ✅ WEATHER DASHBOARD ROUTE
          '/weather': (_) => const WeatherPage(),
        },
      ),
    );
  }
}
