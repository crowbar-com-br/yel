import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskModel {
  final int timestamp;
  final String title;
  int end;
  bool done = false;

  TaskModel(this.title, this.end)
      : timestamp = DateTime.now().millisecondsSinceEpoch,
        assert(end > DateUtils.dateOnly(DateTime.now()).millisecondsSinceEpoch);

  TaskModel.today(this.title)
      : timestamp = DateTime.now().millisecondsSinceEpoch,
        end = DateUtils.dateOnly(DateTime.now()).millisecondsSinceEpoch;

  TaskModel.fromJson(Map<String, dynamic> json)
      : timestamp = json['timestamp'],
        title = json['title'],
        end = json['end'],
        done = json['done'];

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'title': title,
        'end': end,
        'done': done,
      };

  @override
  int get hashCode => timestamp;

  @override
  bool operator ==(Object other) =>
      other is TaskModel && other.timestamp == timestamp;

  String get created => DateFormat.Hm().format(
      DateTime.fromMillisecondsSinceEpoch(timestamp)
  );
}
