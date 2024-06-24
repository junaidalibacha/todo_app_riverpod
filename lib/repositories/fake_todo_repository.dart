import 'dart:math';

import 'package:todo_riverpod_asyncvalue/models/todo_model.dart';
import 'package:todo_riverpod_asyncvalue/repositories/todo_repository.dart';

const List<Map<String, dynamic>> _initialTodos = [
  {"id": "1", "desc": "Clean the room", "completed": false},
  {"id": "2", "desc": "Wash the dish", "completed": false},
  {"id": "3", "desc": "Do homework", "completed": false},
];
const double _kProbOfError = 0.5;
const int _kDelayDuration = 1;

class FakeTodoRepository extends TodoRepository {
  List<Map<String, dynamic>> _fakeTodos = _initialTodos;
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
      return _fakeTodos.map((e) => Todo.fromJson(e)).toList();
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
      _fakeTodos = [..._fakeTodos, todo.toJson()];
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
      _fakeTodos = _fakeTodos
          .map(
            (todo) => todo['id'] == id
                ? {
                    "id": id,
                    "desc": desc,
                    "completed": todo['completed'],
                  }
                : todo,
          )
          .toList();
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
      _fakeTodos = _fakeTodos
          .map(
            (todo) => todo['id'] == id
                ? {
                    "id": id,
                    "desc": todo['desc'],
                    "completed": !todo['completed'],
                  }
                : todo,
          )
          .toList();
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
      _fakeTodos = _fakeTodos.where((todo) => todo['id'] != id).toList();
    } catch (e) {
      rethrow;
    }
  }
}
