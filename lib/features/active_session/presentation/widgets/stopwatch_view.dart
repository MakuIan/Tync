import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tync/core/constants/app_colors.dart';
import 'package:tync/core/constants/app_text_styles.dart';
import 'package:tync/features/active_session/presentation/widgets/big_button.dart';
import 'package:tync/features/tools/data/tools_repository.dart';
import 'package:tync/features/active_session/presentation/widgets/live_timer_display.dart';

class StopwatchView extends ConsumerWidget {
  final String sessionId;
  const StopwatchView({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(toolsRepositoryProvider);
    final stream = ref.watch(
      StreamProvider((ref) => repo.streamStopwatch(sessionId)),
    );

    return stream.when(
      data: (model) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Training duration', style: AppTextStyles.label),
            const SizedBox(height: 20),

            LiveTimerDisplay(
              targetTime: model.startTime,
              isRunning: model.isRunning,
              isCountDown: false,
            ),

            const SizedBox(height: 20),

            if (!model.isRunning)
              BigButton(
                icon: Icons.play_arrow,
                color: AppColors.success,
                iconColor: Colors.white,
                onTap: () => repo.startStopwatch(sessionId),
              )
            else
              BigButton(
                icon: Icons.stop,
                color: AppColors.danger,
                iconColor: Colors.white,
                onTap: () => repo.resetStopwatch(sessionId),
              ),
          ],
        );
      },
      error: (e, _) => Center(child: Text('Error: $e')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
