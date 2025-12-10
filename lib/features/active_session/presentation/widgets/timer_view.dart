import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tync/core/constants/app_text_styles.dart';
import 'package:tync/features/active_session/presentation/widgets/live_timer_display.dart';
import 'package:tync/features/active_session/presentation/widgets/preset_button.dart';
import 'package:tync/features/tools/data/tools_repository.dart';
import 'package:tync/core/constants/app_colors.dart';

final timerStreamProvider = StreamProvider.family.autoDispose(
  (ref, String sessionId) =>
      ref.watch(toolsRepositoryProvider).streamTimer(sessionId),
);

class TimerView extends ConsumerWidget {
  final String sessionId;
  const TimerView({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(toolsRepositoryProvider);
    final stream = ref.watch(timerStreamProvider(sessionId));
    return stream.when(
      data: (model) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              model.isRunning ? 'Break underway' : 'Start Break',
              style: AppTextStyles.label,
            ),
            const SizedBox(height: 20),

            LiveTimerDisplay(
              key: ValueKey(model.isRunning),
              targetTime: model.isRunning
                  ? model.endTime
                  : DateTime.now().millisecondsSinceEpoch,
              isRunning: model.isRunning,
              isCountDown: false,
            ),

            const SizedBox(height: 20),

            if (!model.isRunning) ...[
              Wrap(
                spacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  PresetButton('30s', () => repo.startTimer(sessionId, 30000)),
                  PresetButton('60s', () => repo.startTimer(sessionId, 60000)),
                ],
              ),
            ] else
              ElevatedButton.icon(
                onPressed: () => repo.stopTimer(sessionId),
                label: const Text('Cancel break'),
                icon: const Icon(Icons.stop),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text(error.toString()),
    );
  }
}
