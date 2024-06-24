import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_riverpod_asyncvalue/pages/providers/todo_list/todo_list_provider.dart';

import '../../models/todo_model.dart';

class TodoHeader extends ConsumerStatefulWidget {
  const TodoHeader({super.key});

  @override
  ConsumerState<TodoHeader> createState() => _TodoHeaderState();
}

class _TodoHeaderState extends ConsumerState<TodoHeader> {
  Widget prevTodoCountWidget = const SizedBox.shrink();

  Widget getActiveTodoCount(List<Todo> todos) {
    final totalCount = todos.length;
    final activeTodoCount = todos.where((todo) => !todo.completed).length;
    prevTodoCountWidget = Text(
      "($activeTodoCount/$totalCount) item${activeTodoCount != 1 ? 's' : ''} left",
      style: TextStyle(
        color: Colors.blue[900],
        fontSize: 18,
      ),
    );
    return prevTodoCountWidget;
  }

  @override
  Widget build(BuildContext context) {
    final todoListState = ref.watch(todoListProvider);

    todoListState.maybeWhen(
      skipLoadingOnRefresh: false,
      loading: () => context.loaderOverlay.show(),
      orElse: () => context.loaderOverlay.hide(),
    );

    return Row(
      children: [
        const Text(
          "TODO",
          style: TextStyle(fontSize: 36),
        ),
        const SizedBox(width: 10),
        todoListState.maybeWhen(
          data: (todos) => getActiveTodoCount(todos),
          orElse: () => prevTodoCountWidget,
        ),
      ],
    );
  }
}
