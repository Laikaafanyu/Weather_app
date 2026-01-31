import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}


class LoginRequested extends AuthEvent {
  final String email;
  final String password;


  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;


  @override
  List<Object?> get props => [email, password];
}

