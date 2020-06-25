import 'package:flutter/material.dart';
import 'package:my_tasks/blocks/bloc_provider.dart';
import 'package:my_tasks/blocks/tasks_block.dart';
import 'package:my_tasks/models/Task.dart';
import 'package:my_tasks/screens/archived_tasks/slider_backgroud.dart';

class ArchivedTaskTile extends StatefulWidget {
  final Task task;

  ArchivedTaskTile({this.task});

  @override
  _ArchivedTaskTileState createState() => _ArchivedTaskTileState();
}

class _ArchivedTaskTileState extends State<ArchivedTaskTile> {
  TasksBloc _tasksBloc;

  @override
  void initState() {
    _tasksBloc = BlocProvider.of<TasksBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
        child: Dismissible(
            key: Key('Task-${widget.task.id}'),
            background: SliderBackgroud(
                backgroud: Colors.blue,
                icon: Icons.unarchive,
                alignment: MainAxisAlignment.start),
            secondaryBackground: SliderBackgroud(
                backgroud: Colors.red,
                icon: Icons.delete,
                alignment: MainAxisAlignment.end),
            onDismissed: _onDismiss,
            child: ListTile(
              title: Text(
                '${widget.task.name}',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(right: 1.0),
                      child: Text(
                        '${widget.task.description}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60.0,
                  ),
                  Text(
                    '${widget.task.progress}%',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.0),
                  )
                ]
              ),
            )));
  }

  _onDismiss(direction) {
    if (direction == DismissDirection.endToStart) {
      return _tasksBloc.inDeleteTask.add(widget.task.id);
    }

    widget.task.activate();
    _tasksBloc.inSaveTask.add(widget.task);
  }
}
