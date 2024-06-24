import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod_asyncvalue/pages/providers/todo_search/todo_search_provider.dart';
import 'package:todo_riverpod_asyncvalue/utils/debounce.dart';

class SearchTodo extends ConsumerStatefulWidget {
  const SearchTodo({super.key});

  @override
  ConsumerState<SearchTodo> createState() => _SearchTodoState();
}

class _SearchTodoState extends ConsumerState<SearchTodo> {
  final Debounce _debounce = Debounce(milliseconds: 1000);

  @override
  void dispose() {
    _debounce.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: "Search todo...",
        border: InputBorder.none,
        filled: true,
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          _debounce.run(() {
            ref.read(todoSearchProvider.notifier).setSearchItem(value);
          });
        }
      },
    );
  }
}
