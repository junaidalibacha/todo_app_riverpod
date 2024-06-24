import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod_asyncvalue/models/todo_model.dart';
import 'package:todo_riverpod_asyncvalue/pages/providers/todo_list/todo_list_provider.dart';

class NewTodo extends ConsumerStatefulWidget {
  const NewTodo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewTodoState();
}

class _NewTodoState extends ConsumerState<NewTodo> {
  final _todoDescController = TextEditingController();
  bool hasPreviousData = false;

  @override
  void dispose() {
    _todoDescController.dispose();
    super.dispose();
  }

  bool enableOrNot(AsyncValue<List<Todo>> state) {
    return state.when(
      data: (data) => hasPreviousData = true,
      error: (_, __) => !hasPreviousData ? false : true,
      loading: () => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoListState = ref.watch(todoListProvider);

    return TextField(
      controller: _todoDescController,
      enabled: enableOrNot(todoListState),
      decoration: const InputDecoration(labelText: "What to do?"),
      onSubmitted: (desc) {
        if (desc.trim().isNotEmpty) {
          ref.read(todoListProvider.notifier).addTodo(desc);
          _todoDescController.clear();
        }
      },
    );
  }
}
