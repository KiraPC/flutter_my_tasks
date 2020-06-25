import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/progress_bar/gf_progress_bar.dart';
import 'package:my_tasks/blocks/bloc_provider.dart';
import 'package:my_tasks/blocks/tasks_block.dart';
import 'package:my_tasks/models/Task.dart';
import 'package:my_tasks/screens/form/metadata_form.dart';

class ActiveTaskTile extends StatefulWidget {
  final Task task;

  ActiveTaskTile({this.task});

  @override
  _ActiveTaskTileState createState() => _ActiveTaskTileState();
}

class _ActiveTaskTileState extends State<ActiveTaskTile> {
  Future<void> _showForm({Task task, TasksBloc tasksBloc}) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return MetadataForm(task: task, tasksBloc: tasksBloc);
        });
  }

  void _onArchive(TasksBloc tasksBloc) {
    final snackBar = SnackBar(
        content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('${widget.task.name} Archived'),
          SizedBox(
            width: 60.0,
          ),
          IconButton(
              icon: Icon(Icons.undo),
              onPressed: () {
                widget.task.activate();
                tasksBloc.inSaveTask.add(widget.task);
                Scaffold.of(context).hideCurrentSnackBar();
              })
        ],
      )
    );

    Scaffold.of(context).showSnackBar(snackBar);
    widget.task.archive();
    tasksBloc.inSaveTask.add(widget.task);
  }

  void _updateProgress(String mathOp, TasksBloc tasksBloc) {
    switch (mathOp) {
      case '-':
        widget.task.progress -= 10;
        break;
      case '+':
        widget.task.progress += 10;
        break;
      default:
        widget.task.progress += 10;
    }

    widget.task.progress = widget.task.progress.round();
    tasksBloc.inSaveTask.add(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    TasksBloc _tasksBloc = BlocProvider.of<TasksBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25)
          )
        ),
        child: ListTile(
            onLongPress: () =>
                _showForm(task: widget.task, tasksBloc: _tasksBloc),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: widget.task.isExt
                    ? NetworkImage(widget.task.img)
                    : AssetImage('assets/${widget.task.img}'),
                ),
                Text(
                  widget.task.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.archive),
                  onPressed: () => _onArchive(_tasksBloc),
                  iconSize: 20.0,
                )
              ]
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '${widget.task.description}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left
                  )
                ),
                SizedBox(
                  height: 30.0,
                ),
                GFProgressBar(
                  percentage: widget.task.progress / 100,
                  lineHeight: 10,
                  child: Text(
                    '${widget.task.progress}%',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 8, color: Colors.white),
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: widget.task.progress == 100
                          ? null
                          : () => _updateProgress('+', _tasksBloc)
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: widget.task.progress == 0
                        ? null
                        : () => _updateProgress('-', _tasksBloc),
                  ),
                  backgroundColor: Colors.black26,
                  progressBarColor: _getProgressColor(),
                )
              ],
            )),
      ),
    );
  }

  _getProgressColor() {
    DateTime now = DateTime.now();

    if (widget.task.dueDate.isBefore(now)) {
      return GFColors.DANGER;
    }

    if (widget.task.dueDate.compareTo(now) == 0) {
      return GFColors.WARNING;
    }

    return GFColors.INFO;
  }
}
