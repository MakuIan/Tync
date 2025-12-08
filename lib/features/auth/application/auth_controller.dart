// State: LoggedIn, LoggedOut, Loading
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tync/features/auth/data/auth_repository.dart';

// Repository Provider
// Stellst sicher, dass wir Zugriff auf Auth-Funktionen haben
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(FirebaseAuth.instance),
);

// Auth State Stream Provider
// hoert auf Firebase.
//Sobald eingeloggt, liefert User Objekt.
// Wenn ausgeloggt, liefert null
final authStateChangesProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges,
);

// Controller Provider
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>(
      (ref) => AuthController(ref.watch(authRepositoryProvider)),
    );

// Controller Klasse
class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(const AsyncValue.data(null));

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.signInWithGoogle());
  }

  Future<void> signInAnonymously() async {
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(
      () => _authRepository.signInAnonymously(),
    );
    state = result;
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepository.signOut());
  }
}
