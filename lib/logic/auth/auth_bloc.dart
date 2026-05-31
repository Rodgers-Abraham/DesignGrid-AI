import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FlutterSecureStorage _storage;
  static const String _apiKeyField = 'gemini_api_key';
  static const String _sessionField = 'user_session';
  static const String _userNameField = 'user_name';
  static const String _userEmailField = 'user_email';

  AuthBloc({FlutterSecureStorage? storage}) 
      : _storage = storage ?? const FlutterSecureStorage(),
        super(const AuthState()) {
    
    on<LoadSettingsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final apiKey = await _storage.read(key: _apiKeyField);
      final session = await _storage.read(key: _sessionField);
      
      emit(state.copyWith(
        apiKey: apiKey, 
        isLoading: false,
        isAuthenticated: session != null,
      ));
    });

    on<UpdateApiKeyLibraryEvent>((event, emit) async {
      await _storage.write(key: _apiKeyField, value: event.apiKey);
      emit(state.copyWith(apiKey: event.apiKey));
    });

    on<ToggleBioAuthEvent>((event, emit) {
      emit(state.copyWith(bioAuthEnabled: !state.bioAuthEnabled));
    });

    on<LoginEvent>((event, emit) async {
      emit(state.copyWith(isAuthenticated: true));
      await _storage.write(key: _sessionField, value: 'active');
    });

    on<SignOutEvent>((event, emit) async {
      emit(state.copyWith(isAuthenticated: false));
      await _storage.delete(key: _sessionField);
    });

    on<CreateAccountEvent>((event, emit) async {
      emit(state.copyWith(isAuthenticated: true));
      await _storage.write(key: _userNameField, value: event.name);
      await _storage.write(key: _userEmailField, value: event.email);
      await _storage.write(key: _sessionField, value: 'active');
    });

    on<DeleteAccountEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await _storage.deleteAll();
      emit(const AuthState(
        isAuthenticated: false,
        isLoading: false,
      ));
    });
  }
}
