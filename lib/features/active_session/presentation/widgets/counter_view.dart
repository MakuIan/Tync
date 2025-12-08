import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tync/core/constants/app_colors.dart';
import 'package:tync/core/constants/app_text_styles.dart';
import 'package:tync/features/tools/data/tools_repository.dart';
import 'big_button.dart';

class CounterView extends ConsumerWidget {
  final String sessionId;
  const CounterView({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(toolsRepositoryProvider);
    final stream = ref.watch(
      StreamProvider((ref) => repo.streamCounter(sessionId)),
    );
    return stream.when(
      data: (model) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Current Set', style: AppTextStyles.label),
          const SizedBox(height: 20),

          Text('${model.count}', style: AppTextStyles.timerBig),
          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BigButton(
                icon: Icons.remove,
                color: const Color.fromARGB(255, 100, 74, 74),
                iconColor: Colors.black,
                onTap: () => repo.incrementCounter(sessionId, -1),
              ),
              const SizedBox(width: 30),
              BigButton(
                icon: Icons.add,
                color: AppColors.primary,
                iconColor: Colors.white,
                onTap: () => repo.incrementCounter(sessionId, 1),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => repo.resetCounter(sessionId),
                child: const Text('Reset to 0'),
              ),
            ],
          ),
        ],
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
