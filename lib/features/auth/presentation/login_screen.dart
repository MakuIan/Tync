import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tync/core/constants/app_colors.dart';
import 'package:tync/core/constants/app_text_styles.dart';
import 'package:tync/features/auth/application/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Fehler beim login: ${next.error.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    });
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.access_time_filled,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              const Text('Welcome to Tync', style: AppTextStyles.h1),
              const SizedBox(height: 24),
              const Text(
                'Synchonize time to all devices',
                textAlign: TextAlign.center,
                style: AppTextStyles.label,
              ),
              const SizedBox(height: 48),

              // Google Button
              if (authState.isLoading)
                const CircularProgressIndicator(color: AppColors.primary)
              else
                ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(authControllerProvider.notifier)
                        .signInWithGoogle();
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Login with Google'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.surface,
                    backgroundColor: Colors.black,
                    elevation: 2,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
