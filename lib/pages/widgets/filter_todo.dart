import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recase/recase.dart';
import 'package:todo_riverpod_asyncvalue/models/todo_model.dart';
import 'package:todo_riverpod_asyncvalue/pages/providers/todo_filter/todo_filter_provider.dart';

class FilterTodo extends ConsumerWidget {
  const FilterTodo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: Filter.values.length,
      child: TabBar(
        labelStyle: const TextStyle(fontSize: 18),
        labelPadding: EdgeInsets.zero,
        tabs: Filter.values.map((e) => Text(e.name.titleCase)).toList(),
        onTap: (value) => ref
            .read(todoFilterProvider.notifier)
            .changeFilter(Filter.values[value]),
      ),
    );
  }
}
