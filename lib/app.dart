import 'package:flutter/material.dart';
import 'package:tync/core/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Tync',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      routerConfig: goRouter,
    );
  }
}
