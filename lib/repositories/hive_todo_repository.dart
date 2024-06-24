import 'dart:math';

import 'package:hive/hive.dart';
import 'package:todo_riverpod_asyncvalue/models/todo_model.dart';
import 'package:todo_riverpod_asyncvalue/repositories/todo_repository.dart';

const double _kProbOfError = 0.5;
const int _kDelayDuration = 1;

class HiveTodoRepository extends TodoRepository {
  final Box todoBox = Hive.box('todos');
  final Random _random = Random();

  Future<void> _wait() {
    return Future.delayed(const Duration(seconds: _kDelayDuration));
  }

  @override
  Future<List<Todo>> getTodos() async {
    await _wait();
    try {
      if (_random.nextDouble() < _kProbOfError) {
        throw "Fail to retrieve todos";
      }

      if (todoBox.length == 0) return [];

      return todoBox.values.map((e) {
        // dev.log("Box data: $e");
        return Todo.fromJson(Map<String, dynamic>.from(e));
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addTodo({required Todo todo}) async {
    await _wait();
    try {
      if (_random.nextDouble() < _kProbOfError) {
        throw "Fail to retrieve todos";
      }

      await todoBox.put(todo.id, todo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editTodo({required String id, required String desc}) async {
    await _wait();
    try {
      if (_random.nextDouble() < _kProbOfError) {
        throw "Fail to edit todo";
      }

      final todoMap = todoBox.get(id);
      todoMap['desc'] = desc;

      await todoBox.put(id, todoMap);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> toggleTodo({required String id}) async {
    await _wait();
    try {
      if (_random.nextDouble() < _kProbOfError) {
        throw "Fail to toggle todo";
      }

      final todoMap = todoBox.get(id);
      todoMap['completed'] = !todoMap['completed'];

      await todoBox.put(id, todoMap);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeTodo({required String id}) async {
    await _wait();
    try {
      if (_random.nextDouble() < _kProbOfError) {
        throw "Fail to remove todo";
      }

      await todoBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }
}
