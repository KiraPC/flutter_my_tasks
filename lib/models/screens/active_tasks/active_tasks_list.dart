import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:flutter/material.dart';
import 'package:my_tasks/blocks/bloc_provider.dart';
import 'package:my_tasks/blocks/tasks_block.dart';
import 'package:my_tasks/models/Task.dart';
import 'package:my_tasks/screens/active_tasks/active_tasks_tile.dart';
import 'package:my_tasks/screens/form/metadata_form.dart';

class ActiveTasks extends StatefulWidget {
  ActiveTasks();

  @override
  _ActiveTasksState createState() => _ActiveTasksState();
}

class _ActiveTasksState extends State<ActiveTasks> {
  @override
  Widget build(BuildContext context) {
    TasksBloc _tasksBloc = BlocProvider.of<TasksBloc>(context);

    return Container(
      child: Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: AnimatedStreamList(
            streamList: _tasksBloc.tasks,
            itemBuilder: _buildAnimatedList,
            itemRemovedBuilder: _buildAnimatedList
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showForm(_tasksBloc),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _showForm(TasksBloc tasksBloc) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return MetadataForm(tasksBloc: tasksBloc);
        }
      );
  }

  Widget _buildAnimatedList(
      Task task, int index, BuildContext context, Animation<double> animation) {
    return SizeTransition(
        sizeFactor: animation, child: ActiveTaskTile(task: task));
  }
}
