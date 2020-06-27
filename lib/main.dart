import 'package:flutter/material.dart';
import 'package:my_tasks/blocks/tasks_block.dart';
import 'package:my_tasks/blocks/bloc_provider.dart';
import 'package:my_tasks/screens/tab_bar.dart';

void main() {
  runApp(MyTasks());
}

class MyTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tasks',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: BlocProvider(
          bloc: TasksBloc(),
          child: TabAppBar()
        ),
    );
  }
}

