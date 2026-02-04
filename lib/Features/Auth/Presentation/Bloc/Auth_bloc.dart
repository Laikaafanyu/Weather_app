import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth firebaseAuth;

  AuthBloc(this.firebaseAuth) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
  }


  Future<void> _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final email = prefs.getString('email');

    if (userId != null && email != null) {
      emit(AuthAuthenticated(userId: userId, email: email));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// 🔹 Login
  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // Persist user info
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userCredential.user!.uid);
      await prefs.setString('email', userCredential.user!.email!);

      emit(AuthAuthenticated(
        userId: userCredential.user!.uid,
        email: userCredential.user!.email!,
      ));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Login failed"));
    }
  }

  /// 🔹 Register
  Future<void> _onRegister(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // Persist user info
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userCredential.user!.uid);
      await prefs.setString('email', userCredential.user!.email!);

      emit(AuthAuthenticated(
        userId: userCredential.user!.uid,
        email: userCredential.user!.email!,
      ));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Registration failed"));
    }
  }

  /// 🔹 Logout
  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await firebaseAuth.signOut();

    // Clear saved user data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    emit(AuthUnauthenticated());
  }
}
