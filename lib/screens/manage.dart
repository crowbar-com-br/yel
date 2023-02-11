import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yel/enums.dart';
import 'package:yel/models/task.dart';
import 'package:yel/providers/tasks.dart';

class Manage extends StatelessWidget {
  const Manage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: _TaskFilter(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _TaskList(),
          ),
        ],
      ),
      floatingActionButton: const _AddTask(),
    );
  }
}

class _TaskFilter extends StatelessWidget {
  const _TaskFilter({super.key});

  @override
  Widget build(BuildContext context) {
    var tasksProvider = Provider.of<TasksProvider>(context);
    return DropdownButton<TasksFilter>(
      value: tasksProvider.filter,
      items: TasksFilter.values
          .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
          .toList(),
      onChanged: (TasksFilter? filter) {
        tasksProvider.setFilter(filter ?? TasksFilter.undone);
      },
      icon: Icon(
        Icons.filter_list,
        color: Theme.of(context).appBarTheme.actionsIconTheme?.color,
      ),
      dropdownColor: Theme.of(context).appBarTheme.backgroundColor,
      style: TextStyle(
        color: Theme.of(context).appBarTheme.actionsIconTheme?.color,
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tasksProvider = Provider.of<TasksProvider>(context);
    return ListView.builder(
      itemCount: tasksProvider.tasks.length,
      itemBuilder: (context, index) => ListTile(
        leading: IconButton(
          icon: Icon(
            tasksProvider.tasks[index].done ? Icons.undo : Icons.done,
          ),
          onPressed: () {
            tasksProvider.toggleDone(tasksProvider.tasks[index]);
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            tasksProvider.remove(tasksProvider.tasks[index]);
          },
        ),
        title: Text(tasksProvider.tasks[index].title),
        subtitle: Text(tasksProvider.tasks[index].created),
      ),
      padding: const EdgeInsets.all(6),
    );
  }
}

class _AddTask extends StatefulWidget {
  const _AddTask({super.key});

  @override
  State<_AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<_AddTask> {
  final _titleController = TextEditingController();
  var _time = TimeOfDay.now();
  var _date = DateTime.now();

  void _add(BuildContext context, BuildContext superContext) {
    var tasksProvider = Provider.of<TasksProvider>(
      superContext,
      listen: false,
    );
    var task = TaskModel(_titleController.text, _date.millisecondsSinceEpoch);

    _titleController.clear();
    tasksProvider.add(task);
    Navigator.pop(context, 'Add');
  }

  Future _selectDate(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      firstDate: _date,
      initialDate: _date,
      lastDate: DateTime(_date.year + 1, _date.month, _date.day),
    );

    if (date != null) {
      setState(() {
        _date = DateTime(
          date.year,
          date.month,
          date.day,
          _time.hour,
          _time.minute,
          0,
        );
      });
    }
  }

  Future _selectTime(BuildContext context) async {
    var time = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (time != null) {
      setState(() {
        _time = time;
        _date = DateTime(
          _date.year,
          _date.month,
          _date.day,
          _time.hour,
          _time.minute,
          0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var superContext = context;
    return FloatingActionButton(
      onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              var textTime = _time.format(superContext);
              var textDate = DateFormat.yMd().format(_date);
              return AlertDialog(
                title: const Text('Add Task'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      InputDecorator(
                          decoration:
                              const InputDecoration(labelText: 'Time / Date'),
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () async {
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  await _selectTime(context);
                                  setState(() {
                                    textTime = _time.format(superContext);
                                  });
                                },
                                child: Text(textTime),
                              ),
                              TextButton(
                                onPressed: () async {
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  await _selectDate(context);
                                  setState(() {
                                    textDate = DateFormat.yMd().format(_date);
                                  });
                                },
                                child: Text(textDate),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () => _add(context, superContext),
                      child: const Text('Add')),
                ],
              );
            });
          }),
      child: const Icon(Icons.add),
    );
  }
}
