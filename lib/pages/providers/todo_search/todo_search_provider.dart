import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_search_provider.g.dart';

@riverpod
class TodoSearch extends _$TodoSearch {
  @override
  String build() {
    return "";
  }

  void setSearchItem(String searchItem) {
    state = searchItem;
  }
}
