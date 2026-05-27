import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FlutterSecureStorage _storage;
  static const String _apiKeyField = 'gemini_api_key';

  AuthBloc({FlutterSecureStorage? storage}) 
      : _storage = storage ?? const FlutterSecureStorage(),
        super(const AuthState()) {
    
    on<LoadSettingsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final apiKey = await _storage.read(key: _apiKeyField);
      emit(state.copyWith(apiKey: apiKey, isLoading: false));
    });

    on<UpdateApiKeyLibraryEvent>((event, emit) async {
      await _storage.write(key: _apiKeyField, value: event.apiKey);
      emit(state.copyWith(apiKey: event.apiKey));
    });

    on<ToggleBioAuthEvent>((event, emit) {
      emit(state.copyWith(bioAuthEnabled: !state.bioAuthEnabled));
    });
  }
}
