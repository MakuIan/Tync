import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tync/features/auth/application/auth_controller.dart';
import 'package:tync/core/constants/app_text_styles.dart';
import 'package:tync/core/constants/app_colors.dart';
import 'package:tync/core/constants/app_sizes.dart';

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
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.p24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dashboard_customize, size: 64, color: Colors.grey),
              SizedBox(height: AppSizes.p16),

              Text('Your Sessions', style: AppTextStyles.h1),
              SizedBox(height: AppSizes.p8),

              Text(
                'Create a new room or join one',
                style: AppTextStyles.label,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.p32),
            ],
          ),
        ),
      ),
    );
  }
}
