import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tync/core/constants/app_colors.dart';
import 'package:tync/features/active_session/presentation/widgets/counter_view.dart';
import 'package:tync/features/active_session/presentation/widgets/stopwatch_view.dart';
import 'package:tync/features/active_session/presentation/widgets/timer_view.dart';
import 'package:tync/features/sessions/data/session_repository.dart';
import 'package:tync/features/sessions/domain/session_model.dart';

// Hauptscreen mit Tabs (Timer|Stopwatch|Counter)

final sessionProvider = StreamProvider.family<SessionModel?, String>((
  ref,
  sessionId,
) {
  final repo = ref.watch(sessionRepositoryProvider);
  return repo.watchSessionById(sessionId);
});

class ActiveSessionScreen extends ConsumerStatefulWidget {
  final String sessionId;
  const ActiveSessionScreen({required this.sessionId, super.key});

  @override
  ConsumerState<ActiveSessionScreen> createState() =>
      _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends ConsumerState<ActiveSessionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(sessionProvider(widget.sessionId));
    return Scaffold(
      appBar: AppBar(
        title: sessionAsync.when(
          data: (session) => Text(session?.name ?? 'Loading'),
          error: (error, stackTrace) => const Text('Error'),
          loading: () => const Text('Loading'),
        ),
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.fitness_center), text: 'Set'),
            Tab(icon: Icon(Icons.timer), text: 'Break'),
            Tab(icon: Icon(Icons.history), text: 'Stopwatch'),
          ],
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
        ),
      ),
      body: sessionAsync.when(
        data: (session) {
          if (session == null) {
            return const Center(child: Text('Session not found'));
          }

          return TabBarView(
            controller: _tabController,
            children: [
              CounterView(sessionId: session.id),
              TimerView(sessionId: session.id),
              StopwatchView(sessionId: session.id),
            ],
          );
        },
        error: (error, stack) => Center(child: Text('Error: $error')),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
