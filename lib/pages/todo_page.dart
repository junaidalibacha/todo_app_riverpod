import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_riverpod_asyncvalue/pages/providers/theme/theme_provider.dart';
import 'package:todo_riverpod_asyncvalue/pages/providers/todo_list/todo_list_provider.dart';
import 'package:todo_riverpod_asyncvalue/pages/widgets/filter_todo.dart';
import 'package:todo_riverpod_asyncvalue/pages/widgets/new_todo.dart';
import 'package:todo_riverpod_asyncvalue/pages/widgets/search_todo.dart';
import 'package:todo_riverpod_asyncvalue/pages/widgets/show_todo.dart';
import 'package:todo_riverpod_asyncvalue/pages/widgets/todo_header.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const TodoHeader(),
        actions: [
          IconButton(
            onPressed: ref.read(themeProvider.notifier).toggleTheme,
            icon: const Icon(Icons.light_mode),
          ),
          IconButton(
            onPressed: () => ref.invalidate(todoListProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: LoaderOverlay(
        useDefaultLoading: false,
        // overlayColor: Colors.yellow.withOpacity(0.8),
        overlayWidgetBuilder: (_) => const Center(
          child: SpinKitFadingCircle(
            color: Colors.grey,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              NewTodo(),
              SizedBox(height: 20),
              SearchTodo(),
              SizedBox(height: 10),
              FilterTodo(),
              SizedBox(height: 10),
              ShowTodoList(),
            ],
          ),
        ),
      ),
    );
  }
}
