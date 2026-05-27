import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final String? apiKey;
  final bool bioAuthEnabled;
  final bool isLoading;

  const AuthState({
    this.apiKey,
    this.bioAuthEnabled = false,
    this.isLoading = false,
  });

  AuthState copyWith({
    String? apiKey,
    bool? bioAuthEnabled,
    bool? isLoading,
  }) {
    return AuthState(
      apiKey: apiKey ?? this.apiKey,
      bioAuthEnabled: bioAuthEnabled ?? this.bioAuthEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [apiKey, bioAuthEnabled, isLoading];
}
