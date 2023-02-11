import 'package:flutter/material.dart';
import 'package:yel/enums.dart';
import 'package:yel/models/task.dart';
import 'package:yel/repositories/local.dart';

class TasksProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];
  TasksFilter _filter = TasksFilter.undone;

  TasksProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    List<TaskModel> tasks = [];
    var data = await LocalRepository.read('tasks');
    if (data is List) {
      for (var e in data) {
        tasks.add(TaskModel.fromJson(e));
      }
      update(tasks);
    }
  }

  Future<void> _saveData() async {
    List<dynamic> data = [];
    for (var task in _tasks) {
      data.add(task.toJson());
    }
    await LocalRepository.save('tasks', data);
  }

  List<TaskModel> get tasks {
    var today = DateUtils.dateOnly(DateTime.now()).millisecondsSinceEpoch;
    return _tasks.where((element) {
      var end = DateTime.fromMillisecondsSinceEpoch(element.end);
      var condition = DateUtils.dateOnly(end).millisecondsSinceEpoch == today;
      switch (_filter) {
        case TasksFilter.done:
          return condition && element.done;
        case TasksFilter.undone:
          return condition && !element.done;
        default:
          return condition;
      }
    }).toList();
  }

  TasksFilter get filter {
    return _filter;
  }

  void add(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
    _saveData();
  }

  void remove(TaskModel task) {
    _tasks.remove(task);
    notifyListeners();
    _saveData();
  }

  void toggleDone(TaskModel task) {
    task.done = !task.done;
    notifyListeners();
    _saveData();
  }

  void update(List<TaskModel> tasks) {
    _tasks.clear();
    _tasks.insertAll(0, tasks);
    notifyListeners();
  }

  void setFilter(TasksFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  int get length => _tasks.length;
}
