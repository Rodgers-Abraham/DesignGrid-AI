import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FlutterSecureStorage _storage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _apiKeyField = 'gemini_api_key';
  
  StreamSubscription<User?>? _authSubscription;

  AuthBloc({FlutterSecureStorage? storage}) 
      : _storage = storage ?? const FlutterSecureStorage(),
        super(const AuthState()) {
    
    // Listen to real-time auth changes from Firebase
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user != null) {
        add(LoginEvent()); // Update state to authenticated
      } else {
        add(SignOutEvent()); // Update state to unauthenticated
      }
    });

    on<LoadSettingsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final apiKey = await _storage.read(key: _apiKeyField);
      final user = _auth.currentUser;
      
      emit(state.copyWith(
        apiKey: apiKey, 
        isLoading: false,
        isAuthenticated: user != null,
      ));
    });

    on<UpdateApiKeyLibraryEvent>((event, emit) async {
      await _storage.write(key: _apiKeyField, value: event.apiKey);
      emit(state.copyWith(apiKey: event.apiKey));
    });

    on<ToggleBioAuthEvent>((event, emit) {
      emit(state.copyWith(bioAuthEnabled: !state.bioAuthEnabled));
    });

    on<LoginEvent>((event, emit) {
      emit(state.copyWith(isAuthenticated: _auth.currentUser != null));
    });

    on<SignOutEvent>((event, emit) async {
      await _auth.signOut();
      emit(state.copyWith(isAuthenticated: false));
    });

    on<CreateAccountEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        if (credential.user != null) {
          await credential.user!.updateDisplayName(event.name);
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
