import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_riverpod_asyncvalue/pages/providers/theme/theme_provider.dart';
import 'package:todo_riverpod_asyncvalue/pages/providers/theme/theme_state.dart';
import 'package:todo_riverpod_asyncvalue/repositories/providers/todos_repository_provider.dart';

import 'pages/todo_page.dart';
import 'repositories/hive_todo_repository.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('todos');

  runApp(
    ProviderScope(
      overrides: [
        todoRepositoryProvider.overrideWithValue(HiveTodoRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Todo',
      debugShowCheckedModeBanner: false,
      theme: switch (appTheme) {
        LightTheme() => ThemeData.light(),
        DarkTheme() => ThemeData.dark(),
      },
      home: const TodoPage(),
    );
  }
}
