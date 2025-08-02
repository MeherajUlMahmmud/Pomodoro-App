import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomodoro/models/task.dart';
import 'package:pomodoro/services/sync_service.dart';

class TaskService {
  static const String _tasksKey = 'pomodoro_tasks';
  final SyncService _syncService = SyncService();

  // Save a task
  Future<void> saveTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final tasks = await getTasks();
    tasks.add(task);

    final tasksJson = tasks.map((t) => t.toJson()).toList();
    await prefs.setString(_tasksKey, jsonEncode(tasksJson));
    
    // Add to sync queue
    await _syncService.addTaskToSyncQueue(task, 'create');
  }

  // Get all tasks
  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString(_tasksKey);

    if (tasksString == null) return [];

    final tasksJson = jsonDecode(tasksString) as List;
    return tasksJson.map((json) => Task.fromJson(json)).toList();
  }

  // Get active tasks (not completed)
  Future<List<Task>> getActiveTasks() async {
    final tasks = await getTasks();
    return tasks.where((task) => !task.isCompleted).toList();
  }

  // Get completed tasks
  Future<List<Task>> getCompletedTasks() async {
    final tasks = await getTasks();
    return tasks.where((task) => task.isCompleted).toList();
  }

  // Update a task
  Future<void> updateTask(Task updatedTask) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == updatedTask.id);

    if (index != -1) {
      tasks[index] = updatedTask;
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = tasks.map((t) => t.toJson()).toList();
      await prefs.setString(_tasksKey, jsonEncode(tasksJson));
      
      // Add to sync queue
      await _syncService.addTaskToSyncQueue(updatedTask, 'update');
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    final tasks = await getTasks();
    final taskToDelete = tasks.firstWhere((t) => t.id == taskId);
    tasks.removeWhere((t) => t.id == taskId);

    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((t) => t.toJson()).toList();
    await prefs.setString(_tasksKey, jsonEncode(tasksJson));
    
    // Add to sync queue
    await _syncService.addTaskToSyncQueue(taskToDelete, 'delete');
  }

  // Mark task as completed
  Future<void> completeTask(String taskId) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == taskId);

    if (index != -1) {
      final task = tasks[index];
      final updatedTask = task.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      tasks[index] = updatedTask;

      final prefs = await SharedPreferences.getInstance();
      final tasksJson = tasks.map((t) => t.toJson()).toList();
      await prefs.setString(_tasksKey, jsonEncode(tasksJson));
    }
  }

  // Increment completed pomodoros for a task
  Future<void> incrementTaskPomodoros(String taskId) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == taskId);

    if (index != -1) {
      final task = tasks[index];
      final updatedTask = task.copyWith(
        completedPomodoros: task.completedPomodoros + 1,
      );
      tasks[index] = updatedTask;

      final prefs = await SharedPreferences.getInstance();
      final tasksJson = tasks.map((t) => t.toJson()).toList();
      await prefs.setString(_tasksKey, jsonEncode(tasksJson));
    }
  }

  // Get tasks by priority
  Future<List<Task>> getTasksByPriority(int priority) async {
    final tasks = await getActiveTasks();
    return tasks.where((task) => task.priority == priority).toList();
  }

  // Get tasks by category
  Future<List<Task>> getTasksByCategory(String category) async {
    final tasks = await getActiveTasks();
    return tasks.where((task) => task.category == category).toList();
  }

  // Get overdue tasks
  Future<List<Task>> getOverdueTasks() async {
    final tasks = await getActiveTasks();
    return tasks.where((task) => task.isOverdue).toList();
  }

  // Get task statistics
  Future<Map<String, dynamic>> getTaskStatistics() async {
    final tasks = await getTasks();
    final activeTasks = tasks.where((t) => !t.isCompleted).toList();
    final completedTasks = tasks.where((t) => t.isCompleted).toList();

    int totalEstimatedPomodoros = 0;
    int totalCompletedPomodoros = 0;

    for (final task in tasks) {
      totalEstimatedPomodoros += task.estimatedPomodoros;
      totalCompletedPomodoros += task.completedPomodoros;
    }

    return {
      'totalTasks': tasks.length,
      'activeTasks': activeTasks.length,
      'completedTasks': completedTasks.length,
      'overdueTasks': activeTasks.where((t) => t.isOverdue).length,
      'totalEstimatedPomodoros': totalEstimatedPomodoros,
      'totalCompletedPomodoros': totalCompletedPomodoros,
      'completionRate':
          tasks.isEmpty ? 0.0 : (completedTasks.length / tasks.length),
    };
  }

  // Get categories
  Future<List<String>> getCategories() async {
    final tasks = await getTasks();
    final categories = tasks
        .where((task) => task.category != null)
        .map((task) => task.category!)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  // Clear all tasks
  Future<void> clearAllTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
  }
}
