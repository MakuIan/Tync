import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tync/core/constants/app_colors.dart';
import 'package:tync/features/active_session/presentation/widgets/counter_view.dart';
import 'package:tync/features/active_session/presentation/widgets/stopwatch_view.dart';
import 'package:tync/features/active_session/presentation/widgets/timer_view.dart';

// Hauptscreen mit Tabs (Timer|Stopwatch|Counter)
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training'),
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
      body: TabBarView(
        controller: _tabController,
        children: [
          CounterView(sessionId: widget.sessionId),
          TimerView(sessionId: widget.sessionId),
          StopwatchView(sessionId: widget.sessionId),
        ],
      ),
    );
  }
}
