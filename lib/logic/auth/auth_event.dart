import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends AuthEvent {}

class UpdateApiKeyLibraryEvent extends AuthEvent {
  final String apiKey;
  UpdateApiKeyLibraryEvent(this.apiKey);
  @override
  List<Object?> get props => [apiKey];
}

class ToggleBioAuthEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthStateChangedEvent extends AuthEvent {
  final bool isAuthenticated;
  AuthStateChangedEvent(this.isAuthenticated);
  @override
  List<Object?> get props => [isAuthenticated];
}

class SignOutEvent extends AuthEvent {}

class ClearErrorEvent extends AuthEvent {}

class CreateAccountEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  CreateAccountEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class DeleteAccountEvent extends AuthEvent {}

class ChangePasswordEvent extends AuthEvent {
  final String newPassword;
  ChangePasswordEvent(this.newPassword);
  @override
  List<Object?> get props => [newPassword];
}
