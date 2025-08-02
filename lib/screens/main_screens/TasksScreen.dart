import 'package:flutter/material.dart';
import 'package:pomodoro/models/task.dart';
import 'package:pomodoro/services/task_service.dart';
import 'package:pomodoro/services/notification_service.dart';
import 'package:intl/intl.dart';

class TasksScreen extends StatefulWidget {
  static const routeName = '/tasks';
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TaskService _taskService = TaskService();
  final NotificationService _notificationService = NotificationService();

  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  bool _isLoading = true;
  String _filter = 'all'; // 'all', 'active', 'completed', 'overdue'
  String _sortBy = 'priority'; // 'priority', 'created', 'title'

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tasks = await _taskService.getTasks();
      setState(() {
        _tasks = tasks;
        _filteredTasks = _getFilteredTasks();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Task> _getFilteredTasks() {
    List<Task> filtered = [];

    switch (_filter) {
      case 'active':
        filtered = _tasks.where((task) => !task.isCompleted).toList();
        break;
      case 'completed':
        filtered = _tasks.where((task) => task.isCompleted).toList();
        break;
      case 'overdue':
        filtered = _tasks
            .where((task) => !task.isCompleted && task.isOverdue)
            .toList();
        break;
      default:
        filtered = _tasks;
    }

    // Sort tasks
    switch (_sortBy) {
      case 'priority':
        filtered.sort((a, b) => b.priority.compareTo(a.priority));
        break;
      case 'created':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'title':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return filtered;
  }

  void _applyFilter(String filter) {
    setState(() {
      _filter = filter;
      _filteredTasks = _getFilteredTasks();
    });
  }

  void _applySort(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      _filteredTasks = _getFilteredTasks();
    });
  }

  Future<void> _addTask() async {
    final result = await showDialog<Task>(
      context: context,
      builder: (context) => const AddTaskDialog(),
    );

    if (result != null) {
      await _taskService.saveTask(result);
      await _loadTasks();
      _notificationService.showSnackBar(
        context,
        'Task added successfully!',
      );
    }
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    if (task.isCompleted) {
      // Reopen task
      final updatedTask = task.copyWith(
        isCompleted: false,
        completedAt: null,
      );
      await _taskService.updateTask(updatedTask);
    } else {
      // Complete task
      await _taskService.completeTask(task.id);
    }

    await _loadTasks();
    _notificationService.showSnackBar(
      context,
      task.isCompleted ? 'Task reopened!' : 'Task completed! 🎉',
    );
  }

  Future<void> _deleteTask(Task task) async {
    await _notificationService.showCustomDialog(
      context: context,
      title: 'Delete Task',
      message: 'Are you sure you want to delete "${task.title}"?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      onConfirm: () async {
        await _taskService.deleteTask(task.id);
        await _loadTasks();
        _notificationService.showSnackBar(
          context,
          'Task deleted successfully!',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Tasks'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _applySort,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'priority',
                child: Text('Sort by Priority'),
              ),
              const PopupMenuItem(
                value: 'created',
                child: Text('Sort by Created Date'),
              ),
              const PopupMenuItem(
                value: 'title',
                child: Text('Sort by Title'),
              ),
            ],
            child: const Icon(Icons.sort),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildFilterChips(),
                Expanded(
                  child: _filteredTasks.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredTasks.length,
                          itemBuilder: (context, index) {
                            return _buildTaskCard(_filteredTasks[index]);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('all', 'All'),
            const SizedBox(width: 8),
            _buildFilterChip('active', 'Active'),
            const SizedBox(width: 8),
            _buildFilterChip('completed', 'Completed'),
            const SizedBox(width: 8),
            _buildFilterChip('overdue', 'Overdue'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _applyFilter(value);
        }
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildEmptyState() {
    String message = '';
    IconData icon = Icons.task_alt;

    switch (_filter) {
      case 'active':
        message = 'No active tasks';
        icon = Icons.task_alt;
        break;
      case 'completed':
        message = 'No completed tasks';
        icon = Icons.check_circle_outline;
        break;
      case 'overdue':
        message = 'No overdue tasks';
        icon = Icons.schedule;
        break;
      default:
        message = 'No tasks yet';
        icon = Icons.task_alt;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add a new task',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildPriorityIndicator(task),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey[600] : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Text(
                task.description!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 14,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  '${task.completedPomodoros}/${task.estimatedPomodoros} pomodoros',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  DateFormat('MMM dd').format(task.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            if (task.isOverdue && !task.isCompleted)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Overdue',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProgressIndicator(task),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'toggle':
                    _toggleTaskCompletion(task);
                    break;
                  case 'delete':
                    _deleteTask(task);
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'toggle',
                  child: Text(task.isCompleted ? 'Reopen' : 'Complete'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(Task task) {
    return Container(
      width: 8,
      height: 40,
      decoration: BoxDecoration(
        color: task.priorityColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildProgressIndicator(Task task) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        value: task.progress,
        strokeWidth: 3,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(
          task.isCompleted ? Colors.green : task.priorityColor,
        ),
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  int _estimatedPomodoros = 1;
  int _priority = 2;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'Enter task title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter task description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category (Optional)',
                  hintText: 'e.g., Work, Study, Personal',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Estimated Pomodoros: '),
                  Expanded(
                    child: Slider(
                      value: _estimatedPomodoros.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: _estimatedPomodoros.toString(),
                      onChanged: (value) {
                        setState(() {
                          _estimatedPomodoros = value.round();
                        });
                      },
                    ),
                  ),
                  Text(_estimatedPomodoros.toString()),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Priority: '),
                  Expanded(
                    child: SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 1, label: Text('Low')),
                        ButtonSegment(value: 2, label: Text('Medium')),
                        ButtonSegment(value: 3, label: Text('High')),
                      ],
                      selected: {_priority},
                      onSelectionChanged: (Set<int> newSelection) {
                        setState(() {
                          _priority = newSelection.first;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final task = Task(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: _titleController.text,
                description: _descriptionController.text.isEmpty
                    ? null
                    : _descriptionController.text,
                category: _categoryController.text.isEmpty
                    ? null
                    : _categoryController.text,
                createdAt: DateTime.now(),
                estimatedPomodoros: _estimatedPomodoros,
                priority: _priority,
              );
              Navigator.of(context).pop(task);
            }
          },
          child: const Text('Add Task'),
        ),
      ],
    );
  }
}
