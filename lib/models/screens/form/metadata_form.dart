import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_tasks/blocks/tasks_block.dart';
import 'package:my_tasks/models/Task.dart';

class MetadataForm extends StatefulWidget {
  final Task task;
  final TasksBloc tasksBloc;

  MetadataForm({this.task, this.tasksBloc});

  @override
  _MetadataFormState createState() => _MetadataFormState();
}

class _MetadataFormState extends State<MetadataForm> {
  final _formKey = GlobalKey<FormState>();

  String _currentName;
  String _currentDescription;
  String _currentImg;
  DateTime _currentDueDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 170.0, horizontal: 60.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              'Update your Task Data',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              initialValue: widget.task?.name ?? '',
              decoration:
                  textInputDecoration.copyWith(hintText: 'Insert a Name'),
              validator: (val) => val.isEmpty ? 'Please Enter a Name' : null,
              onChanged: (val) => setState(() => _currentName = val),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              initialValue: widget.task?.description ?? '',
              decoration:
                  textInputDecoration.copyWith(hintText: 'Insert a description'),
              validator: (val) => val.isEmpty ? 'Please Enter a Description' : null,
              onChanged: (val) => setState(() => _currentDescription = val),
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              initialValue: widget.task?.img ?? '',
              decoration:
                  textInputDecoration.copyWith(hintText: 'Insert a Url Img'),
              validator: _isUrlValid,
              onChanged: (val) => setState(() => _currentImg = val),
            ),
            SizedBox(
              height: 20.0,
            ),
            DateTimeField(
              format: DateFormat("yyyy/MM/dd"),
              validator: (val) => (val == null) ? 'Please enter a due date' : null,
              decoration: textInputDecoration.copyWith(hintText: 'Insert a due Date'),
              initialValue: widget.task?.dueDate,
              enabled: widget.task?.dueDate == null ? true : false,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  _currentDueDate = date;
                  return date;
                } else {
                  _currentDueDate = date;
                  return currentValue;
                }
              },
            ),
            SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text(
                    'Add',
                    style: TextStyle(),
                  ),
                  onPressed: () => _save()
                ),
                SizedBox(
                  width: 20.0,
                ),
                RaisedButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(),
                  ),
                  onPressed: () => Navigator.pop(context)
                )
              ]
            )
          ],
        ),
      ),
    );
  }

  String _isUrlValid(String val) {
    bool _validURL = Uri.parse(val).isAbsolute;

    return _validURL ? null : 'Please enter a valid url!';
  }

  _save() {
    if (!_formKey.currentState.validate()) {
      return false;
    }

    Task newTask = Task(
        id: widget.task?.id,
        name: _currentName ?? widget.task?.name,
        description: _currentDescription ?? widget.task?.description,
        img: _currentImg ?? widget.task?.img,
        progress: widget.task?.progress ?? 0,
        dueDate: widget.task?.dueDate ?? _currentDueDate);

    newTask.id != null
        ? widget.tasksBloc.inSaveTask.add(newTask)
        : widget.tasksBloc.inAddTask.add(newTask);

    Navigator.pop(context);
  }
}

const textInputDecoration = InputDecoration(
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(/* color: Colors.pink,  */width: 2.0),
  ),
);
