import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:weather_app/features/auth/presentation/pages/register_page.dart';

// ✅ IMPORT WEATHER PAGE
import 'package:weather_app/features/weather/presentation/pages/weather_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("Logging in...")),
            );
        }

        if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text("Login successful")),
            );

          // ✅ NAVIGATE TO WEATHER DASHBOARD
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WeatherPage()),
          );
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.message)),
            );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                const SizedBox(height: 40),

            SizedBox(
              height: 200,
              child: Image.asset(
                "assets/images/login.png",
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 10),

             const Text(
          "Log in",
          style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          "Login with social networks",
          style: TextStyle(color: Colors.grey),
        ),

        const SizedBox(height: 15),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            socialButton(Icons.facebook),
            const SizedBox(width: 15),
            socialButton(Icons.camera_alt_outlined),
            const SizedBox(width: 15),
            socialButton(Icons.g_mobiledata),
          ],
        ),

        const SizedBox(height: 25),

        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Email required"
                    : null,
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty
                    ? "Password required"
                    : null,
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        TextButton(
          onPressed: () {},
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.grey),
          ),
        ),

        const SizedBox(height: 5),

        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                  LoginRequested(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  ),
                );
              }
            },
            child: const Text(
              "Log in",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),

        const SizedBox(height: 15),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RegisterPage(),
              ),
            );
          },
          child: const Text(
            "Sign up",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),

        const SizedBox(height: 20),
        ],
      ),
    ),
    ),
    ),
    );
  }

  Widget socialButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
