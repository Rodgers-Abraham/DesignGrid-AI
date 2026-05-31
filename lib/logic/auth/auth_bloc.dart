import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart' as local;

class AuthBloc extends Bloc<AuthEvent, local.AuthState> {
  final FlutterSecureStorage _storage;
  final FirebaseAuth _auth;
  static const String _apiKeyField = 'gemini_api_key';
  
  StreamSubscription<User?>? _authSubscription;

  AuthBloc({
    FlutterSecureStorage? storage,
    FirebaseAuth? firebaseAuth,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _auth = firebaseAuth ?? FirebaseAuth.instance,
        super(const local.AuthState()) {
    
    // Listen to real-time auth changes from Firebase
    _authSubscription = _auth.authStateChanges().listen((user) {
      add(AuthStateChangedEvent(user != null));
    });

    on<AuthStateChangedEvent>((event, emit) {
      emit(state.copyWith(isAuthenticated: event.isAuthenticated, errorMessage: null));
    });

    on<ClearErrorEvent>((event, emit) {
      emit(state.copyWith(errorMessage: null));
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

    on<LoginEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.message));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: 'An unexpected error occurred.'));
      }
    });

    on<SignOutEvent>((event, emit) async {
      await _auth.signOut();
      emit(state.copyWith(isAuthenticated: false, errorMessage: null));
    });

    on<CreateAccountEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        if (credential.user != null) {
          await credential.user!.updateDisplayName(event.name);
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.message));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: 'Could not create account.'));
      }
    });

    on<DeleteAccountEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        await _auth.currentUser?.delete();
        await _storage.deleteAll();
        emit(const local.AuthState(
          isAuthenticated: false,
          isLoading: false,
        ));
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.message));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: 'Could not delete account.'));
      }
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        await _auth.currentUser?.updatePassword(event.newPassword);
        emit(state.copyWith(isLoading: false));
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.message));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: 'Could not update password.'));
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
