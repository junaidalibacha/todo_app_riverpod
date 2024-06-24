import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod_asyncvalue/models/todo_model.dart';
import 'package:todo_riverpod_asyncvalue/pages/providers/todo_item/todo_item_provider.dart';
import 'package:todo_riverpod_asyncvalue/pages/providers/todo_list/todo_list_provider.dart';

import '../providers/todo_filter/todo_filter_provider.dart';
import '../providers/todo_search/todo_search_provider.dart';

class ShowTodoList extends ConsumerStatefulWidget {
  const ShowTodoList({super.key});

  @override
  ConsumerState<ShowTodoList> createState() => _ShowTodoListState();
}

class _ShowTodoListState extends ConsumerState<ShowTodoList> {
  Widget prevTodoWidget = const SizedBox.shrink();
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      ref.read(todoListProvider);
    });
    super.initState();
  }

  List<Todo> filterTodos(List<Todo> allTodos) {
    // final todoListState = ref.watch(todoListProvider);
    final filter = ref.watch(todoFilterProvider);
    final search = ref.watch(todoSearchProvider);

    List<Todo> tempTodoList;

    tempTodoList = switch (filter) {
      Filter.all => allTodos,
      Filter.active => allTodos.where((todo) => !todo.completed).toList(),
      Filter.completed => allTodos.where((todo) => todo.completed).toList(),
    };

    if (search.isNotEmpty) {
      tempTodoList = tempTodoList
          .where(
              (todo) => todo.desc.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    return tempTodoList;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(todoListProvider, (previous, next) {
      next.whenOrNull(
        error: (error, st) {
          if (!next.isLoading) {
            log(st.toString());
            return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Error", textAlign: TextAlign.center),
                content: Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        },
      );
    });

    final todoListState = ref.watch(todoListProvider);

    return Expanded(
      child: todoListState.when(
        skipError: true,
        data: (todos) {
          return prevTodoWidget = todos.isEmpty
              ? const Center(
                  child: Text(
                    "Enter some todo",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView.separated(
                  itemCount: filterTodos(todos).length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.grey),
                  itemBuilder: (context, index) {
                    final todo = filterTodos(todos)[index];
                    return ProviderScope(
                      overrides: [todoItemProvider.overrideWithValue(todo)],
                      child: const TodoItem(),
                    );
                  },
                );
        },
        error: (error, _) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error.toString(), style: const TextStyle(fontSize: 20)),
            OutlinedButton(
              onPressed: () => ref.invalidate(todoListProvider),
              child: const Text("Please retry!"),
            ),
          ],
        ),
        loading: () => prevTodoWidget,
      ),
    );
  }
}

class TodoItem extends ConsumerWidget {
  const TodoItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("building TodoItem");
    final todoItem = ref.watch(todoItemProvider);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TodoEditDialog(todo: todoItem),
        );
      },
      leading: Checkbox(
        value: todoItem.completed,
        onChanged: (_) {
          ref.read(todoListProvider.notifier).toggleTodo(todoItem.id);
        },
      ),
      title: Text(todoItem.desc),
      trailing: IconButton(
        onPressed: () {
          showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => const ConfirmDeleteDialog(),
          ).then((value) {
            if (value == true) {
              ref.read(todoListProvider.notifier).removeTodo(todoItem.id);
            }
          });
        },
        icon: const Icon(Icons.delete),
      ),
    );
  }
}

class TodoEditDialog extends ConsumerStatefulWidget {
  const TodoEditDialog({
    super.key,
    required this.todo,
  });
  final Todo todo;

  @override
  ConsumerState<TodoEditDialog> createState() => _TodoEditDialogState();
}

class _TodoEditDialogState extends ConsumerState<TodoEditDialog> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _textController;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _textController = TextEditingController.fromValue(
      TextEditingValue(text: widget.todo.desc),
    );
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text('Edit Todo'),
        content: TextFormField(
          controller: _textController,
          autofocus: true,
          validator: (value) {
            if (value != null && value.isNotEmpty) return null;
            return "Value cannot be empty";
          },
          // decoration: InputDecoration(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                ref
                    .read(todoListProvider.notifier)
                    .editTodo(widget.todo.id, _textController.text);
                Navigator.pop(context);
              }
            },
            child: const Text("Edit"),
          ),
        ],
      ),
    );
  }
}

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Are you sure?"),
      content: const Text("Do you really want to delete?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
