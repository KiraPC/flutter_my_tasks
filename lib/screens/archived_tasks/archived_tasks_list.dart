import 'package:flutter/material.dart';
import 'package:my_tasks/blocks/bloc_provider.dart';
import 'package:my_tasks/blocks/tasks_block.dart';
import 'package:my_tasks/models/Task.dart';
import 'package:my_tasks/screens/archived_tasks/archived_tasks_tile.dart';
import 'package:my_tasks/screens/archived_tasks/placeholder_text.dart';

class ArchivedTasks extends StatefulWidget {
  ArchivedTasks();

  @override
  _ArchivedTasksState createState() => _ArchivedTasksState();
}

class _ArchivedTasksState extends State<ArchivedTasks> {
  @override
  Widget build(BuildContext context) {
    TasksBloc _tasksBloc = BlocProvider.of<TasksBloc>(context);

    return StreamBuilder<List<Task>>(
      stream: _tasksBloc.archivedTasks,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          _tasksBloc.inChangePage.add(true);
          return Center(child: CircularProgressIndicator());
        }

        List<Task> tasks = snapshot.data;

        if (tasks.length == 0) {
          return PlaceholderText();
        }

        return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ArchivedTaskTile(task: tasks[index]);
            });
      }
    );
  }
}
