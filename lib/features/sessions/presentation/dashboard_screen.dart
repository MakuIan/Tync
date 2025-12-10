import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Required for context.pushNamed
import 'package:logger/logger.dart';
import 'package:tync/core/constants/route_names.dart';
import 'package:tync/features/auth/application/auth_controller.dart';
import 'package:tync/core/constants/app_text_styles.dart';
import 'package:tync/core/constants/app_colors.dart';
import 'package:tync/features/sessions/data/session_repository.dart';
import 'package:tync/features/sessions/domain/session_model.dart';
import 'package:tync/features/sessions/presentation/create_session_dialog.dart';

final userSessionsProvider = StreamProvider.family<List<SessionModel>, String>((
  ref,
  uid,
) {
  return ref.watch(sessionRepositoryProvider).watchUserSessions(uid);
});

Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Future<void> _showCreateSessionDialog(
    BuildContext context,
    WidgetRef ref,
    String uid,
  ) async {
    final String? enteredName = await showDialog<String>(
      context: context,
      builder: (context) => const CreateSessionDialog(),
    );

    if (enteredName != null) {
      try {
        final repo = ref.read(sessionRepositoryProvider);
        final newId = await repo.createSession(uid, name: enteredName);

        if (context.mounted) {
          context.pushNamed(
            RouteNames.session,
            pathParameters: {'sessionId': newId},
          );
        }
      } catch (e) {
        logger.e('Error when creating session', error: e);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error when creating session: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final user = authState.value;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final sessionsAsync = ref.watch(userSessionsProvider(user.uid));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Trainings', style: AppTextStyles.h2),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.danger),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
      //Start new Session Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _showCreateSessionDialog(context, ref, user.uid);
        },
        backgroundColor: AppColors.primary,
        label: const Text('Start New Session'),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
      body: sessionsAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return const Center(
              child: Text(
                'No Sessions found.\nClick on the + below',
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              final session = sessions[index];
              return _SessionCard(session: session);
            },
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemCount: sessions.length,
          );
        },
        error: (err, stack) {
          logger.e("Stream Error", error: err, stackTrace: stack);
          return Center(child: Text('Fehler beim Laden: $err'));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _SessionCard extends ConsumerWidget {
  final SessionModel session;
  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        onTap: () {
          context.pushNamed(
            RouteNames.session,
            pathParameters: {'sessionId': session.id},
          );
        },
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.fitness_center_outlined,
            color: AppColors.primary,
          ),
        ),
        title: Text(session.name, style: AppTextStyles.button),
        subtitle: Text(
          'Id ...${session.id.substring(session.id.length - 4)}',
          style: AppTextStyles.label,
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: AppColors.textSecondary),
          onPressed: () {
            ref.read(sessionRepositoryProvider).deleteSession(session.id);
          },
        ),
      ),
    );
  }
}
