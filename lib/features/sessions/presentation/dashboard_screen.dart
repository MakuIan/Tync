import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Required for context.pushNamed
import 'package:tync/core/constants/route_names.dart';
import 'package:tync/features/auth/application/auth_controller.dart';
import 'package:tync/core/constants/app_text_styles.dart';
import 'package:tync/core/constants/app_colors.dart';
import 'package:tync/core/constants/app_sizes.dart';

String generateSessionId() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rnd = Random();
  return String.fromCharCodes(
    Iterable.generate(4, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
  );
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: AppTextStyles.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.danger),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.p24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.dashboard_customize,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: AppSizes.p24),

              const Text('Ready to exercise?', style: AppTextStyles.h1),
              const SizedBox(height: AppSizes.p32),

              //Neues Training starten
              ElevatedButton.icon(
                onPressed: () {
                  final newId = generateSessionId();
                  context.pushNamed(
                    RouteNames.session,
                    pathParameters: {'sessionId': newId},
                  );
                },
                label: const Text('Start Training'),
                icon: const Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  textStyle: AppTextStyles.button,
                ),
              ),

              // ---------------------------
              const SizedBox(height: AppSizes.p16),

              // dem jetzigen Training beitreten
              OutlinedButton.icon(
                onPressed: () {
                  context.pushNamed(
                    RouteNames.session,
                    pathParameters: {'sessionId': 'Gym-Test'},
                  );
                },
                label: const Text("Join: 'Gym-Test'"),
                icon: const Icon(Icons.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
