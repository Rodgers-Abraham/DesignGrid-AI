import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final String? apiKey;
  final bool bioAuthEnabled;
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;

  const AuthState({
    this.apiKey,
    this.bioAuthEnabled = false,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
  });

  AuthState copyWith({
    String? apiKey,
    bool? bioAuthEnabled,
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
  }) {
    return AuthState(
      apiKey: apiKey ?? this.apiKey,
      bioAuthEnabled: bioAuthEnabled ?? this.bioAuthEnabled,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage, // We pass null to clear it
    );
  }

  @override
  List<Object?> get props => [apiKey, bioAuthEnabled, isLoading, isAuthenticated, errorMessage];
}
