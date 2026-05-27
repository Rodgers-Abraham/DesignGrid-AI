import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final String? apiKey;
  final bool bioAuthEnabled;
  final bool isLoading;
  final bool isAuthenticated;

  const AuthState({
    this.apiKey,
    this.bioAuthEnabled = false,
    this.isLoading = false,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    String? apiKey,
    bool? bioAuthEnabled,
    bool? isLoading,
    bool? isAuthenticated,
  }) {
    return AuthState(
      apiKey: apiKey ?? this.apiKey,
      bioAuthEnabled: bioAuthEnabled ?? this.bioAuthEnabled,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  @override
  List<Object?> get props => [apiKey, bioAuthEnabled, isLoading, isAuthenticated];
}
