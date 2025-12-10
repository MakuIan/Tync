// Spricht mit Firebas Auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tync/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? "145409309228-3a4lpc0emrb52ec0b9krnlg78p17f7v9.apps.googleusercontent.com"
        : null,
    scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
  );

  final Logger _logger = Logger(printer: PrettyPrinter(methodCount: 0));

  AuthRepository(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    _logger.i("🛠️ START: signInWithGoogle aufgerufen");
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      _logger.i(
        "✅ SCHRITT 1: Google User Objekt erhalten: ${googleUser?.email}",
      );
      if (googleUser == null) {
        _logger.i("❌ ABBRUCH: User hat abgebrochen (null).");
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      _logger.i(
        "✅ SCHRITT 2: Tokens erhalten (Access: ${googleAuth.accessToken != null})",
      );

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      _logger.i("🛠️ SCHRITT 3: Sende Daten an Firebase...");
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      _logger.i(
        "🎉 ERFOLG: Firebase Login fertig! User ID: ${userCredential.user?.uid}",
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        _logger.w('Account exists with different credential', error: e);
        rethrow;
      }
    } catch (e, stackTrace) {
      _logger.e(
        'Error signing in with Google',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
    return null;
  }

  Future<void> signInAnonymously() async {
    await _firebaseAuth.signInAnonymously();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
