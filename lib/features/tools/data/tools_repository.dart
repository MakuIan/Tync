import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tync/features/tools/domain/tool_models.dart';

final toolsRepositoryProvider = Provider<ToolsRepository>((ref) {
  return ToolsRepository(FirebaseDatabase.instance);
});

class ToolsRepository {
  final FirebaseDatabase _db;
  ToolsRepository(this._db);

  Stream<CounterModel> streamCounter(String sessionId) {
    return _db
        .ref('sessions/$sessionId/tools/counter')
        .onValue
        .map((event) => CounterModel.fromMap(event.snapshot.value as Map?));
  }

  Stream<StopwatchModel> streamStopwatch(String sessionId) {
    return _db
        .ref('sessions/$sessionId/tools/stopwatch')
        .onValue
        .map((event) => StopwatchModel.fromMap(event.snapshot.value as Map?));
  }

  Stream<TimerModel> streamTimer(String sessionId) {
    return _db
        .ref('sessions/$sessionId/tools/timer')
        .onValue
        .map((event) => TimerModel.fromMap(event.snapshot.value as Map?));
  }

  Future<void> incrementCounter(String sessionId, int delta) async {
    final ref = _db.ref('sessions/$sessionId/tools/counter/count');
    await ref.runTransaction((currentData) {
      final val = (currentData as int? ?? 0);
      return Transaction.success(val + delta);
    });
  }

  Future<void> resetCounter(String sessionId) async {
    await _db.ref('sessions/$sessionId/tools/counter/count').set(0);
  }

  Future<void> startStopwatch(String sessionId) async {
    await _db.ref('sessions/$sessionId/tools/stopwatch').set({
      'isRunning': true,
      'startTime': ServerValue.timestamp,
    });
  }

  Future<void> resetStopwatch(String sessionId) async {
    await _db.ref('sessions/$sessionId/tools/stopwatch').set({
      'isRunning': false,
      'startTime': 0,
    });
  }

  Future<void> startTimer(String sessionId, int durationMs) async {
    final int targetTime = DateTime.now().millisecondsSinceEpoch + durationMs;

    await _db.ref('sessions/$sessionId/tools/timer').set({
      'isRunning': true,
      'endTime': targetTime,
      'originalDuration': durationMs,
    });
  }

  Future<void> stopTimer(String sessionId) async {
    await _db.ref('sessions/$sessionId/tools/timer/isRunning').set(false);
  }
}
