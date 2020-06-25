import 'package:flutter/material.dart';
import 'package:my_tasks/screens/active_tasks/active_tasks_list.dart';
import 'package:my_tasks/screens/archived_tasks/archived_tasks_list.dart';

class TabAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.archive))
            ],
          ),
          title: Text('My Tasks'),
        ),
        body: TabBarView(
          children: [
            ActiveTasks(),
            ArchivedTasks(),
          ],
        ),
      ),
    );
  }
}
