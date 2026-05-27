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
