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

class LoginEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

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
