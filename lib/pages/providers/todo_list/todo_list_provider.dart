import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_riverpod_asyncvalue/models/todo_model.dart';
import 'package:todo_riverpod_asyncvalue/repositories/providers/todos_repository_provider.dart';

part 'todo_list_provider.g.dart';

@riverpod
class TodoList extends _$TodoList {
  @override
  FutureOr<List<Todo>> build() {
    print("[todoListProvider] initialized");
    ref.onDispose(() {
      print("[todoListProvider] disposed");
    });
    return _getTodos();
  }

  Future<List<Todo>> _getTodos() async {
    return await ref.read(todoRepositoryProvider).getTodos();
  }

  Future<void> addTodo(String desc) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final newTodo = Todo.add(desc: desc);

      await ref.read(todoRepositoryProvider).addTodo(todo: newTodo);

      return [...state.value!, newTodo];
    });
  }

  Future<void> editTodo(String id, String desc) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(todoRepositoryProvider).editTodo(id: id, desc: desc);

      return state.value!
          .map((todo) => todo.id == id ? todo.copyWith(desc: desc) : todo)
          .toList();
    });
  }

  Future<void> toggleTodo(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(todoRepositoryProvider).toggleTodo(id: id);

      return state.value!
          .map((todo) =>
              todo.id == id ? todo.copyWith(completed: !todo.completed) : todo)
          .toList();
    });
  }

  Future<void> removeTodo(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(todoRepositoryProvider).removeTodo(id: id);

      return state.value!.where((todo) => todo.id != id).toList();
    });
  }
}
