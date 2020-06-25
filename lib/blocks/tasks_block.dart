import 'dart:async';
import 'package:my_tasks/models/Task.dart';
import 'package:my_tasks/services/database_provider.dart';
import 'bloc_provider.dart';

class TasksBloc implements BlocBase {
  final _tasksController = StreamController<List<Task>>.broadcast();

  StreamSink<List<Task>> get _inTasks => _tasksController.sink;

  Stream<List<Task>> get tasks => _tasksController.stream;

  final _archivedTasksController = StreamController<List<Task>>.broadcast();

  Stream<List<Task>> get archivedTasks => _archivedTasksController.stream;

  final _addTaskController = StreamController<Task>.broadcast();
  StreamSink<Task> get inAddTask => _addTaskController.sink;

  final _saveTaskController = StreamController<Task>.broadcast();
  StreamSink<Task> get inSaveTask => _saveTaskController.sink;

  final _deleteTaskController = StreamController<int>.broadcast();
  StreamSink<int> get inDeleteTask => _deleteTaskController.sink;

  final _changePageController = StreamController<bool>.broadcast();
  StreamSink<bool> get inChangePage => _changePageController.sink;


  TasksBloc() {
    getTasks();
    getArchivedTasks();

    _addTaskController.stream.listen(_handleAddTask);
    _saveTaskController.stream.listen(_handleSaveTask);
    _deleteTaskController.stream.listen(_handleDeleteTask);
    _changePageController.stream.listen(_handleChangePage);
  }

  @override
  void dispose() {
    _tasksController.close();
    _addTaskController.close();
    _saveTaskController.close();
    _deleteTaskController.close();
    _archivedTasksController.close();
    _changePageController.close();
  }

  void getTasks() async {
    List<Task> tasks = await DBProvider.db.getActiveTasks();

    _inTasks.add(tasks);
  }

  void getArchivedTasks() async {
    List<Task> tasks = await DBProvider.db.getArchivedTasks();

    _archivedTasksController.sink.add(tasks);
  }

  void _handleAddTask(Task task) async {
    await DBProvider.db.newTask(task);

    getTasks();
  }

  void _handleSaveTask(Task task) async {
    await DBProvider.db.updateTask(task);

    getTasks();
    getArchivedTasks();
  }

  void _handleDeleteTask(int id) async {
    await DBProvider.db.deleteTask(id);

    getTasks();
    getArchivedTasks();
  }

  void _handleChangePage(bool) {
    getTasks();
    getArchivedTasks();
  }
}
