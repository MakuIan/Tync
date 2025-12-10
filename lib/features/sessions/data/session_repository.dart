// createSession, watchMySession, deleteSession
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:tync/features/sessions/domain/session_model.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(FirebaseDatabase.instance);
});

Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));

class SessionRepository {
  final FirebaseDatabase _db;
  SessionRepository(this._db);

  Stream<List<SessionModel>> watchUserSessions(String uid) {
    return _db.ref('sessions').orderByChild('ownerId').equalTo(uid).onValue.map(
      ((event) {
        if (event.snapshot.value == null) return [];

        try {
          final Map<dynamic, dynamic> data =
              event.snapshot.value as Map<dynamic, dynamic>;
          final list = data.entries.map((entry) {
            final map = entry.value as Map<dynamic, dynamic>;
            return SessionModel.fromSnapshot(entry.key, map);
          }).toList();
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        } catch (e) {
          logger.i('Error when parsing sessions: $e');
          return <SessionModel>[];
        }
      }),
    );
  }

  Future<String> createSession(String uid, {String name = 'Training'}) async {
    logger.i("🟡 REPO: createSession gestartet für User $uid");
    try {
      logger.i("🟡 REPO: DB Instanz ist: $_db");
      logger.i('🟡 REPO: DB URL: ${_db.app.options.databaseURL}');
      final ref = _db.ref('sessions').push();
      logger.i('🟡 REPO: Neue Key generiert: ${ref.key}');

      await ref.set({
        'ownerId': uid,
        'createdAt': ServerValue.timestamp,
        'name': name,
        'tools': {
          'stopwatch': {'isRunning': false, 'startTime': 0},
          'counter': {'count': 0},
        },
      });
      logger.i("🟢 REPO: Session erfolgreich erstellt!");
      return ref.key!;
    } catch (e, stack) {
      logger.i('🔴 REPO FEHLER: $e');
      logger.i(stack);
      rethrow;
    }
  }

  Future<void> deleteSession(String sessionId) async {
    await _db.ref('sessions/$sessionId').remove();
  }

  Stream<SessionModel?> watchSessionById(String sessionId) {
    return _db.ref('sessions/$sessionId').onValue.map((event) {
      final value = event.snapshot.value;

      if (value == null) return null;

      try {
        final map = value as Map<dynamic, dynamic>;
        return SessionModel.fromSnapshot(event.snapshot.key!, map);
      } catch (e) {
        logger.i('Error when loading session $sessionId: $e');
        return null;
      }
    });
  }
}
